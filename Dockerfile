FROM node:22.16.0

# Install git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /sigma-cube

# Shallow clone the Cube repo at the 'sigma' branch
RUN git clone --branch sigma --single-branch --depth 1 https://github.com/lmarshall-stripe/cube.git cube

# Install cube dependencies and build cube packages
RUN cd cube && ./dev-env.sh install && ./dev-env.sh build

# Copy package files first for better layer caching
COPY package.json ./
COPY yarn.lock ./

# Install dependencies (including devDependencies since we need cubejs-server)
RUN yarn install --frozen-lockfile

# Remove the existing packages and replace with local versions
RUN rm -rf node_modules/@cubejs-backend/server-core node_modules/@cubejs-backend/sigma-driver

# Copy the built packages from the cube directory
RUN cp -r cube/packages/cubejs-server-core node_modules/@cubejs-backend/server-core
RUN cp -r cube/packages/cubejs-sigma-driver node_modules/@cubejs-backend/sigma-driver

# Alternative approach: Use yarn link with proper setup
RUN cd cube/packages/cubejs-server-core && yarn link
RUN cd cube/packages/cubejs-sigma-driver && yarn link
RUN yarn link "@cubejs-backend/server-core" "@cubejs-backend/sigma-driver"

# Verify the packages are properly linked/copied
RUN ls -la node_modules/@cubejs-backend/ && echo "Checking if packages are properly linked..."
RUN node -e "console.log('Server core path:', require.resolve('@cubejs-backend/server-core')); console.log('Sigma driver path:', require.resolve('@cubejs-backend/sigma-driver'));"

# Copy in your Cube schema and config
COPY model/ ./model/
COPY cube.js ./

# Set environment variable for development
ENV NODE_ENV=development

# set other environment variables
ENV CUBEJS_DEV_MODE=true
ENV CUBEJS_DB_TYPE=sigma
ENV CUBEJS_EXTERNAL_DEFAULT=true
ENV CUBEJS_SCHEDULED_REFRESH_DEFAULT=true
ENV CUBEJS_SCHEMA_PATH=model
ENV CUBEJS_WEB_SOCKETS=true
ENV CUBEJS_TESSERACT_SQL_PLANNER=true

EXPOSE 4000 3000

CMD ["yarn", "dev"] 