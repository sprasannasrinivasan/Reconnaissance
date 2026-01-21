# Fast Recon: Masscan + Nmap Automator

A high-speed port discovery and service enumeration script. This tool leverages the extreme speed of **Masscan** to identify open ports across the full TCP range (0-65535) and then pipes those specific ports into **Nmap** for deep aggressive scanning (`-A`).

## 🚀 How It Works

Scanning 65,535 ports with Nmap alone is time-consuming. This script optimizes the workflow:

1. **Masscan Phase:** Rapidly identifies any "live" TCP ports at a rate of 10,000 packets/sec.
2. **Parsing Phase:** Extracts the specific open ports and formats them for Nmap.
3. **Nmap Phase:** Runs a detailed scan (Service Versioning, Script Scanning, OS Detection) *only* on the ports found in Phase 1.

## 📋 Prerequisites

Ensure you have the following tools installed on your Kali/Linux system:

* **Masscan:** `sudo apt install masscan`
* **Nmap:** `sudo apt install nmap`

## 🛠 Usage

Give the script execution permissions and run it by passing one or more target IP addresses.

```bash
chmod +x fast-recon.sh
sudo ./fast-recon.sh <Target-IP> <Target-IP-2>

```

> **Note:** `sudo` is required because Masscan uses a custom TCP/IP stack to achieve high speeds.

## 📂 Output Structure

The script creates a dedicated directory for each target to keep your workspace organized:

```text
scan_<Target-IP>/
├── masscan_<Target-IP>.txt   # Greppable Masscan results
└── nmap_<Target-IP>.txt      # Human-readable Nmap report

```

## ⚠️ Disclaimer

This tool is for educational and authorized security testing purposes only. Scanning networks you do not have explicit permission to test is illegal.