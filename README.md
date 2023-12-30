# k3s-argocd

## Install argocd

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Add this repo as argocd app
### Option A
```
kubectl apply -f init.yaml
```

### Option B
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
kubectl port-forward svc/argocd-server -n argocd 8080:80
argocd login localhost:8080
argocd app create k3s-argocd --repo https://github.com/gerrited/k3s-cluster.git --path . --dest-namespace default --dest-server https://kubernetes.default.svc --directory-recurse
```

## Use sealed secrets
Add new argocd app

```
kubectl apply -f sealed-secrets.yaml
```

Don't forget to restore the old sealed-secrets-key

## Terraform
The cloudflare configuration of DNS records and tunnels are made with terraform. To make the process even easier, the github action uses the terraform cloud, to plan and apply changes. All necessary variables (e.g. tunnel id) are stored as secrets in the terraform cloud project.