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
argocd app create k3s-argocd --repo https://github.com/gerrited/k3s-argocd.git --path . --dest-namespace default --dest-server https://kubernetes.default.svc --directory-recurse
```

## Use sealed secrets