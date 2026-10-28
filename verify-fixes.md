# Verifying Fixes — Re-test at DVWA Security Level "High"

DVWA ships three security levels (low/medium/high) that progressively apply the real fixes
in its own source code. Switching to "high" and re-running the exact same payloads from
the report turns every "recommended fix" into a "verified fix" with a blocked-attempt
screenshot. Do this for all four, in this order — it's about 15 minutes total.

## 0. Switch the level once
1. Log into DVWA → **DVWA Security** (left nav).
2. Set **Script Security** to `high` → **Submit**.
3. Confirm the page footer now reads `Security Level: high` before each test below.

---

## 1. SQL Injection (high)
- Go to **SQL Injection**. At "high," the ID field is no longer a free-text box with the
  same URL pattern — it's often a dropdown, and the backend wraps input in quotes/casts
  it to an integer, which breaks the `OR '1'='1` and `UNION SELECT` payloads.
- Try the same payload anyway by editing the URL directly:
  ```
  http://192.168.187.4/dvwa/vulnerabilities/sqli/?id=1%27+OR+%271%27%3D%271&Submit=Submit#
  ```
- **Screenshot to capture:** the single-row result (or SQL error / no extra rows), proving
  the UNION/OR trick no longer dumps the table. Save as `sqli/04_high_security_blocked.png`.

## 2. Stored XSS (high)
- Go to **XSS stored**. At "high," DVWA runs `htmlspecialchars()` (or similar) and strips
  `<script>` tags from the Name field; the Message field still allows some HTML in older
  DVWA builds, so test both fields with:
  ```html
  <script>alert('still works?')</script>
  ```
- **Screenshot to capture:** the guestbook entry showing the payload printed as literal
  text (e.g. `&lt;script&gt;alert(...)&lt;/script&gt;`) instead of executing. Save as
  `xss/04_high_security_blocked.png`.

## 3. CSRF (high)
- Go to **CSRF**. At "high," DVWA checks the `Referer` header on the password-change
  request and rejects it if the request didn't originate from the DVWA page itself.
- Re-run the exact same `csrf_attack.html` file from before (no changes needed — that's
  the point, you're testing whether the *existing* attacker page still works).
- **Screenshot to capture:** either an explicit error/rejection message, or — if DVWA
  fails silently — reload the CSRF page afterward and show the password was **not**
  changed (e.g. attempt to log in with the "hacked" password and show `Login failed`).
  Save as `csrf/06_high_security_referer_check.png`.

## 4. Local File Inclusion (high)
- Go to **File Inclusion**. At "high," DVWA only allows `include.php` and `file*.php`
  as the page value (prefix whitelist).
- Re-try:
  ```
  http://192.168.187.4/dvwa/vulnerabilities/fi/?page=/etc/passwd
  ```
- **Screenshot to capture:** the warning/blank page instead of `/etc/passwd` contents.
  Save as `file-inclusion/03_high_security_blocked.png`.

---

## After capturing
Drop the four new screenshots into their respective folders (paths above already match
the repo layout), then tell me and I'll:
1. Add a "Fix verified" subsection with each screenshot into the corresponding section
   of `Task3_Security_Testing_Report.docx`.
2. Flip those four rows in the summary table from "Recommended — not re-tested" to
   "Yes — verified."
3. Update `mitigation-notes.md` to match.
