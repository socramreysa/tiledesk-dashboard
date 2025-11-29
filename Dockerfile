# ==== STAGE 1: Build ====
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies using lockfile when available
COPY package*.json ./
RUN npm ci

# Copy source and build Angular app (production)
COPY . .
RUN npm run build -- --configuration=production

# ==== STAGE 2: Nginx runtime ====
FROM nginx:alpine

# Use project nginx.conf for SPA routing and caching if present
COPY nginx.conf /etc/nginx/nginx.conf

# Copy compiled app to Nginx html directory
# Note: angular.json sets outputPath to "dist"
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
