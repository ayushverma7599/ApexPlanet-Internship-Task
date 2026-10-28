# Burp Suite — Request Tampering & Intruder Fuzzing

Target: `http://192.168.187.4/dvwa/login.php`

## 1. Intercept & tamper
1. Proxy intercept ON, browser routed through Burp (127.0.0.1:8080).
2. Submitted login form (`admin` / `password`) — captured raw POST in Proxy > Intercept (`01_proxy_intercept_login_post.png`).
3. Edited `username=admin` → `username=admin123` in-flight, forwarded the modified request (`02_request_tampered_username.png`).
4. Server correctly rejected it — `Login failed` (`03_tampered_request_login_failed.png`) — confirms request tampering is possible but server-side validation still holds for this specific change.

## 2. Intruder — sniper attack on `password`
- Sent the captured login POST to Intruder, attack type **Sniper**.
- Payload position marked around the `password` parameter value (`04_intruder_sniper_setup.png`, `05_intruder_payload_position.png`).
- Payload list (simple list, Community Edition — demo-rate-limited):
  ```
  12345
  letmein
  qwerty
  password
  ```
- Results (`06_intruder_results.png`, detail in `07_intruder_request_response_detail.png`):

  | Payload | Status | Response length |
  |---|---|---|
  | 12345 | 302 | 392 |
  | letmain, qwerty | 302 | 392 |
  | **password** | 302 | **391** |

  The differing response length (391 vs 392) on the `password` guess is the signal that distinguishes it from the other failed guesses — the classic automatable "tell" for credential brute-forcing when failure pages aren't byte-identical.

## Takeaway
Response-length/timing differences are enough to automate credential discovery when an app doesn't equalize failure responses and doesn't rate-limit. See `headers/` and the main report for the corresponding fix recommendations (account lockout, identical failure responses, CAPTCHA).
