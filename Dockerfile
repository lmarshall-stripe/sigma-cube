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
# This will automatically link the local packages via file: references
RUN yarn install --frozen-lockfile

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