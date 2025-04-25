terraform {
  backend "s3" {
    bucket         = "kev-backup-tfstate-04242025"
    key            = "smart-vault/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
