resource "aws_kms_key" "encrypt_state" {
  count = var.activate_kms ? 1 : 0

  description             = "Key to protect S3 objects"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  is_enabled              = true

  tags = merge({ Name = "${local.deployment_project}-kms-custom-key" }, var.tags)
}

resource "aws_kms_alias" "kms_s3_key_alias" {
  count = var.activate_kms ? 1 : 0

  name          = "alias/${var.project_name}/${var.environment}/s3-state-key"
  target_key_id = aws_kms_key.encrypt_state[0].key_id
}