# Installing cert-manager
k apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

sleep 120

k apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager-test
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: test-selfsigned
  namespace: cert-manager-test
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: selfsigned-cert
  namespace: cert-manager-test
spec:
  dnsNames:
  - example.com
  secretName: selfsigned-cert-tls
  issuerRef:
    name: test-selfsigned
    kind: Issuer
EOF

# Verify the certificate was issued
k get certificate -n cert-manager-test
k describe certificate selfsigned-cert -n cert-manager-test

# Cleanup
#k delete namespace cert-manager-test
