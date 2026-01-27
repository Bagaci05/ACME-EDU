ssh \
-o KexAlgorithms=diffie-hellman-group1-sha1 \
-o HostKeyAlgorithms=ssh-rsa \
-o PubkeyAcceptedAlgorithms=ssh-rsa \
-o Ciphers=3des-cbc \
-o MACs=hmac-sha1 \
student1@192.168.1.1

ssh \
-o KexAlgorithms=diffie-hellman-group1-sha1 \
-o HostKeyAlgorithms=ssh-rsa \
-o PubkeyAcceptedAlgorithms=ssh-rsa \
-o Ciphers=3des-cbc \
-o MACs=hmac-sha1 \
student1@192.168.2.1