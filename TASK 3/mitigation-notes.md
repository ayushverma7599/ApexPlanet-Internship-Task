# Mitigation Notes — Task 3: Web Application Security

Quick-reference mapping of each vulnerability exploited to the fix that closes it. Full narrative, risk ratings, and screenshots are in the PDF/Word report (`Task3_Security_Testing_Report`) and in each attack's own folder.

| # | Vulnerability | Root cause | Fix |
|---|---|---|---|
| 1 | SQL Injection (UNION-based) | User input concatenated directly into SQL query | Parameterized queries / prepared statements; least-privilege DB account; WAF as defense-in-depth |
| 2 | Stored XSS | Guestbook message rendered without output encoding | Output-encode on render (`htmlspecialchars`/template auto-escape); input validation; Content-Security-Policy |
| 3 | CSRF | No anti-CSRF token on password-change form; state change accepted via GET | Per-session/per-form anti-CSRF tokens validated server-side; `SameSite=Strict` session cookie; re-auth before sensitive actions |
| 4 | Local File Inclusion | `page` parameter passed straight into `include()` | Whitelist of allowed page keys; reject path separators/null bytes; `allow_url_include=Off`; restrict filesystem permissions of the web user |
| 5 | Weak login / no rate limiting (via Burp Intruder) | No lockout, identical response size not enforced | Account lockout / exponential backoff; CAPTCHA after N failures; identical failure response size & timing |
| 6 | Missing security headers | Apache not configured to emit protective headers | `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Content-Security-Policy: default-src 'self'` — verified before/after with `curl -I` |

## Mitigations demonstrated with before/after evidence in this submission
- **Security headers** (#6) — only one fully re-tested end-to-end (`headers/01_before...png` → `headers/02_after...png`).

## Mitigations recommended but not re-tested against a hardened build
SQLi, XSS, CSRF, LFI and the login rate-limiting fix are documented with the correct remediation, but DVWA's "high" security level (which implements several of these fixes) was not re-exploited and re-screenshotted for every module in this round. Flagging this explicitly rather than implying full before/after coverage everywhere.
