mkdir -p client
# Let's create us a key for this user... yeah not sure why people want to use DES3 but at least let's make us a nice big key.
openssl genrsa -des3 -out client/$1.key 1024
# Create a Certificate Signing Request for said key.
openssl req -new -key client/$1.key -out client/$1.csr
# Sign the key with our demoCA's key and cert and create the user's certificate out of it.
openssl ca -days 36500 -in client/$1.csr -cert demoCA/ca.cer -keyfile demoCA/ca.key -out client/$1.cer

# This is the tricky bit... convert the certificate into a form that most browsers will understand PKCS12 to be specific.
# The export password is the password used for the browser to extract the bits it needs and insert the key into the user's keychain.
# Take the same precaution with the export password that would take with any other password based authentication scheme.
#openssl pkcs12 -export -clcerts -in client/$1.cer -inkey client/$1.key -out client/$1.p12
openssl pkcs12 -export -out client/$1.pfx -inkey client/$1.key -in client/$1.cer -certfile demoCA/ca.cer
