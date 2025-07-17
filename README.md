# Sigma Cube Setup

This project uses a custom fork of Cube.js with Sigma support. Follow these steps to set up your development environment:

## 0. Clone this repo

```sh
cd ~/stripe
git clone https://github.com/lmarshall-stripe/sigma-cube.git
cd sigma-cube
```

## 1. Clone the custom Cube Fork

First, clone the Cube.js fork from lmarshall's repository and switch to the `sigma` branch:

```sh
cd ~/stripe
git clone https://github.com/lmarshall-stripe/cube.git
cd cube
git checkout sigma
```

## 2. Build Cube and `yarn link` the packages

Run the following commands in the Cube.js fork directory:

```sh
./dev-env.sh install
./dev-env.sh build
./dev-env.sh link
```

## 3. Link the Cube packages in this project

Change back to this project directory and run:

```sh
yarn link @cubejs-backend/sigma-driver
yarn link @cubejs-backend/server-core
```

## 4. Configure Environment Variables

Create a `.env` file in this directory with the following contents (replace `CUBEJS_DB_SIGMA_API_KEY` with your actual API key and `CUBEJS_API_SECRET` with a random string):

```
CUBEJS_DEV_MODE=true
CUBEJS_DB_TYPE=sigma
CUBEJS_DB_SIGMA_API_KEY=rk_live_...
CUBEJS_EXTERNAL_DEFAULT=true
CUBEJS_SCHEDULED_REFRESH_DEFAULT=true
CUBEJS_SCHEMA_PATH=model
CUBEJS_WEB_SOCKETS=true
CUBEJS_API_SECRET=<some random string>
```

## 5. Obtain a Sigma API Key

- Visit the [Stripe Shop](https://go/shop) developer dashboard.
- Create a new API key with **read/write access** to Sigma and the Files API.
- Copy the key and add it to your `.env` file in the `CUBEJS_DB_SIGMA_API_KEY` line.

## 6. Start the Server

Once your `.env` is configured, start the development server:

```sh
yarn dev
```
