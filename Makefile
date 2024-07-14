.PHONY: ca secret client

NAME:=crazyzone.be
ORGANIZATION:=CrazyTown
COUNTRY:=BE
STATE:=Oost-Vlaanderen
CITY:=Eine
UNIT:=CrazyTown
PASSWORD:=password
URL:=https://www.crazyzone.be

ca: 
	rm -rf CA && mkdir -p CA
	rm -rf "${NAME}"
	openssl genrsa -des3 -passout pass:${PASSWORD} -out "./CA/ca.key" 4096
	openssl req -x509 -new -nodes -key "./CA/ca.key" -sha512 -days 3650 -passin pass:${PASSWORD} -out "./CA/ca.crt" \
		-subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=${UNIT}/CN=${NAME}"

secret:
	kubectl create secret generic 'client-auth-ca-cert' -n 'default' --from-file='ca.crt=./CA/ca.crt' -o yaml --dry-run='client'

client:
	rm -rf "${NAME}" && mkdir -p "${NAME}"

	openssl genrsa -des3 -passout pass:${PASSWORD} -out "${NAME}/${NAME}.key" 4096
	openssl req -new -key "${NAME}/${NAME}.key" -out "${NAME}/${NAME}.csr" -passin pass:${PASSWORD} -subj "/CN=${NAME}/O=${ORGANIZATION}/C=${COUNTRY}"

	# Use ca.crt and ca.key from step 1
	openssl x509 -sha384 -req -passin pass:${PASSWORD} -CA "./CA/ca.crt" -CAkey "./CA/ca.key" -CAcreateserial -days 3650 -in "${NAME}/${NAME}.csr" -out "${NAME}/${NAME}.crt"
	openssl pkcs12 -export -passin pass:${PASSWORD} -passout pass:${PASSWORD} -out "${NAME}/${NAME}.pfx" -inkey "${NAME}/${NAME}.key" -in "${NAME}/${NAME}.crt"

	#remove password
	openssl rsa -passin pass:${PASSWORD} -in ${NAME}/${NAME}.key -out ${NAME}/${NAME}.nopw.key
	
test:
	curl -vk "${URL}" --cert "${NAME}/${NAME}.crt" --key "${NAME}/${NAME}.nopw.key"