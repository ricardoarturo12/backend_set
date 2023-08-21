# Usar una imagen oficial de Node.js
FROM node:19

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar las dependencias del proyecto
COPY package*.json ./
RUN npm install

# Copiar el resto de los archivos del proyecto
COPY . .

# Exponer el puerto que utiliza Vue.js
EXPOSE 8080

# Comando para iniciar la aplicación
CMD ["npm", "run", "serve"]
