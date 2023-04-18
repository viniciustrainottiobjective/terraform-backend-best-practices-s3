resource "aws_s3_bucket" "backend_infra" {
  bucket = "${local.deployment_project}-bucket-s3-state"
  tags = merge({
    Name = "${local.deployment_project}-bucket-s3-state"
  }, var.tags)
}

resource "aws_s3_bucket_acl" "backend_infra" {
  bucket = aws_s3_bucket.backend_infra.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "backend_infra" {
  bucket = aws_s3_bucket.backend_infra.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "backend_infra" {
  bucket = aws_s3_bucket.backend_infra.id

  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "${local.deployment_project}/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend_infra" {
  bucket = aws_s3_bucket.backend_infra.bucket
  rule {
    dynamic "apply_server_side_encryption_by_default" {
      for_each = var.activate_kms ? [1] : []
      content {
        kms_master_key_id = aws_kms_key.encrypt_state[0].arn
        sse_algorithm     = "aws:kms"
      }
    }
    dynamic "apply_server_side_encryption_by_default" {
      for_each = var.activate_kms ? [] : [1]
      content {
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backend_infra" {
  depends_on = [aws_s3_bucket_versioning.backend_infra]
  bucket = aws_s3_bucket.backend_infra.bucket

  rule {
    id = "basic_config"
    status = "Enabled"
    filter {
      prefix = var.prefix_filter_s3
    }
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }
    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

resource "aws_s3_bucket_public_access_block" "backend_infra" {
  bucket = aws_s3_bucket.backend_infra.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "backend_infra" {
  bucket = aws_s3_bucket.backend_infra.id
  policy = data.aws_iam_policy_document.backend_infra.json
}