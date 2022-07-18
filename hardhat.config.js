require('dotenv').config()
require('@nomiclabs/hardhat-waffle')
require('@nomiclabs/hardhat-etherscan')
const { INFURA_RINKEBY, PRIVATE_KEY_TEST, ETHERSCAN} = process.env

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  paths: {
    artifacts: './client/src/artifacts',
  },
  solidity: {
    version: '0.8.7',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    rinkeby: {
      url: INFURA_RINKEBY,
      accounts: [`0x${PRIVATE_KEY_TEST}`],
    },
    // mainnet: {
    //   url: process.env.INFURA_MAINNET,
    //   accounts: [PRIVATE_KEY_CLIENT],
    // },
  },
  etherscan: {
    apiKey: ETHERSCAN,
  },
};