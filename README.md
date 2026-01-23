# AutoRecon Fuzzer

A lightweight Bash automation script designed for rapid reconnaissance. It chains high-speed port scanning with service fingerprinting and web directory fuzzing.

### 🚀 Workflow

1. **Masscan**: Scans all 65,535 TCP ports at high speed (`10,000 p/s`).
2. **Nmap**: Performs service version detection (`-sV`) only on the open ports identified by Masscan.
3. **Service Filtering**: Automatically identifies HTTP/HTTPS services.
4. **ffuf**: Launches directory brute-forcing against discovered web services using a specified wordlist.

---

### 🛠️ Prerequisites

Ensure the following tools are installed and available in your `$PATH`:

* `masscan`
* `nmap`
* `ffuf`

You will also need a wordlist. The script defaults to:
`/usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-big.txt`

---

### 📦 Installation & Setup

1. **Clone the repository:**
```bash
git clone https://github.com/sprasannasrinivasan/Reconnaissance.git
cd Reconnaissance

```


2. **Make the script executable:**
```bash
chmod +x fast-recon.sh

```


3. **Update the Wordlist Path (Optional):**
Open `fast-recon.sh` and edit the `WORDLIST` variable to point to your local SecLists or custom wordlist.

---

### 📖 Usage

Run the script by providing one or more IP addresses as arguments. Since Masscan requires raw socket access, you may be prompted for sudo privileges.

```bash
sudo ./fast-recon.sh 192.168.1.1 10.0.0.50

```

#### Output Structure

The script creates a dedicated directory for every target to keep results organized:

```text
.
├── scan_192.168.1.1/
│   ├── masscan_192.168.1.1.txt    # Raw Masscan grepable output
│   ├── nmap_192.168.1.1.gnmap      # Nmap service detection results
│   └── ffuf_192.168.1.1.txt        # Final fuzzing results (Markdown format)

```

---

### ⚠️ Disclaimer

This tool is intended for **authorized security auditing and educational purposes only**. Unauthorized scanning of remote systems is illegal. The user assumes all responsibility for the use of this software.
