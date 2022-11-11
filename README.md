# This script detects IBM Tivoli Monitoring Service Console web consoles that are affected by the Authentication Bypass vulnerability

Before running the script, the list of hosts to be scanned must be specified in hosts .txt in the format IP:PORT

For start:
```
chmod 700 IBM_Tivoli.sh
./IBM_Tivoli.sh
```

The script outputs to the terminal, and also writes the detected vulnerable services to the vuln_result_Tivoli.txt file

P.S.: so far I don't know what this error is related to or if there is a CVE for this. **This error is quite rare.**

> All written for educational purposes only
