if [[ $# -lt 1 ]]; then
	echo "Syntax: ./ipns-pin.sh <ipns/dnslink name>..."
	exit 1
fi

while true; do
	for name in "$@"; do
		cid=$(ipfs name resolve "$name")
		if [[ $cid ]]; then
			ipfs pin add $cid
		fi
	done
	sleep 3600
done
