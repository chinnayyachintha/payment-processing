resource "aws_s3_bucket" "backup_bucket" {
  bucket = "${var.backup_bucket_name}"
  acl    = "private"
}

resource "aws_s3_bucket_acl" "backup_bucket_acl" {
  bucket = aws_s3_bucket.backup_bucket.id
  acl    = "private"
}


