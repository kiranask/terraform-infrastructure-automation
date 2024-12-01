terraform {
  backend "s3" {
    bucket = "terra-bucket-s3"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}
