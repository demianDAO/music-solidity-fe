const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Test", function () {
  async function deployFixture() {
    const [singer, userA, userB] = await ethers.getSigners();

    const mpToken = await ethers.deployContract("MPToken");
    const songNFT = await ethers.deployContract("SongNFT");
    const songNFTTrade = await ethers.deployContract("SongNFTTrade", [
      mpToken.target,
      songNFT.target,
    ]);

    // mint
    mpToken.mint(singer, ethers.parseEther("1000"));
    mpToken.mint(userA, ethers.parseEther("1000"));
    mpToken.mint(userB, ethers.parseEther("1000"));
    // approve
    mpToken.approve(songNFTTrade.target, ethers.parseEther("1000"));
    mpToken
      .connect(userA)
      .approve(songNFTTrade.target, ethers.parseEther("1000"));
    mpToken
      .connect(userB)
      .approve(songNFTTrade.target, ethers.parseEther("1000"));
    return { singer, userA, userB, songNFTTrade, songNFT,mpToken };
  }

  describe("Deployment", function () {
    it("releasedSong", async function () {
      const { singer, userA, userB, songNFTTrade, songNFT,mpToken } = await loadFixture(
        deployFixture
      );
      await songNFTTrade.releasedSong(
        100n,
        ethers.parseEther("9"),
        "uri_test_1"
      );
      await songNFTTrade.releasedSong(
        90n,
        ethers.parseEther("8"),
        "uri_test_2"
      );

      let info = await songNFTTrade.getSongInfos(singer.address);
      console.log(info);
      await songNFT
        .connect(singer)
        .setApprovalForAll(songNFTTrade.target, true);
      console.log("--------buy--------");
      await songNFTTrade.connect(userA).purchaseSong(0n, singer.address);
      await songNFTTrade.connect(userA).purchaseSong(1n, singer.address);

      let singerInfo = await songNFTTrade.getSongInfos(singer.address);
      let userAInfo = await songNFTTrade.getSongInfos(userA.address);

      console.log("singer info: ", singerInfo);
      console.log("userAInfo: ", userAInfo);

      let singerBal = await mpToken.balanceOf(singer.address);
      let userABal = await mpToken.balanceOf(userA.address);

      console.log("singerBal: ", singerBal);
      console.log("userABal: ", userABal);

    });
  });
});
