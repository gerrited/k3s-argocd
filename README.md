# k3s-cluster

## Tools used
| Name | Description |
| :---  | :---  |
| [k3s](https://www.google.com)  | K8s Distribution of my Raspberry Cluster ([more info](https://gerrit.codes/posts/2022/01/raspberry-pi-cluster-mit-k3s/)) |
| [ArgoCD](https://argoproj.github.io/) | GitOps Tool to manage Kubernetes Apps |
| [Cloudflare](https://www.cloudflare.com/) | DNS and Tunnel for the local K8s Cluster ([more info](https://gerrit.codes/posts/2022/01/k8s-tunnel-cloudflare/)) |
| [Terraform](https://argoproj.github.io/) | IaC Tool used to manage Cloudflare DNS and Tunnels |

## Infrastructure as Code
The cloudflare configuration of DNS records and tunnels are made with terraform. To make the process even easier, a github action uses the terraform cloud to plan and apply changes. All necessary variables (e.g. tunnel id) are stored as secrets in the terraform cloud project.

## How to create the cluster

### Install argocd

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Add this repo as argocd app
Option A
```bash
kubectl apply -f init.yaml
```

Option B
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
kubectl port-forward svc/argocd-server -n argocd 8080:80
argocd login localhost:8080
argocd app create k3s-argocd --repo https://github.com/gerrited/k3s-cluster.git --path . --dest-namespace default --dest-server https://kubernetes.default.svc --directory-recurse
```

### Use sealed secrets
Add new argocd app

```bash
kubectl apply -f sealed-secrets.yaml
```

Don't forget to restore the old sealed-secrets-key
