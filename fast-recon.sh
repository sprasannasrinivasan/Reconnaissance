#!/bin/bash

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
    NMAP_OUT="$OUTDIR/nmap_$TARGET.txt"

    echo "[+] Running Masscan on $TARGET ..."
    sudo masscan -p0-65535 "$TARGET" --rate 10000 -oG "$MASSCAN_OUT"

    echo "[+] Extracting open ports ..."
    ports=$(grep "Ports:" "$MASSCAN_OUT" | awk '{print $7}' | cut -d'/' -f1 | paste -sd, -)

    if [ -z "$ports" ]; then
        echo "[-] No open ports found on $TARGET"
        continue
    fi

    echo "[+] Open ports found on $TARGET: $ports"
    echo "[+] Running detailed Nmap scan ..."

    nmap -A -sS -sV -sC -p "$ports" "$TARGET" -oN "$NMAP_OUT"

    echo "[+] Scan complete for $TARGET"
done
