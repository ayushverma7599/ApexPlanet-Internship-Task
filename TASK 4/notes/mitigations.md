# Mitigation Notes — Task 4

| # | Finding | Root Cause | Mitigation | Verification |
|---|---|---|---|---|
| 1 | vsftpd 2.3.4 backdoor (RCE) | Backdoored binary in outdated package | Upgrade vsftpd to a current patched release; remove backdoored build | Re-scan port 21/6200 — backdoor listener gone |
| 2 | SSH brute-forceable | Weak default password (`msfadmin:msfadmin`) | Enforce strong password policy; switch to key-based auth; disable `PasswordAuthentication` in `sshd_config` | Hydra re-run fails to find valid creds |
| 3 | Crackable password hashes | Weak passwords + unsalted/weak hashing exposure | Strong, unique passwords; modern hashing; remove unused accounts | John the Ripper re-run yields no cracks within reasonable wordlist/time |
| 4 | Phishing susceptibility | No user awareness training | Deliver phishing-awareness checklist; recommend SPF/DKIM/DMARC + email link scanning | Follow-up simulated phishing test shows improved click-through rate |

## Hardening Commands Applied
```bash
# Patch system
apt update && apt upgrade -y

# Disable an unused/vulnerable service
systemctl disable <service-name>
systemctl stop <service-name>

# Restrict access with iptables (example: only allow SSH from the lab subnet)
iptables -A INPUT -p tcp --dport 22 -s 192.168.187.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP

# Block the vsftpd backdoor port outright
iptables -A INPUT -p tcp --dport 6200 -j DROP

# Harden SSH config (/etc/ssh/sshd_config)
PasswordAuthentication no
PermitRootLogin no
```

## Before / After Attack Surface
Run before and after hardening, and paste both outputs for the report:
```bash
nmap -sV 192.168.187.4
```
