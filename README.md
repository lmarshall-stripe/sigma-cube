# Sigma Cube Setup

This project uses a custom fork of Cube.js with Sigma support. The setup automatically handles linking the custom packages using the `file:` approach in `package.json`.

## Local Development Setup

### 1. Clone this repo

```sh
cd ~/stripe
git clone https://github.com/lmarshall-stripe/sigma-cube.git
cd sigma-cube
```

### 2. Install Dependencies

The project automatically clones and builds the custom Cube.js fork with Sigma support:

```sh
yarn install
```

This will:
- Clone the custom Cube.js fork from `lmarshall-stripe/cube` (sigma branch)
- Build the custom packages
- Link them using the `file:` references in `package.json`

### 3. Configure Environment Variables

Create a `.env` file in this directory with the following contents (replace `CUBEJS_DB_SIGMA_API_KEY` with your actual API key and `CUBEJS_API_SECRET` with a random string):

```
CUBEJS_DEV_MODE=true
CUBEJS_DB_TYPE=sigma
CUBEJS_DB_SIGMA_API_KEY=rk_live_...
CUBEJS_EXTERNAL_DEFAULT=true
CUBEJS_SCHEDULED_REFRESH_DEFAULT=true
CUBEJS_SCHEMA_PATH=model
CUBEJS_WEB_SOCKETS=true
CUBEJS_TESSERACT_SQL_PLANNER=true
CUBEJS_API_SECRET=<some random string>
```

### 4. Obtain a Sigma API Key

- Visit the [Stripe Shop](https://go/shop) developer dashboard.
- Create a new API key with **read/write access** to Sigma and the Files API.
- Copy the key and add it to your `.env` file in the `CUBEJS_DB_SIGMA_API_KEY` line.

### 5. Start the Development Server

Once your `.env` is configured, start the development server:

```sh
yarn dev
```

The server will be available at `http://localhost:4000`.

## Docker Deployment

### Local Docker Build

To build and run the application using Docker:

```sh
# Build the Docker image
docker build -t sigma-cube .

# Run the container
docker run -p 4000:4000 -p 3000:3000 --env-file .env sigma-cube
```

### Heroku Deployment

The project includes a `heroku.yml` file for easy deployment to Heroku:

1. **Create a Heroku app** (if you haven't already):
   ```sh
   heroku create your-app-name
   ```

2. **Set environment variables** on Heroku:
   ```sh
   heroku config:set CUBEJS_DB_SIGMA_API_KEY=your_api_key_here
   heroku config:set CUBEJS_API_SECRET=your_secret_here
   heroku config:set CUBEJS_DEV_MODE=true
   heroku config:set CUBEJS_DB_TYPE=sigma
   heroku config:set CUBEJS_EXTERNAL_DEFAULT=true
   heroku config:set CUBEJS_SCHEDULED_REFRESH_DEFAULT=true
   heroku config:set CUBEJS_SCHEMA_PATH=model
   heroku config:set CUBEJS_WEB_SOCKETS=true
   heroku config:set CUBEJS_TESSERACT_SQL_PLANNER=true
   ```

3. **Deploy to Heroku**:
   ```sh
   git push heroku main
   ```

## How It Works

### Package Linking

The project uses the `file:` protocol in `package.json` to automatically link the custom Cube.js packages:

```json
{
  "dependencies": {
    "@cubejs-backend/server-core": "file:./cube/packages/cubejs-server-core",
    "@cubejs-backend/sigma-driver": "file:./cube/packages/cubejs-sigma-driver"
  }
}
```

This approach:
- ✅ Automatically handles package linking
- ✅ Works reliably in containers
- ✅ No manual symlink management needed
- ✅ Standard npm/yarn feature

### Custom Cube.js Fork

The project uses a custom fork of Cube.js that includes:
- Sigma driver support
- Custom modifications for Stripe's Sigma API
- Enhanced functionality for the specific use case

The fork is automatically cloned and built during the installation process.

## Troubleshooting

### Package Linking Issues

If you encounter issues with the custom packages not being found:

1. **Verify the packages are built**:
   ```sh
   ls -la cube/packages/cubejs-server-core/dist/
   ls -la cube/packages/cubejs-sigma-driver/dist/
   ```

2. **Rebuild the packages**:
   ```sh
   cd cube && ./dev-env.sh build
   cd .. && yarn install
   ```

3. **Check package resolution**:
   ```sh
   node -e "console.log(require.resolve('@cubejs-backend/server-core'));"
   node -e "console.log(require.resolve('@cubejs-backend/sigma-driver'));"
   ```

### Docker Issues

If the Docker build fails:

1. **Check the build logs** for specific error messages
2. **Verify the cube repository** is accessible
3. **Ensure all environment variables** are properly set

## Project Structure

```
sigma-cube/
├── cube/                    # Custom Cube.js fork (auto-cloned)
├── model/                   # Cube.js schema definitions
│   ├── cubes/              # Data cube definitions
│   └── views/              # View definitions
├── cube.js                 # Cube.js configuration
├── package.json            # Dependencies with file: references
├── Dockerfile              # Docker configuration
├── heroku.yml              # Heroku deployment config
└── README.md               # This file
```
