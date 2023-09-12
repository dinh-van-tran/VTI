resource "aws_ecr_repository" "example" {
  name = "dinhvt-ecr-repository"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "dinhvt-repository"
  }
}
