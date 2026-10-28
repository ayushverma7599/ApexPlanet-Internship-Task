# Web Security Headers — Before / After

Target: `http://192.168.187.4/dvwa/`

DVWA runs on a private, host-only lab network with no internet route, so `securityheaders.com` can't reach it — `curl -I` is used as the local equivalent, giving the same raw evidence.

## Before (`01_before_curl_headers_missing.png`)
```
curl -I http://192.168.187.4/dvwa/
```
No `X-Frame-Options`, `X-Content-Type-Options`, or `Content-Security-Policy` headers present.

## Fix applied
Added to `/etc/apache2/apache2.conf` (requires `mod_headers` enabled: `sudo a2enmod headers`):
```apacheconf
Header set X-Frame-Options "DENY"
Header set X-Content-Type-Options "nosniff"
Header set Content-Security-Policy "default-src 'self'"
```
```
sudo /etc/init.d/apache2 restart
```

## After (`02_after_curl_headers_present.png`)
```
curl -I http://192.168.187.4/dvwa/
```
Now returns:
```
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Content-Security-Policy: default-src 'self'
```

## Gotcha hit during setup
First attempt used `Contentyt-Security-Policy` (typo) — browsers/clients silently ignore unrecognized header names, so it looked present in the config but never showed up in the response until the typo was fixed and Apache restarted.
