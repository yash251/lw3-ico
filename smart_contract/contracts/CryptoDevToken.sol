// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    uint256 public constant tokenPrice = 0.001 ether; // price of one token

    uint256 public constant tokensPerNFT = 10 * 10**18; // each NFT would give the user 10 tokens

    uint256 public constant maxTotalSupply = 10000 * 10**18; // max supply of 10000 tokens

    ICryptoDevs CryptoDevsNFT; // CryptoDevsNFT contract instance

    mapping(uint256 => bool) public tokenIdsClaimed; // mapping to keep track of which tokenIds have been claimed

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    function mint(uint256 amount) public payable {
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is incorrect");

        uint256 amountWithDecimals = amount * 10**18;
        require(
            totalSupply() + amountWithDecimals <= maxTotalSupply, // total tokens + amount <= 10000
            "Exceeds the max total supply available"
        );

        _mint(msg.sender, amountWithDecimals);
    }
}
