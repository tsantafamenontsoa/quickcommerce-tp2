# ============================================
# Dockerfile - QuickCommerce API AWS
# ============================================

FROM node:18-alpine

# Installer wget pour health check
RUN apk add --no-cache wget

# Répertoire de travail
WORKDIR /app

# Copier package.json
COPY package*.json ./

# Installer dépendances de production
RUN npm install --production && \
    npm cache clean --force

# Copier le code source
COPY . .

# Exposer le port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:3000/health || exit 1

# Démarrer l'application
CMD ["node", "src/index.js"]
