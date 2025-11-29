# Tiledesk Dashboard

## Quick Start

### Prerequisites

- Node.js 16 (with `nvm`) for official Angular 14 support.
- npm 8.x (compatible with CLI 14) or use npm from Node 16.

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/Tiledesk/tiledesk-dashboard.git
   cd tiledesk-dashboard
   ```

2. Install dependencies:
   - For a consistent installation, use `npm ci` to install from the `package-lock.json` file.
   - If you encounter peer dependency conflicts, use `npm install --legacy-peer-deps` or add `.npmrc` with `legacy-peer-deps=true` to your project.

3. Start the development server:
   - Without a global CLI, use `npm start` (ng serve) or `npx ng serve`.
   - With AOT in dev, use `ng serve -c devAot` (configured in `angular.json`).

### Troubleshooting

- **`ng: command not found`**: Use `npx ng` or `npm start`, or install `@angular/cli@14` globally if desired.
- **Limpieza**: Remove `node_modules` and `package-lock.json`, then reinstall with `npm install --legacy-peer-deps`.
- **Versiones**: Use `npx ng version` to check your Angular CLI version.

## Contributing

Please read the [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) for details on our coding standards, and how to participate in this project.
