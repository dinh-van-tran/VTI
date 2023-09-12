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
"AWS region"
  type        = string
  default     = "ap-southeast-1"
}
```

- In the EKS cluster, there are 2 cluster nodes. Each node contains 1 worker server with configuration 1 CPU, 2 GB RAM. You can change the configuration by modify below code in [main.tf](main.tf). Please reference this [link](https://aws.amazon.com/ec2/instance-types/) for other EC2 instance types.

<details>

<summary>Click to expand</summary>

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

</details>

- The terraform provisions Amazon Elastic Block Store (EBS) CSI driver for managing the lifecycle of Amazon EBS volumes. If you don't have any intend storing persistent data, you can remove it by comment below code in file [main.tf](main.tf). This will save up a half time for provisioning.

<details>

<summary>Click to expand</summary>

```hcl
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# Creating new role for the EBS CSI driver.
module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}
```

</details>

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
