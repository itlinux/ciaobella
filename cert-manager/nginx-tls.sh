alias k=kubectl

k apply -f - <<EOF
---
# Issuer for ciao namespace
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: selfsigned-issuer
  namespace: ciao
spec:
  selfSigned: {}
---
# Certificate
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx-cert
  namespace: ciao
spec:
  dnsNames:
  - example.com
  secretName: nginx-tls
  issuerRef:
    name: selfsigned-issuer
    kind: Issuer
---
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: ciao
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
        - containerPort: 443
        volumeMounts:
        - name: tls
          mountPath: /etc/nginx/tls
          readOnly: true
        - name: nginx-config
          mountPath: /etc/nginx/conf.d
          readOnly: true
      volumes:
      - name: tls
        secret:
          secretName: nginx-tls
      - name: nginx-config
        configMap:
          name: nginx-tls-config
---
# ConfigMap for nginx TLS config
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-tls-config
  namespace: ciao
data:
  default.conf: |
    server {
      listen 80;
      return 301 https://$host$request_uri;
    }
    server {
      listen 443 ssl;
      ssl_certificate     /etc/nginx/tls/tls.crt;
      ssl_certificate_key /etc/nginx/tls/tls.key;
      location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
      }
    }
---
# LoadBalancer Service
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: ciao
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - name: http
    port: 80
    targetPort: 80
  - name: https
    port: 443
    targetPort: 443
EOF

# Verify cert was issued
k get certificate nginx-cert -n ciao
k get secret nginx-tls -n ciao

# Check deployment and service
k get deploy,svc -n ciao

