// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "./SongNFT.sol";

contract SongNFTTrade {
    IERC20 public token; 
    SongNFT public nft; 

    event SongPurchased(uint256 indexed id, address buyer, uint256 price);

    constructor(IERC20 _token, SongNFT _nft) {
        token = _token;
        nft = _nft;
    }

    function purchaseSong(
        uint256 id,
        uint price,
        address singer
    ) external  {
        require(nft.balanceOf(msg.sender, id) == 0, "Already owns the token");

        require(nft.balanceOf(singer, id) > 0, "Insufficient token balance");

        // 将代币从用户转移到歌手
        token.transferFrom(msg.sender, singer, price);

        // 将NFT转移给购买者
        nft.safeTransferFrom(singer, msg.sender, id, 1);

        emit SongPurchased(id, msg.sender, price);
    }
}
