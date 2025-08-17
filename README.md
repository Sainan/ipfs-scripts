Scripts to simplify certain IPFS operations

## git-to-ipfs.sh

This is an all-in-one script to **mirror a Git repository to IPFS** based on [the official guide](https://docs.ipfs.tech/how-to/host-git-repo/) but it also pins the CID. Additionally, you can easily use this in your own scripts, e.g. to publish the updated CID to IPNS:
```bash
cid=$(./git-to-ipfs.sh https://github.com/Sainan/ipfs-scripts)
ipfs name publish --key=ipfs-scripts $cid
```
