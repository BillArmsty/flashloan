import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: "0.8.10",
  networks: {
    goerli: {
      url: process.env.INFURA_GOERLI_ENDPOINT,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],

    }
  }
};

export default config;
