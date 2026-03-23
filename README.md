# ciaobella 🇮🇹

A simple Python Flask application deployed on Kubernetes via ArgoCD. Built as a hands-on demo for GitOps workflows, multi-arch container builds, and Kubernetes RBAC.

## Overview

`ciaobella` is a minimal Flask web app that returns a greeting, containerized and deployed to a kubeadm-based Kubernetes cluster. A GitHub Actions workflow builds and pushes the multi-arch Docker image on each push to `main`. It demonstrates a full GitOps pipeline using ArgoCD with manifests managed in this repo.

### 1. Build and push the image (multi-arch) manually

```bash
docker buildx create --use --name multiarch-remo-argo
docker buildx inspect --bootstrap

docker buildx build --platform linux/amd64,linux/arm64 \
  -t itlinux/remo-argocd-app:latest \
  --push .
```

> **Note:** Multi-arch build is required to support both Apple Silicon (arm64) dev machines and amd64 Kubernetes nodes.

### 2. Deploy via ArgoCD

I used the UI to import it you can use the cli if you want.

## Troubleshooting

**ImagePullBackOff** — If pods fail to pull the image, ensure the image was built for the correct platform (`linux/amd64` for standard cluster nodes):

**Expired Certificates** — kubeadm issues 1-year certs. Renew with:

```bash
sudo kubeadm certs renew all
sudo systemctl restart kubelet
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
```

### 2. Patching ref cool site

https://bargenqua.st/posts/kubectl-patching/

### 3. Best YAML IDE for K8s

https://monokle.io
