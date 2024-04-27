output "model_bucket_id" {
    value = aws_s3_bucket.model_bucket.id
    description = "The S3 model bucket id"
}