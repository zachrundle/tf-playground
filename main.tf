resource "aws_s3_bucket" "my_bucket" {
  bucket = test-bucket-42353242213123  # Name of the S3 bucket
  tags = {
    Name        = "MyS3Bucket"
    Environment = "Dev"
  }
}