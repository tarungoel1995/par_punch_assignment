output "s3_bucket_id" {
  description = "The ID of the S3 bucket."
  value       = aws_s3_bucket.s3_bucket.id
}

output "s3_bucket_name" {
    value = aws_s3_bucket.s3_bucket.bucket
}