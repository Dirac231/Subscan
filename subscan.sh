subscan(){
    echo -e "\nPASSIVE SOURCE ENUMERATION + DNS RESOLVING\n"
    amass enum -passive -d $1 | anew -q subdomains
    subfinder -d $1 | anew -q subdomains
    assetfinder --subs-only $1 | anew -q subdomains
    waybackurls $1 | unfurl -u domains | anew -q subdomains
    gauplus -t 5 -random-agent -subs $1 |  unfurl -u domain | anew -q subdomains

    echo -e "\nRESOLVING...\n"
    sudo wget https://raw.githubusercontent.com/BonJarber/fresh-resolvers/main/resolvers.txt -O /usr/share/seclists/Discovery/DNS/resolvers.txt
    puredns resolve subdomains -r /usr/share/seclists/Discovery/DNS/resolvers.txt -w tmp_puredns; cat tmp_puredns | anew -q resolved.txt; rm tmp_puredns

    gotator -sub resolved.txt -perm ~/OSCP/WORDLISTS/DNS_perm -depth 1 -numbers 10 -mindup -adv -md | anew -q resolved.txt
    puredns resolve resolved.txt -r /usr/share/seclists/Discovery/DNS/resolvers.txt -w tmp_puredns;cat tmp_puredns | anew -q resolved.txt

    echo -e "\nBRUTEFORCING DNS + SSL ANALYSIS\n"
    puredns bruteforce ~/OSCP/WORDLISTS/DNS.txt $1 -r /usr/share/seclists/Discovery/DNS/resolvers.txt -w tmp_puredns && cat tmp_puredns | anew -q resolved.txt && rm tmp_puredns
    while read p; do cero $p | sed 's/^*.//' | grep -e "\." | grep $1 | anew -q resolved.txt; done < resolved.txt

    echo -e "\nWEB ANALYSIS\n"
    COMMON_PORTS_WEB="81,300,591,593,832,981,1010,1311,1099,2082,2095,2096,2480,3000,3128,3333,4243,4567,4711,4712,4993,5000,5104,5108,5280,5281,5601,5800,6543,7000,7001,7396,7474,8000,8001,8008,8014,8042,8060,8069,8080,8081,8083,8088,8090,8091,8095,8118,8123,8172,8181,8222,8243,8280,8281,8333,8337,8443,8500,8834,8880,8888,8983,9000,9001,9043,9060,9080,9090,9091,9200,9443,9502,9800,9981,10000,10250,11371,12443,15672,16080,17778,18091,18092,20720,32000,55440,55672"
    sudo unimap --fast-scan -f resolved.txt --ports $COMMON_PORTS_WEB -q -k --url-output > unimap_commonweb.txt
    cat unimap_commonweb.txt | httpx -fr -follow-host-redirects -random-agent -mc 200,204,304,401,403,500 -sc -td -o web_domains.txt
    cat web_domains.txt | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" > urls.txt
}
