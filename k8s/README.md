# Note
# Forward Port to Localhost
- Forwarding service `svc/argocd-server` in namespace `argocd` port 8080 to localhost port 443.
```shell
kubectl port-forward svc/argocd-server --namespace argocd 8080:443
```

## Get Exposed Address of a Service
- Replace service name and namespace value in below command.
```shell
kubectl get svc service-name --namespace default --output jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
