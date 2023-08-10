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

# 3. Errors
## 3.1 Role `admin` can not assume role
- Missing step specify the AWS secret key in the terminal.

## 3.2 Missing `role_arn`
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