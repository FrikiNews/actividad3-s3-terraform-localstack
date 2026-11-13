# Bucket S3 seguro con Terraform + LocalStack

Práctica A de la Actividad 3 de Ciberseguridad. Crea un bucket S3 **simulado** con
Terraform sobre LocalStack, con cifrado AES-256 y bloqueo de acceso público, y verifica
la configuración con AWS CLI. **No usa AWS real ni requiere cuenta de AWS.**

## Requisitos

- Docker Engine / Desktop y Docker Compose v2
- Terraform >= 1.5
- AWS CLI v2
- Cuenta gratuita de LocalStack (plan **Hobby**) y su token de autenticación

Comprobar versiones:

```bash
docker --version
docker compose version
terraform version
aws --version
```

## Configuración

El bucket se llama `actividad3-seguro-local`, región `us-east-1`, endpoint
`http://localhost:4566`. Terraform crea **3 recursos**: el bucket, su cifrado AES256 y el
bloqueo de acceso público (4 controles).

## Pasos

1. Pon tu token de LocalStack como variable de entorno (no lo escribas en los archivos):

   ```bash
   cp .env.example .env        # edita .env y pega tu token
   export $(grep -v '^#' .env | xargs)   # Linux/macOS
   ```

2. Levanta LocalStack y comprueba que esté saludable:

   ```bash
   docker compose up -d
   curl http://localhost:4566/_localstack/health
   ```

3. Despliega la infraestructura:

   ```bash
   terraform init
   terraform validate
   terraform plan      # debe anunciar 3 recursos por crear
   terraform apply
   ```

4. Verifica con AWS CLI (siempre con el endpoint local):

   ```bash
   aws --endpoint-url http://localhost:4566 s3api list-buckets
   aws --endpoint-url http://localhost:4566 s3api get-bucket-encryption --bucket actividad3-seguro-local
   aws --endpoint-url http://localhost:4566 s3api get-public-access-block --bucket actividad3-seguro-local
   ```

5. Sube un archivo de prueba e intenta el acceso anónimo:

   ```bash
   echo "hola" > prueba.txt
   aws --endpoint-url http://localhost:4566 s3 cp prueba.txt s3://actividad3-seguro-local/
   aws --endpoint-url http://localhost:4566 s3 ls s3://actividad3-seguro-local/
   ```

6. Al terminar:

   ```bash
   terraform destroy
   docker compose down
   ```

## Seguridad

- El token de LocalStack y el archivo `.env` **nunca** se suben a GitHub (`.gitignore`).
- No se usa información confidencial real.
- Ningún comando apunta a AWS de producción.
- Si LocalStack acepta una solicitud anónima, trátalo como limitación del simulador, no
  como que el bucket esté realmente expuesto.
