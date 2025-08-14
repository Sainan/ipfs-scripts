Scripts to simplify certain IPFS operations:
- **dnslink-pin** takes one or more dnslink addresses, resolves them, pins them, and then does it again every hour. Perfect to support/distribute more dynamic content.
- **git-to-ipfs** takes a repo URL, adds it to IPFS, and pins it. This basically follows [the official IPFS git guide](https://docs.ipfs.tech/how-to/host-git-repo/) with the addition of pinning.
