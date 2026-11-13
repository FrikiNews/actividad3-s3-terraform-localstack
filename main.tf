# ============================================================
#  3 recursos: bucket + cifrado + bloqueo de acceso publico
# ============================================================

# 1) El bucket
resource "aws_s3_bucket" "seguro" {
  bucket = "actividad3-seguro-local"

  tags = {
    Proyecto = "Actividad3"
    Entorno  = "laboratorio-local"
  }
}

# 2) Cifrado en reposo SSE-S3 (AES-256)
resource "aws_s3_bucket_server_side_encryption_configuration" "cifrado" {
  bucket = aws_s3_bucket.seguro.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 3) Bloqueo de acceso publico: los 4 controles en true
resource "aws_s3_bucket_public_access_block" "bloqueo" {
  bucket = aws_s3_bucket.seguro.id

  block_public_acls       = true # ignora ACL publicas nuevas
  block_public_policy      = true # rechaza politicas de bucket publicas
  ignore_public_acls      = true # ignora las ACL publicas existentes
  restrict_public_buckets = true # limita el acceso solo a principales autorizados
}
