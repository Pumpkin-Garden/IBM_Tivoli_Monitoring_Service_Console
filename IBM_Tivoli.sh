RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

> vuln_result_Tivoli.txt

function check_set_cookie
{
    while IFS= read -r line
    do
        url=`echo $line | cut -d' ' -f 1`
        check_http_vuln=`curl -s -k -v -m 5 --connect-timeout 2 "$url" 2>&1 | grep "Set-Cookie"`
        if [[ $? -eq 0 ]]
        then
            echo -e "\t${RED}[!] Vulnerable $line ${NC}"
            echo "Vulnerable $line" >> vuln_result_Tivoli.txt
        else
            echo -e "\t$line"
        fi 
    done < <(printf '%s\n' "$1")
}

while read line
do
    # USE HTTP
    echo -e "${YELLOW}[!] ${GREEN}Check host $line ${NC}"
    data_http=`curl -s -k -m 5 --connect-timeout 5 http://$line/ --user-agent "Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0" | sed "s/<a /\n/g" | sed "s/<\/a>/\n/g" | tr -d '"' | grep href`
    if [[ $? -ne 1 ]]
    then
        echo -e "${YELLOW}HTTP Work - http://$line ${NC}"
        data_http=`echo -e "$data_http" | sed "s/href=/http:\/\/$line/g" | sed "s/>/ - /g"`
        check_set_cookie "$data_http"
    else
        # USE HTTPS
        data_http=`curl -s -k -m 5 --connect-timeout 5 https://$line/ --user-agent "Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0" | sed "s/<a /\n/g" | sed "s/<\/a>/\n/g" | tr -d '"' | grep href`
        if [[ $? -ne 1 ]]
        then
            echo -e "${YELLOW}HTTPS Work - https://$line ${NC}"
            data_http=`echo -e "$data_http" | sed "s/href=/http:\/\/$line/g" | sed "s/>/ - /g"`
            check_set_cookie "$data_http"
        else
            # Service disabled
            echo -e "${YELLOW}Service disabled${NC}"
        fi
    fi

done < hosts.txt
