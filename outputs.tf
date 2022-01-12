output "leninha-bucket-versioning" {
 value = aws_s3_bucket.leninha_bucket.versioning[0].enabled
}

output "branquinha-bucket-versioning" {
  value = aws_s3_bucket.branquinha_bucket.versioning[0].enabled
}

output "leninha-bucket-complete-details" {
  value = aws_s3_bucket.leninha_bucket
}

output "my-first-iam-user-complete-details" {
  value = aws_iam_user.my_first_iam_user
}