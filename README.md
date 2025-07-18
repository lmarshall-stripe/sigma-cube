# Sigma Cube Setup

This project uses a custom fork of Cube.js with Sigma support. The setup uses `yarn link` to connect the custom packages.

## Local Development Setup

### 1. Clone this repo

```sh
cd ~/stripe
git clone https://github.com/lmarshall-stripe/sigma-cube.git
cd sigma-cube
```

### 2. Clone and Build the Custom Cube.js Fork

The project requires a custom Cube.js fork with Sigma support. Clone and build it:

```sh
# Clone the custom Cube.js fork
git clone --branch sigma --single-branch --depth 1 https://github.com/lmarshall-stripe/cube.git cube

# Install dependencies and build packages
cd cube && ./dev-env.sh install && ./dev-env.sh build

# Link the packages globally
./dev-env.sh link

# Return to project root
cd ..
```

### 3. Install Dependencies and Link Packages

```sh
# Install project dependencies
yarn install --frozen-lockfile

# Link the specific cube packages we need
yarn link "@cubejs-backend/server-core" "@cubejs-backend/sigma-driver"
```

### 4. Configure Environment Variables

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

### 5. Obtain a Sigma API Key

- Visit the [Stripe Shop](https://go/shop) developer dashboard.
- Create a new API key with **read/write access** to Sigma and the Files API.
- Copy the key and add it to your `.env` file in the `CUBEJS_DB_SIGMA_API_KEY` line.

### 6. Start the Development Server

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

### Render Deployment

To deploy to Render, follow these steps:

1. **Create a Render account** at [render.com](https://render.com)

2. **Create a new Web Service**:
   - Click "New +" and select "Web Service"
   - Connect your GitHub repository
   - Choose the repository containing this project

3. **Configure the service**:
   - **Name**: `sigma-cube` (or your preferred name)
   - **Environment**: `Docker`
   - **Region**: Choose the closest to your users
   - **Branch**: `main` (or your default branch)
   - **Root Directory**: Leave empty (if the Dockerfile is in the root)

4. **Set environment variables** in the Render dashboard:
   ```
   CUBEJS_DB_SIGMA_API_KEY=your_api_key_here
   CUBEJS_API_SECRET=your_secret_here
   CUBEJS_DEV_MODE=true
   CUBEJS_DB_TYPE=sigma
   CUBEJS_EXTERNAL_DEFAULT=true
   CUBEJS_SCHEDULED_REFRESH_DEFAULT=true
   CUBEJS_SCHEMA_PATH=model
   CUBEJS_WEB_SOCKETS=true
   CUBEJS_TESSERACT_SQL_PLANNER=true
   ```

5. **Configure the service**:
   - **Build Command**: Leave empty (Docker handles this)
   - **Start Command**: Leave empty (Docker CMD handles this)
   - **Port**: `4000`

6. **Deploy**:
   - Click "Create Web Service"
   - Render will automatically build and deploy your application
   - The first build may take 10-15 minutes due to the Cube.js build process

7. **Access your application**:
   - Once deployed, you'll get a URL like `https://your-app-name.onrender.com`
   - The Cube.js server will be available at this URL

## How It Works

### Package Linking

The project uses `yarn link` to connect the custom Cube.js packages:

1. **Global linking**: The custom packages are linked globally using `./dev-env.sh link`
2. **Local linking**: The project links to the global packages using `yarn link`

This approach:
- ✅ Uses the built packages from the custom fork
- ✅ Allows for custom modifications to Cube.js
- ✅ Works in both local development and Docker environments

### Custom Cube.js Fork

The project uses a custom fork of Cube.js that includes:
- Sigma driver support
- Custom modifications for Stripe's Sigma API
- Enhanced functionality for the specific use case

The fork is cloned and built during the setup process.

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

4. **Re-link packages**:
   ```sh
   cd cube && ./dev-env.sh link
   cd .. && yarn link "@cubejs-backend/server-core" "@cubejs-backend/sigma-driver"
   ```

### Docker Issues

If the Docker build fails:

1. **Check the build logs** for specific error messages
2. **Verify the cube repository** is accessible
3. **Ensure all environment variables** are properly set
4. **Check that the packages are properly linked** in the container

### Render Issues

If deployment to Render fails:

1. **Check the build logs** in the Render dashboard for specific error messages
2. **Verify all environment variables** are set correctly in Render
3. **Ensure the Docker build** works locally first
4. **Check that the repository** is properly connected to Render
5. **Verify the port configuration** matches your application (should be 4000)

Common Render issues:
- **Build timeout**: The first build may take longer than the default timeout. Consider upgrading to a paid plan for longer build times.
- **Memory issues**: The Cube.js build process is memory-intensive. Render's free tier may not be sufficient.
- **Environment variables**: Make sure all required environment variables are set in the Render dashboard.

## Project Structure

```
sigma-cube/
├── cube/                    # Custom Cube.js fork (cloned during setup)
├── model/                   # Cube.js schema definitions
│   ├── cubes/              # Data cube definitions
│   └── views/              # View definitions
├── cube.js                 # Cube.js configuration
├── package.json            # Project dependencies
├── Dockerfile              # Docker configuration
└── README.md               # This file
```