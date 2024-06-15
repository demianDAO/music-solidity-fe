// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

contract SongNFT is ERC1155URIStorage {
    constructor() ERC1155(""){}

    uint256 public currentID;

    function mint(
        address to,
        uint256 amount,
        string memory uri
    ) external {
        _mint(to, currentID, amount, "");
        _setURI(currentID, uri);
        currentID++;
    }

    function safeTransferFrom(address from, address to, uint256 id, uint256 value) external  {
        super.safeTransferFrom(from,  to,  id,  value, "");
    }
}
