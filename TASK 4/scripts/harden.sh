#!/bin/bash
# harden.sh — System hardening steps applied to the target after exploitation
# Run ON the target VM (Metasploitable2 or a hardened clone of it)

echo "[*] Updating packages"
apt update && apt upgrade -y

echo "[*] Blocking the vsftpd 2.3.4 backdoor port"
iptables -A INPUT -p tcp --dport 6200 -j DROP

echo "[*] Restricting SSH to the lab subnet only"
iptables -A INPUT -p tcp --dport 22 -s 192.168.187.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP

echo "[*] Disabling unused/vulnerable services (edit list as needed)"
for svc in telnet rlogin rsh; do
  systemctl disable "$svc" 2>/dev/null
  systemctl stop "$svc" 2>/dev/null
done

echo "[*] Hardening SSH config — review /etc/ssh/sshd_config manually and set:"
echo "    PasswordAuthentication no"
echo "    PermitRootLogin no"
echo "[*] Then: systemctl restart sshd"

echo "[*] Done. Re-run recon.sh against this host to confirm reduced attack surface."
