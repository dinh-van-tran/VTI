# 1. Description
- Provision an EKS K8s cluster on AWS.
- Document [link](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks).

# 2. Structure
```
├── README.md                   # Documentation.
├── main.tf                     # Entry point.
├── terraform.tf                # Necessary plugins for deployment.
├── variables.tf                # Deployment variables: default region.
└── outputs.tf                  # Output cluster information as environment after deployment.
```

# 3. How to run

## 3.1 Deploy
- It takes **20** minutes for deployment.
```shell
terraform init
terraform apply
```

## 3.2 Connect to cluster
```shell
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```

## 3.3 Verify Cluster
```shell
kubectl cluster-info
kubectl get nodes
```

## 3.4 Tearndown
```shell
terraform destroy
```
