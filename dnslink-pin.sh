#!/usr/bin/env bash

be8() {
	printf "\\$(printf '%03o' "$1")";
}

be16() {
	local v=$1
	local hi=$(( (v >> 8) & 255 ))
	local lo=$(( v & 255 ))
	printf "\\$(printf '%03o' "$hi")\\$(printf '%03o' "$lo")"
}

pack_dns_name() {
	local IFS=. chunk len
	read -ra parts <<< "$1"
	for chunk in "${parts[@]}"; do
		be8 "${#chunk}" >> /tmp/dnspacket
		printf "%s" "$chunk" >> /tmp/dnspacket
	done
	printf '\0' >> /tmp/dnspacket
}

dnslink_to_cid() {
	printf '' > /tmp/dnspacket
	be16 0 >> /tmp/dnspacket
	be16 256 >> /tmp/dnspacket
	be16 1 >> /tmp/dnspacket
	be16 0 >> /tmp/dnspacket
	be16 0 >> /tmp/dnspacket
	be16 0 >> /tmp/dnspacket

	pack_dns_name "_dnslink.$1" >> /tmp/dnspacket
	be16 16 >> /tmp/dnspacket
	be16 1 >> /tmp/dnspacket

	#cat /tmp/dnspacket | od -An -t x1

	b64url=$(base64 < /tmp/dnspacket | tr -d '\n' | tr '+/' '-_' | tr -d '=')
	wget -qO- "https://1.1.1.1/dns-query?dns=${b64url}" > /tmp/dnspacket

	#cat /tmp/dnspacket | od -An -t x1

	grep -aoP '(?<=dnslink=/ipfs/)([A-Za-z0-9]+)' /tmp/dnspacket | head -n1
}

if [[ $# -lt 1 ]]; then
	echo "Syntax: ./dnslink-pin.sh <dnslink>..."
	exit 1
fi

while true; do
	for dnslink in "$@"; do
		cid=$(dnslink_to_cid "$dnslink")
		if [[ $cid ]]; then
			ipfs pin add $cid
		fi
	done
	sleep 3600
done
