#!/bin/bash

# Configuration - Update the wordlist path to your preference
WORDLIST="/usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-big.txt"

# Check if at least one IP was provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <ip1> <ip2> <ip3> ..."
    exit 1
fi

# Loop through all provided IPs
for TARGET in "$@"; do
    echo "======================================"
    echo "[+] Target: $TARGET"
    echo "======================================"

    OUTDIR="scan_$TARGET"
    mkdir -p "$OUTDIR"

    MASSCAN_OUT="$OUTDIR/masscan_$TARGET.txt"
    NMAP_TXT="$OUTDIR/nmap_$TARGET.txt"
    NMAP_GNMAP="$OUTDIR/nmap_$TARGET.gnmap"
    FFUF_FINAL_OUT="$OUTDIR/ffuf_$TARGET.txt"

    # Initialize/Clear the final output file
    > "$FFUF_FINAL_OUT"

    echo "[+] Running Masscan on $TARGET ..."
    sudo masscan -p0-65535 "$TARGET" --rate 10000 -oG "$MASSCAN_OUT"

    # Extracting open ports for Nmap
    ports=$(grep "Ports:" "$MASSCAN_OUT" | awk '{print $7}' | cut -d'/' -f1 | paste -sd, -)

    if [ -z "$ports" ]; then
        echo "[-] No open ports found on $TARGET"
        continue
    fi

    echo "[+] Open ports found: $ports"
    echo "[+] Running Nmap service detection..."
    nmap -sV -p "$ports" "$TARGET" -oN "$NMAP_TXT" -oG "$NMAP_GNMAP"

    # Extract only ports identified as 'http' or 'https'
    HTTP_PORTS=$(grep "/open/tcp//http" "$NMAP_GNMAP" | grep -oP '\d+(?=/open/tcp//http)')

    if [ -z "$HTTP_PORTS" ]; then
        echo "[-] No HTTP services detected for fuzzing on $TARGET"
    else
        for PORT in $HTTP_PORTS; do
            # Determine if it's SSL/HTTPS
            PROTO="http"
            if grep -q "$PORT/open/tcp//ssl|http" "$NMAP_GNMAP"; then
                PROTO="https"
            fi

            echo "[!] Starting ffuf on $PROTO://$TARGET:$PORT ..."
            
            # -o saves the result to the file
            # -of md ensures the file is formatted as Markdown for readability
            # ffuf will still show results on your screen automatically
            ffuf -w "$WORDLIST" \
                 -u "$PROTO://$TARGET:$PORT/FUZZ" \
                 -mc 200,204,301,302,307,401,403 \
                 -o "$FFUF_FINAL_OUT" -of md
        done
    fi

    echo "---"
    echo "[+] Results saved to: $FFUF_FINAL_OUT"
    echo "[+] Scan complete for $TARGET"
done
