mkdir -p server/newcerts
# Create us a key. Don't bother putting a password on it since you will need it to start apache. If you have a better work around I'd love to hear it.
openssl genrsa -out server/server.key
# Take our key and create a Certificate Signing Request for it.
openssl req -new -key server/server.key -out server/server.csr
# Sign this bastard key with our bastard demoCA key.
openssl ca -days 36500 -in server/server.csr -cert demoCA/ca.cer -keyfile demoCA/ca.key -out server/server.cer
