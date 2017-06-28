# S3 Bucket:

resource "aws_s3_bucket" "dtr-storage-bucket" {
    bucket = "${var.name_prefix}-${var.dtr_storage_name}"
    acl = "private"

    tags {
        Name = "${var.name_prefix}-${var.dtr_storage_name}"
        Environment = "${var.name_prefix}"
    }
}

