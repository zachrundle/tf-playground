resource "aws_s3_bucket" "my_bucket" {
  bucket = "test-bucket-42353242213123"
  tags = {
    Name        = "MyS3Bucket"
    Environment =                       "Dev"
  }
}