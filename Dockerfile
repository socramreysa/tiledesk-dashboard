# ==== STAGE 1: Build ====
FROM node:16-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies using lockfile when available
#COPY package*.json ./
# Use legacy peer deps to avoid Angular 14 peer conflicts during CI in container
#RUN npm install --legacy-peer-deps
#comentados para usar /node_modules ya existentes en el host

# Copy source and build Angular app (production)
COPY . .
RUN npm run build:prod

# ==== STAGE 2: Nginx runtime ====
FROM nginx:alpine

# Use project nginx.conf for SPA routing and caching if present
COPY nginx.conf /etc/nginx/nginx.conf

# Copy compiled app to Nginx html directory
# Note: angular.json sets outputPath to "dist"
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
