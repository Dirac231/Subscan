## What is this?
Subscan is a bash function used to easily find subdomains of a large scope target.\
\
The tool is built so to enforce passive analysis and to balance active analysis, in order to be light on the network and relatively fast in producing results.

## Requirements
You will need quite a few extra programs to make it work:
- amass
- subfinder
- assetfinder
- waybackurls
- gauplus
- anew
- seclists
- puredns
- gotator
- unimap
- httpx
- unfurl
- cero

## How to use
Paste the function in ```subscan.sh``` in your ```~/.bashrc``` file or equivalent, then "source" the file and use the tool with this example syntax:
```
subscan top_domain_example.com
```
I recommend running the tool inside a folder specifically used for subdomain enumeration, once it finishes, it will be clear what files to look.
