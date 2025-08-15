ipfs pin ls | while read -r cid type; do
	if [[ $type == "recursive" ]]; then
		ipfs pin rm "$cid"
	fi
done
