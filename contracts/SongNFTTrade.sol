// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "./SongNFT.sol";
import "./MPToken.sol";

contract SongNFTTrade {
    MPToken public token;
    SongNFT public nft;

    struct SongInfo{
        uint price;
        uint tokenId;
    }

    struct SongDetails {
        uint tokenId;
        string tokenURI;
        uint balance;
        uint price;
    }

    event SongPurchased(uint256 indexed id, address buyer, uint256 price);
    event SongCreated(uint256 indexed tokenId, address indexed owner, uint256 price, string tokenURI);

    mapping(address => SongInfo[]) public songInfos;

    constructor(MPToken _token, SongNFT _nft) {
        token = _token;
        nft = _nft;
    }

    function CreateSong(
        uint amount,
        uint price,
        string memory uri
    ) external {
        SongInfo[] storage curSongInfos = songInfos[msg.sender];

        uint tokenId = nft.currentID();
        
        curSongInfos.push(SongInfo({
            price: price,
            tokenId: tokenId
        }));

        nft.mint(msg.sender, amount, uri);
        emit SongCreated(tokenId, msg.sender, price, uri);
    }

    function getSongInfos() external view returns (SongDetails[] memory) {
        SongInfo[] storage userSongInfos = songInfos[msg.sender];
        uint length = userSongInfos.length;
        SongDetails[] memory details = new SongDetails[](length);

        for (uint i = 0; i < length; i++) {
            uint tokenId = userSongInfos[i].tokenId;
            string memory tokenURI = nft.uri(tokenId);
            uint balance = nft.balanceOf(msg.sender, tokenId);
            uint price = userSongInfos[i].price;

            details[i] = SongDetails({
                tokenId: tokenId,
                tokenURI: tokenURI,
                balance: balance,
                price: price
            });
        }

        return details;
    }

   function purchaseSong(uint256 id, address singer) external {
        require(nft.balanceOf(singer, id) > 0, "Sold out");

        // Find the price of the NFT
        uint price = 0;
        SongInfo[] storage curSongInfos = songInfos[singer];
        for (uint i = 0; i < curSongInfos.length; i++) {
            if (curSongInfos[i].tokenId == id) {
                price = curSongInfos[i].price;
                break;
            }
        }

        require(price > 0, "Song not listed for sale");

        require(token.transferFrom(msg.sender, singer, price), "Token transfer failed");

        nft.safeTransferFrom(singer, msg.sender, id, 1);

        emit SongPurchased(id, msg.sender, price);
    }
}
