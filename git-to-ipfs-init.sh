#!/usr/bin/env bash

if [[ ! $1 ]]; then
	echo "Syntax: ./git-to-ipfs-init.sh <repo url>"
	exit 1
fi

# init bare clone
rm -r tmp.git
git clone --mirror $1 tmp.git
cd tmp.git

# copy packs
mkdir ../pack
cp objects/pack/* ../pack

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
