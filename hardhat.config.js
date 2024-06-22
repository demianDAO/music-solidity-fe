require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("@nomicfoundation/hardhat-verify");
const dotenv = require("dotenv");
dotenv.config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.26",
  defaultNetwork: "bnb_testnet",
  networks: {
    bnb_testnet: {
      url: "https://go.getblock.io/545d262ed8744515b100603aa689a3de",
      // url:"https://bsc-testnet.bnbchain.org",
      chainId: 97,
      accounts: [process.env.TEST_ACCOUNT1_PRIVATEKEY],
    },
    sepolia: {
      url: "https://sepolia.infura.io/v3/6b7f3960da564093ade725a5b8e6d3b4",
      accounts: [process.env.TEST_ACCOUNT1_PRIVATEKEY], 
    },
  },
  etherscan: {
    apiKey: process.env.BNB_TESTNETSCAN_API_KEY //bsc
    // apiKey:process.env.SEPOLIA_TESTNETSCAN_API_KEY //sepolia
  },
  sourcify: {
    enabled: true
  }

};
