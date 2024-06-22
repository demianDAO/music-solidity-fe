const { ethers } = require("hardhat");
const dotenv = require("dotenv");
dotenv.config();

async function main() {
  let [accountA] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", accountA.address);

  // let songNFT = await ethers.deployContract("SongNFT");
  // await songNFT.waitForDeployment();
  // let mpToken = await ethers.deployContract("MPToken");
  // await mpToken.waitForDeployment();

  const songNFTTrade = await ethers.deployContract("SongNFTTrade", [
    "0xB8d69F2d53D62815CF3831c5bd693Af918956b11",
    "0xcD48B29352ADd81B081fB3aB6c94aFA4E8098709",
  ]);
  await songNFTTrade.waitForDeployment();

  // console.log("SongNFT deployed at:", songNFT.target);
  // console.log("MPToken deployed at:", mpToken.target);
  console.log("SongNFTTrade deployed at:", songNFTTrade.target);
}

// SongNFT deployed at: 0xcD48B29352ADd81B081fB3aB6c94aFA4E8098709
// MPToken deployed at: 0xB8d69F2d53D62815CF3831c5bd693Af918956b11
// SongNFTTrade deployed at: 0x270d13E5FaC6C4D2E91b0872b6552eC158850502

// We recommend this pattern to be able to use async/await everywhere and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
