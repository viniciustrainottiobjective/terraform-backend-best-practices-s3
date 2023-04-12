resource "aws_s3_bucket" "logging" {
  bucket = "${local.deployment_project}-bucket-logging"
  tags = merge({
    Name = "${local.deployment_project}-bucket-logging"
  }, var.tags)
}

resource "aws_s3_bucket_acl" "logging" {
  bucket = aws_s3_bucket.logging.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  bucket = aws_s3_bucket.logging.bucket

  rule {
    id = "basic_config"
    status = "Enabled"
    filter {
      prefix = "/"
    }
    expiration {
      days = 360
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}