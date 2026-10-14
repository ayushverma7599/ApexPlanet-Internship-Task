# Metasploitable 2 — Network Scan & Vulnerability Assessment

A penetration-testing lab exercise against **Metasploitable 2**, a deliberately vulnerable Linux VM, using **Nmap** (port/service/OS discovery + NSE vulnerability scripts) and **Nessus** for vulnerability scanning, with traffic captured via Wireshark/tcpdump for analysis.

> **Target:** `192.168.187.4` (Metasploitable 2, isolated lab network — VirtualBox host-only adapter)
> **Attacker host:** Kali Linux
> **Scope:** Authorized lab environment only. No part of this assessment was conducted outside an isolated virtual network.

---

## 📁 Repository Structure

```
metasploitable2-pentest/
├── README.md
├── reports/
│   ├── nmap/
│   │   ├── scan_report.txt          # TCP SYN + service/version + OS detection scan
│   │   └── scan_report_udp.txt      # UDP top-10 ports scan
│   ├── nmap_vuln/
│   │   └── vuln_report.txt          # Nmap NSE --script vuln output
│   └── nessus/
│       └── Task2-Metasploitable.pdf # Nessus vulnerability scan report
├── pcap/
│   └── task2_capture.pcapng         # Packet capture of the scanning/exploitation traffic
├── findings/
│   └── vulnerability-summary.md     # Consolidated CVE table with severity & exploitability
├── screenshots/
│   └── ...                          # Exploit proof, terminal output, service banners
├── demo/
│   └── video-link.md                # Link to the 5-minute demo video
└── LICENSE
```

---

## 🔍 Methodology

1. **Reconnaissance (TCP)** — Full SYN scan with service/version detection and OS fingerprinting:
   ```
   nmap --privileged -sS -sV -O -T5 --max-retries 1 --host-timeout 60s -oN scan_report.txt 192.168.187.4
   ```
2. **Reconnaissance (UDP)** — Top 10 UDP ports:
   ```
   nmap --privileged -sU --top-ports 10 -T4 -oN scan_report_udp.txt 192.168.187.4
   ```
3. **Vulnerability scripting** — Nmap's built-in NSE vulnerability category:
   ```
   nmap --privileged --script vuln -oN vuln_report.txt 192.168.187.4
   ```
4. **Vulnerability scanning** — Full Nessus scan against the same host, exported as PDF.
5. **Traffic capture** — All scan and exploitation traffic captured with Wireshark (`task2_capture.pcapng`) for packet-level verification and demo purposes.

---

## 🖥️ Open Ports & Services (TCP)

| Port | Service | Version |
|------|---------|---------|
| 21   | ftp | vsftpd 2.3.4 |
| 22   | ssh | OpenSSH 4.7p1 Debian 8ubuntu1 |
| 23   | telnet | Linux telnetd |
| 25   | smtp | Postfix smtpd |
| 53   | domain | ISC BIND 9.4.2 |
| 80   | http | Apache httpd 2.2.8 (Ubuntu DAV/2) |
| 111  | rpcbind | RPC #100000 |
| 139/445 | netbios-ssn | Samba smbd 3.X–4.X |
| 512/513/514 | exec/login/shell | rexecd / rlogind / rshd |
| 1099 | java-rmi | GNU Classpath grmiregistry |
| 1524 | bindshell | Metasploitable root shell |
| 2049 | nfs | RPC #100003 |
| 2121 | ftp | ProFTPD 1.3.1 |
| 3306 | mysql | MySQL 5.0.51a-3ubuntu5 |
| 5432 | postgresql | PostgreSQL 8.3.0–8.3.7 |
| 5900 | vnc | protocol 3.3 |
| 6000 | X11 | access denied |
| 6667 | irc | UnrealIRCd |
| 8009 | ajp13 | Apache Jserv 1.3 |
| 8180 | http | Apache Tomcat/Coyote JSP 1.1 |

**Host:** Linux 2.6.9–2.6.33 · MAC `08:00:27:22:55:8F` (VirtualBox NIC)

---

## 🚨 Key Vulnerabilities

| Severity | Finding | CVE / Ref | Port | Notes |
|---|---|---|---|---|
| Critical | vsFTPd 2.3.4 backdoor | CVE-2011-2523 | 21 | Remote root shell, no auth |
| Critical | Bind shell backdoor | — | 1524 | Root shell with no auth |
| High | Samba Badlock | CVE-2016-2118 | 139/445 | Samba 3.X–4.X |
| High | ISC BIND downgrade/reflected DoS | — | 53 | BIND 9.4.2 (EOL) |
| High | SSL/TLS CCS Injection | CVE-2014-0224 | 5432 | PostgreSQL TLS |
| Medium | ISC BIND DoS | — | 53 | BIND 9.4.2 |
| Medium | POODLE | CVE-2014-3566 | 25, 5432 | SSLv3 padding oracle |
| Medium | Logjam / weak DH | CVE-2015-4000 | 25, 5432 | 512–1024-bit DH groups |
| Medium | Slowloris DoS | CVE-2007-6750 | 8180 | Tomcat likely vulnerable |
| Low | Exposed admin/test interfaces | — | 80 | phpMyAdmin, phpinfo.php, TikiWiki, DVWA, Mutillidae |
| Low | CSRF | — | 80 | DVWA & Mutillidae login/forms |
| Low | ICMP timestamp disclosure | — | — | Remote date disclosure |
| Info | rlogin/rexec/rsh exposed | — | 512–514 | No-password root login path |

See [`findings/vulnerability-summary.md`](findings/vulnerability-summary.md) for the full table including Nessus CVSS/VPR/EPSS scores.

---

## 🎥 Demo Video

A 5-minute walkthrough demonstrating the scan execution and resulting findings is linked in [`demo/video-link.md`](demo/video-link.md).

---

## ⚠️ Disclaimer

This assessment was performed exclusively against **Metasploitable 2**, an intentionally vulnerable machine distributed for security training, inside an **isolated host-only virtual network**. None of the techniques, exploits, or scan results documented here were used against systems outside this lab environment. This repository is for educational purposes only.

---

## 🛠️ Tools Used

- **Nmap 7.99** — port scanning, service/version detection, OS fingerprinting, NSE vulnerability scripts
- **Nessus (Tenable)** — automated vulnerability scanning
- **Wireshark** — packet capture and traffic analysis
- **VirtualBox** — isolated lab network (Kali Linux attacker + Metasploitable 2 target)
