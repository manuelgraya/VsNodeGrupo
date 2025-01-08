# Usamos Amazon Linux 2 como base
FROM amazonlinux:2

# Actualizamos el sistema e instalamos dependencias necesarias
RUN yum update -y && \
    yum install -y git htop wget curl ruby tar && \
    yum clean all

# Configuramos el directorio de NVM
ENV NVM_DIR=/root/.nvm
ENV PATH=$NVM_DIR/versions/node/v16.20.0/bin:$PATH

# Instalamos NVM, Node.js (versión 16 LTS) y PM2
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install 16.20.0 && \
    nvm use 16.20.0 && \
    nvm alias default 16.20.0 && \
    npm install -g pm2

# Clonamos el repositorio
RUN git clone https://github.com/JaviRabago/VsNodeGrupo.git /app
WORKDIR /app

# Instalamos las dependencias de la aplicación
RUN . $NVM_DIR/nvm.sh && npm install

# Exponemos el puerto de la aplicación
EXPOSE 3000

# Ejecutamos la aplicación con PM2
CMD ["pm2-runtime", "start", "app.js", "--name=nodejs-express-app"]
