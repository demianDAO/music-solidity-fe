require("@nomicfoundation/hardhat-toolbox");
const dotenv = require("dotenv");
dotenv.config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  defaultNetwork: "bnb_testnet",
  networks: {
    bnb_testnet: {
      url: "https://data-seed-prebsc-1-s1.bnbchain.org:8545",
      chainId: 97,
      accounts: [process.env.TEST_ACCOUNT2_PRIVATEKEY],
    },
    sepolia: {
      url: "https://sepolia.infura.io/v3/6b7f3960da564093ade725a5b8e6d3b4",
      accounts: [process.env.TEST_ACCOUNT1_PRIVATEKEY], 
    },
  },
  etherscan: {
    apiKey: process.env.BNB_TESTNETSCAN_API_KEY //bsc
    // apiKey:process.env.SEPOLIA_TESTNETSCAN_API_KEY //sepolia
  }
};
