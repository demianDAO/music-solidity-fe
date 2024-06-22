const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const dotenv = require("dotenv");
dotenv.config();

module.exports = buildModule("NFTModule", (m) => {
  const owner = m.getAccount(1);
  console.log(owner);
  const mpToken = m.contract("MPToken");
  const songNFT = m.contract("SongNFT");
  const songNFTTrade = m.contract("SongNFTTrade", [mpToken, songNFT]);
  return { songNFTTrade };
});


