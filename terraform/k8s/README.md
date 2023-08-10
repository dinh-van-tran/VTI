# 1. Description
- Provision an EKS K8s cluster on AWS.
- Tutorial [link](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks).

# 2. Structure
```
├── README.md                   # Documentation.
├── main.tf                     # Entry point.
├── terraform.tf                # Necessary plugins for deployment.
├── variables.tf                # Default region.
└── outputs.tf                  # Output cluster information as environment after deployment.
```

# 3. Setup
- Be default, the EKS will be provisioned in Singapore region. Change the region by modify below code in [variables.tf](variables.tf).
```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}
```
- In the EKS cluster, there are 2 cluster nodes. Each node contains 1 worker server with configuration 1 CPU, 2 GB RAM. You can change the configuration by modify below code in [main.tf](main.tf). Please reference this [link](https://aws.amazon.com/ec2/instance-types/) for other EC2 instance types.
```hcl
# provision 2 node groups with different instance types
eks_managed_node_groups = {
    one = {
        name = "node-group-1"

        instance_types = ["t3.small"]

        min_size     = 1
        max_size     = 2
        desired_size = 1
    }

    two = {
        name = "node-group-2"

        instance_types = ["t3.small"]

        min_size     = 1
        max_size     = 2
        desired_size = 1
    }
}
```

# 3. How to run

## 3.1 Deploy
- Export AWS credentials then run terraform commands. See parent [README](../README.md) for more details.

> **Note**
> The deployment will take over **20** minutes.

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
