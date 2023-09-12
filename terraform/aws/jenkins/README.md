# 1. Description
- Provision a Jenkins with Docker server on AWS EC2.
- Tutorial article [link](https://betterprogramming.pub/provisioning-a-jenkins-server-on-aws-using-terraform-4cd1351b5d5f).
- Tutorial git repo [link](https://github.com/dispact/terraform-jenkins).

# 2. Setup
- The Jenkins will be provisioned in the Singapore region. You can change the deploy region in [here](variables.tf).
```hcl
variable "aws_region" {
  # Singapore
  default = "ap-southeast-1"
}
```

- By default the Jenkins server will be provisioned with configuration 2 CPUs, 8GB RAM. You can change the ec2 instance type in [here](modules/compute/main.tf)
```hcl
# 2 CPUs, 8GB RAM
instance_type          = "t2.large"
```

- You will need an SSH for logging to Jenkins server to obtain the admin password. For convenience, there is a script names `generate_keypair.sh` that generates an ssh key name `jenkins_keypair`.
However, you can use your own ssh key by modify below code in [here](modules/compute/main.tf).
```hcl
# load ssh key from file
resource "aws_key_pair" "jenkins_keypair" {
  key_name   = "jenkins_keypair"
  public_key = file("${path.module}/jenkins_keypair.pub")
}
```

# 3. How to run
1. Run `generate_keypair.sh` first to obtain a new ssh key.
2. Export AWS secret key variables then run terraform commands. See parent [README](../README.md) for details.
3. Get Jenkins admin password by login to Jenkin server
```console
ssh -i jenkins_keypair.pem ubuntu@$(terraform output -raw jenkins_public_ip)
```
4. Get Jenkins admin password
```console
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
5. Run below command to get the Jenkins public IP
```console
terraform output -raw jenkins_public_ip
```
6. Go to Jenkins server `http://jenkins_public_ip:8080`.