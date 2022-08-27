// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

//* Contract deployed at: 0xcC7C32a60fCe1d4EAC1BC124a45b9B6105cEE06C

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 randNonce = 0;

    struct Warrior {
        uint256 Level;
        uint256 Speed;
        uint256 Strength;
        uint256 Life;
    }

    //* A map that links the NFT id to his respective warrior info
    mapping(uint256 => Warrior) public tokenIdToWarrior;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId) public returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<defs>",
            '<linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="0%">',
            '<stop offset="0%" style="stop-color:cyan;stop-opacity:1"/>',
            '<stop offset="100%" style="stop-color:green;stop-opacity:1"/>',
            "</linearGradient>",
            "</defs>",
            "<style>.base { font-family: verdana; font-size: 16px; font-weight: bold; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "NFT Warrior",
            "</text>",
            '<text x="50%" y="35%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "Level: ",
            getLevel(tokenId),
            "</text>",
            '<text x="50%" y="45%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "Speed: ",
            getSpeed(tokenId),
            "</text>",
            '<text x="50%" y="55%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "Strength: ",
            getStrength(tokenId),
            "</text>",
            '<text x="50%" y="65%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "Life: ",
            getLife(tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        Warrior memory warriorInfo = tokenIdToWarrior[tokenId];
        return warriorInfo.Level.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        Warrior memory warriorInfo = tokenIdToWarrior[tokenId];
        return warriorInfo.Speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        Warrior memory warriorInfo = tokenIdToWarrior[tokenId];
        return warriorInfo.Strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        Warrior memory warriorInfo = tokenIdToWarrior[tokenId];
        return warriorInfo.Life.toString();
    }

    function getTokenURI(uint256 tokenId) public returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);

        /*  uint256 _randLevel = getRandom(newItemId);
        uint256 _randSpeed = getRandom(_randLevel);
        uint256 _randStrength = getRandom(_randSpeed);
        uint256 _randLife = getRandom(_randStrength); */

        uint256 _randLevel = 1;
        uint256 _randSpeed = 2;
        uint256 _randStrength = 3;
        uint256 _randLife = 4;

        Warrior memory warrior = Warrior(
            _randLevel,
            _randSpeed,
            _randStrength,
            _randLife
        );
        tokenIdToWarrior[newItemId] = warrior;

        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );
        Warrior memory warrior = tokenIdToWarrior[tokenId];
        uint256 currentLevel = warrior.Level;
        warrior.Level = currentLevel + 1;
        tokenIdToWarrior[tokenId] = warrior;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    /*     function getRandom(uint _modulus) private returns (uint) {
        randNonce++;
        uint rand = uint(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))
        ) % _modulus;
        return rand;
    } */
}
