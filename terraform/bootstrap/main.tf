
resource "aws_s3_bucket" "tf_state" {
    bucket = "eks-keto-tf-state-bucket"

    lifecycle {
      prevent_destroy = true #guardrail to prevent accidental deletion 
    }
}

resource "aws_s3_bucket_versioning" "tf_state" {
    bucket = aws_s3_bucket.tf_state.id
    versioning_configuration {
      status = "Enabled" #rollback previous state
    }
}

resource "aws_kms_key" "tf_state" {
    description = "This key is used to encrypt bucket objects"
    deletion_window_in_days = 10
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
    bucket = aws_s3_bucket.tf_state.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "tf_state" {
    bucket = aws_s3_bucket.tf_state.id
    rule {
      object_ownership = "BucketOwnerEnforced"
    }
}

resource "aws_ecr_repository" "keto_app" {
    name = "keto-app"
    image_tag_mutability = "MUTABLE"
    encryption_configuration {
      encryption_type = "KMS"
    }
    image_scanning_configuration {
      scan_on_push = true
    }
}

resource "aws_ecr_lifecycle_policy" "lifecycle" {
    repository = aws_ecr_repository.keto_app.name
    policy = jsonencode({
        rules = [{
            rulePriority = 1,
            description = "Expire images older than 30 days"
            selection = {
                tagStatus = "any"
                countType = "sinceImagePushed"
                countUnit = "days"
                countNumber = 30
            }
            action = {
                type = "expire"
            }  
        }]      # cost control
    })
}

resource "aws_route53_zone" "eks_zone" {
    name = "eks.shamimchaudhury.uk"

    tags = {
      Name = "eks-subdomain"
    }
}
