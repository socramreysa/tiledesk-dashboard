# Tiledesk Dashboard - Docker build and run

This repository is an Angular app. The Angular CLI `outputPath` is `dist` as defined in [angular.json](angular.json).

## Dockerfile overview

- Stage 1: `node:16-alpine` builds production artifacts using `npm run build:prod`.
- Stage 2: `nginx:alpine` serves the static files from `/usr/share/nginx/html` and copies local [nginx.conf](nginx.conf) for SPA routing.

## Build image

```bash
docker build -t marcos/tiledesk-dashboard:dev .
```

## Run container

```bash
docker run --rm -p 4500:80 marcos/tiledesk-dashboard:dev
```

Then open http://localhost:4500

## Notes

- Output path:
  - The Dockerfile copies from `/app/dist` which matches the current [angular.json](angular.json) `outputPath: "dist"`.
  - If your build later produces `dist/<project-name>`, adjust the COPY path accordingly.

- SPA routing:
  - [nginx.conf](nginx.conf) is copied automatically by the Dockerfile to `/etc/nginx/nginx.conf`.

- Optional runtime config substitution (restore previous behavior):
  - If you need to generate `dashboard-config.json` at container start from `dashboard-config-template.json` using environment variables, replace the final CMD with:
    ```Dockerfile
    CMD ["/bin/sh", "-c", "envsubst < /usr/share/nginx/html/dashboard-config-template.json > /usr/share/nginx/html/dashboard-config.json && exec nginx -g 'daemon off;'"]
    ```

- Clean rebuild:
  ```bash
  docker build --no-cache -t marcos/tiledesk-dashboard:dev .
  ```

- Multi-arch (if needed):
  ```bash
  docker buildx build --platform linux/amd64 -t marcos/tiledesk-dashboard:dev --load .