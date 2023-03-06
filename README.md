# k3s-argocd

## Install argocd

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Add this repo as argocd app
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
kubectl port-forward svc/argocd-server -n argocd 8080:80
argocd login localhost:8080
argocd app create k3s-argocd --repo https://github.com/gerrited/k3s-cluster.git --path . --dest-namespace default --dest-server https://kubernetes.default.svc --directory-recurse
```

## Use sealed secrets

REPO URL: https://bitnami-labs.github.io/sealed-secrets
CHART: sealed-secrets
VERSION: 2.2.0 (This is a pre-release at the time of writing this guide)
NAMESPACE: kube-system

