# Stored XSS — Payloads

Target: `http://192.168.187.4/dvwa/vulnerabilities/xss_s/` (DVWA guestbook, security level: low)

## Payload
```html
<script>alert('Stored XSS - Ayush')</script>
```
Submitted into the **Message** field of the guestbook form (Name: `Ayush`).

## Behaviour observed
1. Fires immediately on submission (`01_stored_xss_payload_fires.png`).
2. Fires again on every page reload with no further input from the attacker, and for any visitor who loads the page (`02_stored_xss_persists_reload.png`) — this is what distinguishes **stored** XSS from reflected XSS.
3. Guestbook entry list shows the stored rows persisting server-side (`03_guestbook_entries_persisted.png`).

## Variant worth testing in a full engagement
Reflected XSS via query parameters on `xss_r/`, e.g.:
```
http://192.168.187.4/dvwa/vulnerabilities/xss_r/?name=<script>alert(1)</script>
```
