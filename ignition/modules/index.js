const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const dotenv = require("dotenv");
dotenv.config();

module.exports = buildModule("NFTModule", (m) => {
  // const mpToken = m.contract("MPToken", [process.env.TEST_ACCOUNT1_ADDRESS]);
  // const songNFT = m.contract("SongNFT");
  const songNFTTrade = m.contract("SongNFTTrade", [process.env.TOKEN, process.env.NFT]);
  return { songNFTTrade };
});
