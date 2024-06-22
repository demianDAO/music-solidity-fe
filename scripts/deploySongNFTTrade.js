// This import is necessary to work with Hardhat's hre object

const { ethers } = require("hardhat");
const dotenv = require("dotenv");
dotenv.config();
// const { ethers, deployments } = require("hardhat");
// require("@nomicfoundation/hardhat-ethers");

async function main() {
   let [accountA] = await ethers.getSigners();
   console.log("Deploying contracts with the account:", accountA.address);
  const SongNFTTrade = await ethers.deployContract("SongNFTTrade", [
    process.env.TOKEN,
    process.env.NFT,
  ]);

  console.log("SongNFTTrade deployed at:", SongNFTTrade.target);
}

// We recommend this pattern to be able to use async/await everywhere and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
