import { HardhatUserConfig } from "hardhat/config";

import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";


const INFURA_SEPOLIA_ENDPOINT = process.env.INFURA_SEPOLIA_ENDPOINT;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const config: HardhatUserConfig = {
  solidity: "0.8.10",
  networks: {
    sepolia: {
      url: INFURA_SEPOLIA_ENDPOINT,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  }
};

// console.log(config.networks?.goerli?.gasPrice);



export default config;
