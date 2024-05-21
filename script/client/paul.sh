apt-get update
apt-get install lynx apache2-utils jq -y

# Soal 15 & 16
echo '
{
    "username": "kelompokit02",
    "password": "passwordit02"
}
' > /auth.json
