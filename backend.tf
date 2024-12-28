terraform {
  backend "s3" {
    bucket = "my-bucket"
    key = "terraform/docker"
    region = "us-east-1"
  }
}
