//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Gloxis is ERC721 {
    string greeting;

    struct Character {
        uint256 strength;
        string name;
        string eyeColor;
        string hairColor;
        string skinColor;
    }

    Character[] public characters;

    constructor() public ERC721("Gloxis", "GXS") {}

    /**
     * Requests randomness from a user-provided seed
     */
    function requestNewRandomCharacter(string memory name) public {
        uint256 newId = characters.length;
        // get random from abi
        uint256 strength = (randomNumber % 100);
        string eyeColor = ((randomNumber % 10000) / 100);
        string hairColor = ((randomNumber % 1000000) / 10000);
        string skincolor = ((randomNumber % 1000000) / 10000);

        characters.push(
            Character(strength, name, eyeColor, hairColor, skincolor)
        );
        _safeMint(msg.sender, newId);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }
}
