# Description
- Provision a Jenkins server on AWS.
- Original [link](https://betterprogramming.pub/provisioning-a-jenkins-server-on-aws-using-terraform-4cd1351b5d5f)
- Git repo [link](https://github.com/dispact/terraform-jenkins)

# How to run
1. Run `generate_keypair.sh` first to obtain a new ssh key. This key will be used for logging into the Jenkins server.
1. Export AWS secret key variables.
1. Run terraform commands.