# For storing docker container images, we will use AWS Elastic Container Registry (ECR).
resource "aws_ecr_repository" "example" {
  name = "dinhvt-repo"

  image_tag_mutability = "MUTABLE"

  tags = {
    Name        = "dinhvt-repo"
    Environment = var.environment
  }
}
