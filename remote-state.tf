terraform {
  backend "s3" {
    bucket = "project-test-remote-state-bucket"
    key    = "Terraform-main"
    region = "us-east-1"
  }
}
 

