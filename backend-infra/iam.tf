data "aws_iam_policy_document" "backend_infra" {
  statement {
    actions   = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.backend_infra.arn,
      "${aws_s3_bucket.backend_infra.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = var.users_ready_only
    }
  }
  statement {
    actions   = [
      "s3:*Object"
    ]
    resources = [
      aws_s3_bucket.backend_infra.arn,
      "${aws_s3_bucket.backend_infra.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = var.users_write_permissions
    }
  }
  statement {
    sid    = "AllExceptUser"
    effect = "Deny"
    actions   = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.backend_infra.arn,
      "${aws_s3_bucket.backend_infra.arn}/*"
    ]
    not_principals {
      identifiers = concat(var.users_write_permissions, var.users_ready_only)
      type        = "AWS"
    }
  }
}