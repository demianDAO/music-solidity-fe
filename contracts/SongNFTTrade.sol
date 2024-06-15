// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "./SongNFT.sol";

contract SongNFTTrade {
    IERC20 public token; 
    SongNFT public nft; 

    event SongPurchased(uint256 indexed id, address buyer, uint256 price);

    mapping (address => mapping(uint => uint)) public priceList;

    constructor(IERC20 _token, SongNFT _nft) {
        token = _token;
        nft = _nft;
    }

    function setPrice(uint id, uint price) external {
        priceList[msg.sender][id] = price;
    }

    function getPrice(uint id) external view returns (uint) {
        return priceList[msg.sender][id];
    }

    function purchaseSong(
        uint256 id,
        address singer
    ) external  {
        require(nft.balanceOf(singer, id) > 0, "Sold out");

        uint price = priceList[singer][id];

        token.transferFrom(msg.sender, singer, price);
     
        nft.safeTransferFrom(singer, msg.sender, id, 1);

        emit SongPurchased(id, msg.sender, price);
    }
}
