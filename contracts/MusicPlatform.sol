// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract MusicPlatform is ERC1155, Ownable {
    constructor(address initialOwner) ERC1155("") Ownable(initialOwner) {}

    uint256 public currentID = 0;
    mapping(uint256 => string) public tokenURIs;

    function mint(
        address account,
        uint256 amount,
        string memory uri
    ) public onlyOwner {
        _mint(account, currentID, amount, "");
        tokenURIs[currentID] = uri;
        currentID++;
    }

    function safeTransferFrom(address from, address to, uint256 id, uint256 value) external  {
        super.safeTransferFrom(from,  to,  id,  value, "");
    }
}
