// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "./SongNFT.sol";
import "./MPToken.sol";

contract SongNFTTrade {
    MPToken public token;
    SongNFT public nft;

    struct MusicInfo{
        uint price;
        uint tokenId;
    }

    struct MusicDetails {
        uint tokenId;
        string tokenURI;
        uint balance;
        uint price;
    }

    event SongPurchased(uint256 indexed id, address buyer, uint256 price);

    mapping(address => MusicInfo[]) public musicInfos;

    constructor(MPToken _token, SongNFT _nft) {
        token = _token;
        nft = _nft;
    }

    function CreateMusic(
        uint amount,
        uint price,
        string memory uri
    ) external {
        MusicInfo[] storage curMusicInfos = musicInfos[msg.sender];
        
        curMusicInfos.push(MusicInfo({
            price: price,
            tokenId: nft.currentID()
        }));

        nft.mint(msg.sender, amount, uri);
    }

    function getMusicInfos() external view returns (MusicDetails[] memory) {
        MusicInfo[] storage userMusicInfos = musicInfos[msg.sender];
        uint length = userMusicInfos.length;
        MusicDetails[] memory details = new MusicDetails[](length);

        for (uint i = 0; i < length; i++) {
            uint tokenId = userMusicInfos[i].tokenId;
            string memory tokenURI = nft.uri(tokenId);
            uint balance = nft.balanceOf(msg.sender, tokenId);
            uint price = userMusicInfos[i].price;

            details[i] = MusicDetails({
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
        MusicInfo[] storage curMusicInfos = musicInfos[singer];
        for (uint i = 0; i < curMusicInfos.length; i++) {
            if (curMusicInfos[i].tokenId == id) {
                price = curMusicInfos[i].price;
                break;
            }
        }

        require(price > 0, "Song not listed for sale");

        require(token.transferFrom(msg.sender, singer, price), "Token transfer failed");

        nft.safeTransferFrom(singer, msg.sender, id, 1);

        emit SongPurchased(id, msg.sender, price);
    }
}
