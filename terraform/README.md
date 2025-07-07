# 🚀 Site Estático com S3 e Terraform

Este projeto implementa um site estático hospedado no Amazon S3 utilizando Terraform para Infrastructure as Code (IaC).

## 📁 Estrutura do Projeto

```
terraform-s3-static-website/
├── main.tf                 # Configuração principal dos recursos AWS
├── variables.tf            # Definição das variáveis
├── outputs.tf             # Saídas do Terraform
├── terraform.tfvars       # Valores das variáveis
├── website/
│   ├── index.html         # Página principal
│   └── error.html         # Página de erro 404
└── README.md              # Este arquivo
```

## 🛠️ Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- Conta AWS com permissões para S3

## ⚙️ Configuração

### 1. Configurar AWS CLI

```bash
aws configure
```

### 2. Clonar e configurar o projeto

```bash
# Criar diretório do projeto
mkdir terraform-s3-static-website
cd terraform-s3-static-website

# Criar estrutura de pastas
mkdir website
```

### 3. Personalizar variáveis

Edite o arquivo `terraform.tfvars` e altere os valores conforme necessário:

```hcl
bucket_name  = "seu-bucket-unico-123456"  # DEVE SER ÚNICO GLOBALMENTE
aws_region   = "us-east-1"
environment  = "dev"
project_name = "meu-site-estatico"
```

## 🚀 Deploy

### 1. Inicializar Terraform

```bash
terraform init
```

### 2. Planejar mudanças

```bash
terraform plan
```

### 3. Aplicar configuração

```bash
terraform apply
```

### 4. Confirmar aplicação

Digite `yes` quando solicitado.

## 🌐 Acessar o Site

Após o deploy, o Terraform exibirá a URL do site:

```
website_url = "http://seu-bucket-unico-123456.s3-website-us-east-1.amazonaws.com"
```

Você pode acessar o site através desta URL.

## 📋 Outputs Disponíveis

- `bucket_name`: Nome do bucket S3
- `bucket_arn`: ARN do bucket S3
- `website_endpoint`: Endpoint do site estático
- `website_domain`: Domínio do site estático
- `website_url`: URL completa do site

## 🔧 Recursos Criados

- **S3 Bucket**: Armazenamento dos arquivos estáticos
- **Bucket Policy**: Permissões de leitura pública
- **Website Configuration**: Configuração para hospedagem estática
- **S3 Objects**: Upload automático dos arquivos HTML

## 🛡️ Segurança

- Bucket configurado apenas para leitura pública
- Política de bucket restritiva
- Bloco de acesso público configurado adequadamente

## 🧹 Limpeza

Para remover todos os recursos criados:

```bash
terraform destroy
```

## 📝 Customização

### Adicionar novos arquivos

Para adicionar novos arquivos estáticos, adicione recursos `aws_s3_object` no `main.tf`:

```hcl
resource "aws_s3_object" "css_file" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "styles.css"
  source       = "${path.module}/website/styles.css"
  content_type = "text/css"
  etag         = filemd5("${path.module}/website/styles.css")
}
```

### Modificar região

Altere a variável `aws_region` no arquivo `terraform.tfvars`.

### Adicionar domínio customizado

Para usar um domínio personalizado, você precisará:

1. Registrar um domínio no Route 53
2. Configurar um certificado SSL no ACM
3. Adicionar CloudFront para HTTPS

## 🔄 CI/CD

Esta estrutura está pronta para integração com pipelines de CI/CD. Exemplos de workflows:

- GitHub Actions
- GitLab CI
- AWS CodePipeline
- Jenkins

## 📚 Referências

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## 🤝 Contribuição

Sinta-se à vontade para contribuir com melhorias e sugestões!

## 📄 Licença

Este projeto é licenciado sob a MIT License.