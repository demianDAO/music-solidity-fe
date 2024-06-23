// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SongNFT.sol";
import "./MPToken.sol";

contract SongNFTTrade {
    MPToken public token;
    SongNFT public nft;


    struct SongDetails {
        uint tokenId;
        string tokenURI;
        uint balance;
        uint price;
    }

    event SongPurchased(uint256 indexed tokenId, address buyer, uint256 price, address singer);

    event ReleasedSong(
        address indexed singer,
        uint256 price,
        string tokenURI,
        uint256 tokenId,
        uint amount
    );

    mapping(address => mapping(uint => uint)) public songPricesByAddr;
    mapping(address => uint[]) songTokenIdsByAddr;

    constructor(address _token, address _nft) {
        token = MPToken(_token);
        nft = SongNFT(_nft);
    }

    function releasedSong(uint amount, uint price, string memory uri) external {
        uint tokenId = nft.currentID();
        songPricesByAddr[msg.sender][tokenId] = price;
        songTokenIdsByAddr[msg.sender].push(tokenId);
        nft.mint(msg.sender, amount, uri);
        emit ReleasedSong(msg.sender, price, uri, tokenId, amount);
    }

    function getSongInfos(address user) external view returns (SongDetails[] memory) {
        uint[] memory tokenIds = songTokenIdsByAddr[user];
        uint len = tokenIds.length;
        require(len > 0, "No songs released");
        SongDetails[] memory details = new SongDetails[](len);

        for (uint i = 0; i < len; i++) {
            uint tokenId = tokenIds[i];
            string memory tokenURI = nft.uri(tokenId);
            uint balance = nft.balanceOf(user, tokenId);
            uint price = songPricesByAddr[user][tokenId];

            details[i] = SongDetails({
                tokenId: tokenId,
                tokenURI: tokenURI,
                balance: balance,
                price: price
            });
        }

        return details;
    }

    function purchaseSong(uint256 tokenId, address singer) external {
        require(nft.balanceOf(singer, tokenId) > 0, "Sold out");

        uint price = songPricesByAddr[singer][tokenId];

        require(price > 0, "Song not listed for sale");

        require(
            token.transferFrom(msg.sender, singer, price),
            "Token transfer failed"
        );

        nft.safeTransferFrom(singer, msg.sender, tokenId, 1);

        songPricesByAddr[msg.sender][tokenId] = price;
        songTokenIdsByAddr[msg.sender].push(tokenId);

        emit SongPurchased(tokenId, msg.sender, price, singer);
    }
}
