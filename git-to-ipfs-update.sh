#!/usr/bin/env bash

if [[ ! $2 ]]; then
	echo "Syntax: ./git-to-ipfs-update.sh <repo url> <pack folder>"
	exit 1
fi

# init bare clone
rm -r tmp.git
git clone --mirror $1 tmp.git
cd tmp.git

# unpack objects
mv objects/pack/*.pack .
git unpack-objects < *.pack
rm -f *.pack objects/pack/*

# reinsert already uploaded pack(s)
cd ..
cp $2/* tmp.git/objects/pack
cd tmp.git

# remove duplicate objects
git prune-packed

# enable usage via dumb http
git update-server-info

# publish to ipfs
if [[ $(ipfs add -r . | tail -n 1) =~ added\ (.+)\  ]]; then
	cid="${BASH_REMATCH[1]}"
	echo $cid
	ipfs pin add $cid > /dev/null
	ipfs routing provide $cid
fi

# deinit bare clone
cd ..
rm -r tmp.git
