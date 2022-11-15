output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "The Amazon Resource Name (ARN) of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = aws_s3_bucket.this.bucket_domain_name
}
