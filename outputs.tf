output "bucket_nombre" {
  description = "Nombre del bucket creado"
  value       = aws_s3_bucket.seguro.bucket
}

output "cifrado_algoritmo" {
  description = "Algoritmo de cifrado aplicado por defecto"
  value = one(
    aws_s3_bucket_server_side_encryption_configuration.cifrado.rule
  ).apply_server_side_encryption_by_default[0].sse_algorithm
}

output "bloqueo_publico" {
  description = "Estado de los 4 controles de bloqueo de acceso publico"
  value = {
    block_public_acls       = aws_s3_bucket_public_access_block.bloqueo.block_public_acls
    block_public_policy      = aws_s3_bucket_public_access_block.bloqueo.block_public_policy
    ignore_public_acls      = aws_s3_bucket_public_access_block.bloqueo.ignore_public_acls
    restrict_public_buckets = aws_s3_bucket_public_access_block.bloqueo.restrict_public_buckets
  }
}
