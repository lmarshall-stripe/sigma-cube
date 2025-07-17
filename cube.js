// Cube configuration options: https://cube.dev/docs/config
/** @type{ import('@cubejs-backend/server-core').CreateOptions } */
module.exports = {
    // some hacking around to try to support multiple merchants
    // but it's not working yet
    // contextToAppId: ({ securityContext }) =>
    //     `CUBE_APP_${securityContext.merchant}`,
    // contextToOrchestratorId: ({ securityContext }) =>
    //     `CUBE_APP_${securityContext.merchant}`,
    // driverFactory: ({ securityContext }) => ({
    //     type: "sigma",
    //     apiKey: process.env[`CUBEJS_DB_SIGMA_API_KEY_${securityContext.merchant.toUpperCase()}`],
    //   })
};
