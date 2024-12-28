terraform {
  backend "s3" {
    bucket = "state_bucket"
    key = "state_key"
    region = "us-east-1"
  }
}

