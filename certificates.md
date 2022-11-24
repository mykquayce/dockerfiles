powershell
```powershell
docker pull alpine:latest
docker run --interactive=true --rm --tty=true --volume "${env:userprofile}\.aspnet\https:/usr/certs:rw" alpine:latest sh
```
shell
```bash
apk add openssl
cd /usr/certs/
openssl genrsa -aes256 -out ./ca.key 4096
openssl req -new -x509 -days 365 -key ./ca.key -subj "/C=UK/ST=Manchester/L=Manchester/O=sarif/OU=systems/CN=sarif inc" -out ./ca.crt
openssl req -newkey rsa:2048 -nodes -keyout ./malik.key -subj "/C=UK/ST=Manchester/L=Manchester/O=sarif/OU=development/CN=malik" -out ./malik.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:localhost,DNS:malik,DNS:malik.sarif.local") -days 365 -in ./malik.csr -CA ./ca.crt -CAkey ./ca.key -CAcreateserial -out ./malik.crt
```
certificates appear in ```~\.aspnet\https```
