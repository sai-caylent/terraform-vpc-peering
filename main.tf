resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "aws_ssm_parameter" "secret" {
  name        = var.secret_name
  description = "The parameter description"
  type        = "SecureString"
  value       = random_password.password.result

  tags = {
    environment = "production"
  }
}
