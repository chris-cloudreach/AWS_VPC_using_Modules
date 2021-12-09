terraform {
  backend "s3" {
    #bucket name
    bucket = "talent-academy-194694014750-tfstates"
    #where to store the tfstates file
    key    = "sprint2/basic-vpc/terraform.tfstates"
    
    dynamodb_table = "terraform-lock"
  }
}