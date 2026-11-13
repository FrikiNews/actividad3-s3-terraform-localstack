terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider apuntado a LocalStack (NO a AWS real).
provider "aws" {
  region = "us-east-1"

  # Credenciales ficticias: LocalStack no las valida.
  access_key = "test"
  secret_key = "test"

  # Evita que Terraform intente contactar la nube real de AWS.
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  # Necesario para S3 contra LocalStack.
  s3_use_path_style = true

  # Todo el trafico S3 va al endpoint local.
  endpoints {
    s3 = "http://localhost:4566"
  }
}
