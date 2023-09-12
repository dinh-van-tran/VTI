# 1. Description
- Provision AWS cloud infrastructure as code by terraform.

# 2. How to run
1. Run `aws configure` for authorization.
2. Specify the AWS secret key in the terminal.
```shell
export AWS_ACCESS_KEY_ID=AAAAAAAAAAAAAAAAAAAA
export AWS_SECRET_ACCESS_KEY=BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
```
3. Deploy
```shell
terraform init
terraform apply
```
4. Teardown
```shell
terraform destroy
```

# 3. Verify EC2 booting script
- Loggin to the EC2, then run below command
```console
$ curl http://169.254.169.254/latest/user-data
```

# 4. MFA
## 4.1 Create a new role
- Create a new assume role `terraform` with permission `AdministratorAccess` follow this [link](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user.html).

## 4.2 Add the credentials
- Add a new credentials to `~/.aws/config`.
```
[profile vti]
role_arn = arn:aws:iam::111111111111:role/terraform
mfa_serial = arn:aws:iam::222222222222:mfa/Google
region = ap-southeast-1
```

## 4.3 Using Token
- There are 2 way of using token:
  1. Generate a temporary credential. Used in both local and remote environments.
  1. Use `aws-vault` then input the MFA code. Only used on local but simple.

### 4.3.1 Generate Token
- Access a temporary token by below command. Document [link](https://docs.aws.amazon.com/cli/latest/reference/sts/get-session-token.html)
```sh
export AWS_PROFILE=vti
export AWS_ACCESS_KEY_ID=AAAAAAAAAAAAAAAAAAAA
export AWS_SECRET_ACCESS_KEY=BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

aws sts get-session-token
```

- Copy the output values to AWS provider declaration.
```hcl
provider "aws" {
  region   = "ap-southeast-1"

  access_key = ""
  secret_key = ""
  token =""
}
```

### 4.3.2 aws-vault
- Install at [Repository](https://github.com/99designs/aws-vault)
- Run `aws-vault add vti`
- Run `aws-vault exec vti -- terraform apply`
> **Note**
> This don't work on terraform cloud.

# 5. Expose port
```hcl
resource "aws_security_group" "dinhvt_bastion_sg" {
  name_prefix = "dinhvt_bastion_sg"
  vpc_id      = aws_vpc.dinhvt_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dinhvt_bastion_sg"
  }
}

resource "aws_instance" "dinhvt_bastion" {
  # Ubuntu Server 22.04 LTS with SSD Volume Type
  ami           = "ami-0df7a207adb9748c7"
  # Specify the free tier
  instance_type = "t2.medium"

  tags = {
    Name = "dinhvt_bastion"
  }

  # Associate the instance with the security group
  vpc_security_group_ids = [aws_security_group.dinhvt_bastion_sg.id]
}
```

# 6. Variables
```hcl
variable "image_id" {
  type = string
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-1a"]
}

variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))

  default = [
    {
      internal = 8300
      external = 8300
      protocol = "tcp"
    }
  ]
}
```

# 7. Modules
## 7.1 How to pass parameters to modules
1. Declare desired parameters in the module file `variables.tf`.
```hcl
variable "environment" {
  description = "The environment to deploy to"
  type        = string
}
```

2. Pass paramters value
```hcl
module "vpc" {
  source = "./modules/network/vpc"

  environment = local.environment
}
```

## 7.2 How to use module parameters
1. In module file, output the desired value in file `outputs.tf`
```hcl
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.jenkins_public_subnet.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.jenkins_vpc.id
}
```

2. Access the value by using `module.vpc.vpc_id`


# 8. Errors
## 8.1 Role `admin` can not assume role
- Missing step specify the AWS secret key in the terminal.

## 8.2 Missing `role_arn`
1. Go to AWS console panel -> `IAM` -> `user`.
1. In the summary section, copy `ARN` information, example: `arn:aws:iam::356234027336:user/admin`.
1. Copy the arn information to `~/.aws/credentials`
```
[default]
source_profile=personal
role_arn = arn:aws:iam::356234027336:user/admin

[personal]
aws_access_key_id = AAAAAAAAAAAAAAAAAAAA
aws_secret_access_key = BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
```