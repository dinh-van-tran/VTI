# Description
- Provision a Jenkins server on AWS.
- Original [link](https://betterprogramming.pub/provisioning-a-jenkins-server-on-aws-using-terraform-4cd1351b5d5f)
- Git repo [link](https://github.com/dispact/terraform-jenkins)

# How to run
1. Run `generate_keypair.sh` first to obtain a new ssh key. This key will be used for logging into the Jenkins server.
2. Export AWS secret key variables.
3. Run terraform commands.
4. Get Jenkins admin password by login to Jenkin server
```shell
ssh -i jenkins_keypair.pem ubuntu@$(terraform output -raw jenkins_public_ip)
```
5. Get Jenkins admin password
```shell
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```