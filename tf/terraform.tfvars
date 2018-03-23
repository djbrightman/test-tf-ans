aws_access_key = ""

aws_secret_key = ""

aws_key_path = "~/.ssh/djb-eu-west-1.pem"

aws_key_name = "djb-eu-west-1"

terraform {
  backend "s3" {
    bucket = "djb-tfstate"
    key    = "test-tf-ans"
    region = "eu-east-1"
  }
}
