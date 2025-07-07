# Criar deploy.sh
cat > scripts/deploy.sh << 'EOF'
#!/bin/bash

# Script de deploy manual
set -e

echo "🚀 Iniciando deploy do site estático..."

# Validar se terraform está instalado
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform não está instalado!"
    exit 1
fi

# Validar se AWS CLI está configurado
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS CLI não está configurado!"
    exit 1
fi

# Entrar no diretório terraform
cd terraform

# Inicializar Terraform
echo "📋 Inicializando Terraform..."
terraform init

# Validar configuração
echo "✅ Validando configuração..."
terraform validate

# Fazer plan
echo "📊 Criando plano de execução..."
terraform plan

# Confirmar aplicação
read -p "Deseja aplicar as mudanças? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "⚡ Aplicando mudanças..."
    terraform apply -auto-approve
    
    echo "🌐 Obtendo URL do website..."
    WEBSITE_URL=$(terraform output -raw website_url)
    echo "✨ Site disponível em: $WEBSITE_URL"
else
    echo "❌ Deploy cancelado pelo usuário"
fi

echo "✅ Script finalizado!"
EOF

# Criar setup.sh
cat > scripts/setup.sh << 'EOF'
#!/bin/bash

# Script de configuração inicial
set -e

echo "🛠️ Configurando ambiente de desenvolvimento..."

# Verificar dependências
echo "📋 Verificando dependências..."

# Git
if ! command -v git &> /dev/null; then
    echo "❌ Git não está instalado!"
    exit 1
else
    echo "✅ Git: $(git --version)"
fi

# Terraform
if ! command -v terraform &> /dev/null; then
    echo "⚠️ Terraform não encontrado. Instalando..."
    # Instalar Terraform (Linux)
    wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
    unzip terraform_1.5.7_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    rm terraform_1.5.7_linux_amd64.zip
    echo "✅ Terraform instalado!"
else
    echo "✅ Terraform: $(terraform version)"
fi

# AWS CLI
if ! command -v aws &> /dev/null; then
    echo "⚠️ AWS CLI não encontrado. Instalando..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws/
    echo "✅ AWS CLI instalado!"
else
    echo "✅ AWS CLI: $(aws --version)"
fi

# Docker
if ! command -v docker &> /dev/null; then
    echo "⚠️ Docker não encontrado. Por favor, instale o Docker manualmente."
    echo "📖 Instruções: https://docs.docker.com/get-docker/"
else
    echo "✅ Docker: $(docker --version)"
fi

# Configurar Git (se necessário)
if [ -z "$(git config --global user.name)" ]; then
    echo "🔧 Configurando Git..."
    read -p "Digite seu nome: " git_name
    read -p "Digite seu email: " git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    echo "✅ Git configurado!"
fi

# Criar arquivo terraform.tfvars se não existir
if [ ! -f "terraform/terraform.tfvars" ]; then
    echo "📝 Criando arquivo terraform.tfvars..."
    cp terraform/terraform.tfvars.example terraform/terraform.tfvars
    echo "⚠️ IMPORTANTE: Edite o arquivo terraform/terraform.tfvars com seus valores!"
fi

# Configurar AWS CLI se necessário
if ! aws sts get-caller-identity &> /dev/null; then
    echo "🔧 AWS CLI não está configurado. Execute:"
    echo "aws configure"
fi

echo "✅ Configuração inicial concluída!"
echo "📋 Próximos passos:"
echo "1. Configure o AWS CLI: aws configure"
echo "2. Edite terraform/terraform.tfvars com um nome único para o bucket"
echo "3. Execute: cd terraform && terraform init"
echo "4. Execute: terraform plan"
echo "5. Execute: terraform apply"
EOF

