Scripts to simplify certain IPFS operations

## git-to-ipfs.sh

This is an all-in-one script to **statelessly mirror a Git repository to IPFS** based on [the official guide](https://docs.ipfs.tech/how-to/host-git-repo/), also pinning the CID. Perfectly fine for small repos or when statelessness is important.

This script prints only the CID on success, so you can easily use this in your own scripts, e.g. to publish the updated CID to IPNS:
```bash
cid=$(./git-to-ipfs.sh https://github.com/Sainan/ipfs-scripts)
ipfs name publish --key=ipfs-scripts $cid
```

You can use [Gitview](https://sainan.github.io/gitview/) to explore such a repo.

## git-to-ipfs-init.sh & git-to-ipfs-update.sh

These scripts **statefully mirror a Git repository to IPFS**. Recommended for big repos.

For the initial import, run the init script, e.g. `./git-to-ipfs-init.sh https://github.com/Sainan/ipfs-scripts`. As per above, it only prints the CID on success, but it also produces a `pack` folder. You are recommended to rename this, e.g. `myrepo-pack`.

To later push updates, run the update script, e.g. `./git-to-ipfs-update.sh https://github.com/Sainan/ipfs-scripts myrepo-pack`. Again, it only prints the CID on success.
