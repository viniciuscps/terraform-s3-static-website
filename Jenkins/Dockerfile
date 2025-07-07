FROM jenkins/jenkins:lts

USER root

# Instalar dependências
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    python3 \
    python3-pip \
    wget \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Instalar AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws/

# Instalar Terraform
ARG TERRAFORM_VERSION=1.5.7
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Instalar Docker CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Verificar instalações
RUN terraform version && aws --version && docker --version

# Instalar plugins Jenkins essenciais
USER jenkins
RUN jenkins-plugin-cli --plugins \
    git \
    github \
    pipeline-stage-view \
    workflow-aggregator \
    blueocean \
    credentials \
    credentials-binding \
    aws-credentials \
    email-ext \
    build-timeout \
    timestamper \
    ws-cleanup \
    ant \
    gradle \
    pipeline-utility-steps

# Voltar para usuário root para configurações finais
USER root

# Configurar timezone
RUN ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Criar script de inicialização
RUN echo '#!/bin/bash\n\
echo "Iniciando Jenkins com Terraform e AWS CLI"\n\
echo "Terraform version: $(terraform version)"\n\
echo "AWS CLI version: $(aws --version)"\n\
echo "Docker version: $(docker --version)"\n\
exec /usr/local/bin/jenkins.sh "$@"' > /usr/local/bin/start-jenkins.sh \
    && chmod +x /usr/local/bin/start-jenkins.sh

# Definir usuário final
USER jenkins

# Expor portas
EXPOSE 8080 50000

# Comando de inicialização
ENTRYPOINT ["/usr/local/bin/start-jenkins.sh"]