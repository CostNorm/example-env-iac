# Generate random string for unique bucket name
resource "random_string" "bucket_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.bucket_name}-${random_string.bucket_suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# allow multipart upload bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowMultipartUpload"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
          "s3:ListBucketMultipartUploads"
        ]
        Resource = [
          "${aws_s3_bucket.bucket.arn}/*",
          aws_s3_bucket.bucket.arn
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.bucket_public_access_block]
}

# Create 6GB file and upload to S3
resource "null_resource" "create_and_upload_file" {
  provisioner "local-exec" {
    command = <<-EOT
      dd if=/dev/zero of=./large_file.dat bs=1M count=6144
      aws s3 cp ./large_file.dat s3://${aws_s3_bucket.bucket.bucket}/large_file.dat
      rm ./large_file.dat
    EOT
  }

  depends_on = [aws_s3_bucket.bucket]
}
