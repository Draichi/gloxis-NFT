//SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Gloxis is ERC721, VRFConsumerBase {
    address internal vrfCoordinator;
    bytes32 internal keyHash;
    uint256 internal fee;

    uint256 public randomResult;

    uint256 cooldownTime = 1 days;
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    using SafeMathChainlink for uint16;
    using SafeMathChainlink for uint32;
    using SafeMathChainlink for uint256;

    struct Character {
        string name;
        uint256 eyeColor;
        uint256 hairColor;
        uint256 skinColor;
        uint32 winCount;
        uint32 manaCount;
        uint32 level;
        uint32 readyTime;
    }

    Character[] public characters;

    mapping(uint256 => address) public characterToOwner;
    mapping(bytes32 => string) requestToCharacterName;
    mapping(bytes32 => address) requestToSender;
    mapping(bytes32 => uint256) requestToTokenId;

    /**
     * Constructor inherits VRFConsumerBase
     *
     * Network: Rinkeby
     * Chainlink VRF Coordinator address: 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
     * LINK token address:                0x01BE23585060835E02B77ef475b0Cc51aA1e0709
     * Key Hash: 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311
     */
    constructor(
        address _VRFCoordinator,
        address _linkTokenAddress,
        bytes32 _keyHash
    )
        public
        VRFConsumerBase(_VRFCoordinator, _linkTokenAddress)
        ERC721("Gloxis", "GXS")
    {
        vrfCoordinator = _VRFCoordinator;
        keyHash = _keyHash;
        fee = 0.1 * 10**18; // 0.1 LINK
    }

    modifier onlyOwnerOf(uint256 _characterId) {
        require(
            msg.sender == characterToOwner[_characterId],
            "Only the owner can call this function"
        );
        _;
    }

    /**
     * Requests randomness from a user-provided seed
     */
    function requestNewRandomCharacter(
        uint256 userProvidedSeed,
        string memory name
    ) public returns (bytes32) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );
        bytes32 requestId = requestRandomness(keyHash, fee, userProvidedSeed);
        requestToCharacterName[requestId] = name;
        requestToSender[requestId] = msg.sender;
        return requestId;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        uint256 newId = characters.length;
        console.log("> randomNumber:", randomNumber);
        uint256 eyeColor = ((randomNumber % 10000) / 100);
        console.log("> eyeColor:", eyeColor);
        uint256 hairColor = ((randomNumber % 1000000) / 10000);
        uint256 skincolor = ((randomNumber % 1000000) / 10000);

        characters.push(
            Character(
                requestToCharacterName[requestId],
                eyeColor,
                hairColor,
                skincolor,
                0,
                25,
                1,
                uint32(block.timestamp)
            )
        );
        characterToOwner[newId] = msg.sender;
        _safeMint(requestToSender[requestId], newId);
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function getCharactersCount() public view returns (uint256 count) {
        return characters.length;
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

    function _isReady(Character storage _character)
        internal
        view
        returns (bool)
    {
        return (_character.readyTime <= block.timestamp);
    }

    function shareMana(uint256 _characterId, uint256 _targetId)
        external
        onlyOwnerOf(_characterId)
    {
        Character storage myCharacter = characters[_characterId];
        require(
            _isReady(myCharacter),
            "You have to wait your 1 day to share your mana"
        );
        require(myCharacter.manaCount >= 1, "You don't have enough mana");
        require(_characterId != _targetId, "You cannot attack yourself");
        Character storage targetCharacter = characters[_targetId];
        myCharacter.winCount.add(1);
        myCharacter.level.add(1);
        myCharacter.manaCount.sub(1);
        targetCharacter.manaCount.add(1);
        _triggerCooldown(myCharacter);
    }
}
