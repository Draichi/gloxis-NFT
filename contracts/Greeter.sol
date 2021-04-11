//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Gloxis is ERC721 {
    uint256 cooldownTime = 1 days;
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    using SafeMath for uint16;
    using SafeMath for uint32;
    using SafeMath for uint256;

    struct Character {
        uint256 strength;
        string name;
        uint256 eyeColor;
        uint256 hairColor;
        uint256 skinColor;
        uint256 winCount;
        uint256 manaCount;
        uint256 level;
        uint32 readyTime;
    }

    Character[] public characters;

    mapping(uint256 => address) public characterToOwner;

    constructor() public ERC721("Gloxis", "GXS") {}

    modifier onlyOwnerOf(uint256 _characterId) {
        require(msg.sender == characterToOwner[_characterId]);
        _;
    }

    /**
     * Requests randomness from a user-provided seed
     */
    function requestNewRandomCharacter(string memory name) public {
        uint256 newId = characters.length;
        // get random from abi
        uint256 randomNumber = _generateRandomDna(name);
        uint256 strength = (randomNumber % 100);
        uint256 eyeColor = ((randomNumber % 10000) / 100);
        uint256 hairColor = ((randomNumber % 1000000) / 10000);
        uint256 skincolor = ((randomNumber % 1000000) / 10000);

        characters.push(
            Character(
                strength,
                name,
                eyeColor,
                hairColor,
                skincolor,
                0,
                25,
                1,
                uint32(block.timestamp + cooldownTime)
            )
        );
        console.log("id:", newId);
        _safeMint(msg.sender, newId);
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }

    function _triggerCooldown(Character storage _character) internal {
        _character.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function attack(uint256 _characterId, uint256 _targetId)
        external
        onlyOwnerOf(_characterId)
    {
        Character storage myCharacter = characters[_characterId];
        Character storage targetCharacter = characters[_targetId];
        console.log("win count:", myCharacter.winCount);
        myCharacter.winCount = myCharacter.winCount.add(1);
        myCharacter.level = myCharacter.level.add(1);
        targetCharacter.manaCount = targetCharacter.manaCount.sub(1);
        _triggerCooldown(myCharacter);
    }
}
