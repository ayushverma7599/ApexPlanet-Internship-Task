# Task 3 — Web Application Security (ApexPlanet Cybersecurity Internship)

OWASP Top 10 testing against **DVWA** (security level: low unless noted), attacking from a Kali Linux VM into a Metasploitable2 target on an isolated host-only lab network (`192.168.187.4`).

## Structure
```
sqli/              Boolean + UNION-based SQL injection, schema enumeration
xss/               Stored XSS in the guestbook module
csrf/              Admin password-change CSRF (crafted URL + auto-submitting attacker page)
file-inclusion/    Local File Inclusion (/etc/passwd disclosure)
burp/              Proxy request tampering + Intruder password fuzzing
headers/           Security-header audit, fix, and verified before/after
mitigation-notes.md   Quick-reference table of root cause → fix for every finding
```
Each attack folder has its own `payloads.md` with the exact payloads/commands used and a short write-up, plus the supporting screenshots.

## Full report
See `Task3_Security_Testing_Report.docx` / `.pdf` for the formatted report: objective, payload, exploit evidence, fix, and production-risk rating for every finding, with a summary table at the end.

## Scope & safety
All testing was confined to a private, host-only virtual lab (DVWA + Metasploitable2, no internet route). No production systems, real user data, or third-party infrastructure were touched.
