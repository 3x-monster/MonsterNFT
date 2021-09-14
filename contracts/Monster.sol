// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Monster is ERC721 {

    address payable public owner;

    mapping(uint => string) public profession;

    string[79] private monsters = [
        "Kidnapper",
        "Axe Gang",
        "Jackstraw",
        "Serpent",
        "Toad",
        "Tarantula",
        "Man-eating Tree",
        "Basilisk",
        "Orc",
        "Corruptor",
        "Radiant Rat",
        "Giant Crocodile",
        "Forest Snowman",
        "Dryad",
        "Giant Elephant",
        "Giant Furbolg",
        "Werewolf",
        "Centaur",
        "Bariour",
        "Fenrir",
        "Vampire Bat",
        "Sand Ghost",
        "Ghoul",
        "Ancient Boulder",
        "Maffia",
        "Lizard Man",
        "Drug Dealer",
        "Tauren",
        "Ape",
        "King Kong",
        "Dwarf Orc",
        "Dwarf",
        "Temple Guard",
        "Temple Warrior",
        "Dullahan",
        "Gargoyle",
        "Skeleton Warrior",
        "Skeleton Summoner",
        "Skeleton Archer",
        "Echinda",
        "Empusae",
        "Gnome",
        "Ordinary Zombie",
        "Vampire Zombie",
        "Captain Zombie",
        "Fox Demon",
        "Night Elf",
        "Ghost",
        "Banshee",
        "Witch",
        "Lich",
        "Tomb Raider",
        "Mummy",
        "Immortal",
        "Vampire",
        "Fafnir",
        "Drake",
        "Dragon",
        "Griffin",
        "Alien Guard",
        "Alien Warrior",
        "Alien Leader",
        "Falcon",
        "Pterosaur",
        "Giant",
        "Medusa",
        "Grendel",
        "Geryon",
        "Pirate",
        "Black Manta",
        "Orm Marius",
        "Alien",
        "Na'vi Warrior",
        "Na'vi Archer",
        "Na'vi Leader",
        "T-800",
        "T-1000",
        "Electronic Squid",
        "Decepticon"
    ];

    uint[79] private professions = [
        1,
        2,
        3,
        4,
        2,
        5,
        2,
        6,
        7,
        8,
        2,
        7,
        4,
        9,
        3,
        4,
        10,
        11,
        12,
        8,
        2,
        13,
        8,
        14,
        1,
        3,
        1,
        7,
        7,
        14,
        10,
        7,
        3,
        7,
        15,
        3,
        7,
        6,
        11,
        13,
        13,
        1,
        3,
        5,
        6,
        5,
        13,
        13,
        5,
        10,
        13,
        1,
        15,
        13,
        8,
        2,
        4,
        14,
        2,
        3,
        7,
        6,
        4,
        12,
        14,
        5,
        8,
        14,
        1,
        7,
        6,
        7,
        7,
        11,
        6,
        7,
        7,
        9,
        7
    ];
        
    string[15] private prefixes = [
        "Angry",
        "Hungry",
        "Scary",
        "Damned",
        "Corrupt",
        "Gloomy",
        "Horrific",
        "Ghostly",
        "Freaky",
        "Amnesic",
        "Painful",
        "Overjoyed",
        "Sorrowful",
        "Blusterous",
        "Degraded"
    ];
    
    uint public next_monster;

    uint constant TOTAL = 30;
    uint constant POINT = 9;

    mapping(uint => string) public monster;
    mapping(uint => string) public prefix;
    mapping(uint => uint) public suffix;

    mapping(uint => uint) public health_Point;
    mapping(uint => uint) public physical_damage_point;
    mapping(uint => uint) public magical_damage_point;
    mapping(uint => uint) public physical_defence;
    mapping(uint => uint) public magical_defence;
    mapping(uint => uint) public dodge;
    mapping(uint => uint) public hit; 
    mapping(uint => uint) public critical;
    mapping(uint => uint) public parry;

    uint[POINT] private basePoints;

    constructor() ERC721("Monster Manifested", "MMS"){
        owner = payable(msg.sender);
        profession[1] = "Robber";
        profession[2] = "Headsman";
        profession[3] = "Guard";
        profession[4] = "Hunter";
        profession[5] = "Wizard";
        profession[6] = "Summoner";
        profession[7] = "Warrior";
        profession[8] = "Demon";
        profession[9] = "Follower";
        profession[10] = "Shaman";
        profession[11] = "Archer";
        profession[12] = "Spear Thrower";
        profession[13] = "Immortal";
        profession[14] = "Titan";
        profession[15] = "Dark Knight";
    }

    event monstered(address indexed owner, uint monster);
    
    function getPrefix(uint _token_id) public view returns (string memory) {
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp, _token_id)));

        return prefixes[rand % prefixes.length];
    }

    function mintMonster() private{
        next_monster ++;
        uint _next_monster = next_monster;

        uint rand = uint(keccak256(abi.encodePacked(_next_monster)));
        
        monster[_next_monster] = monsters[rand % monsters.length];
        suffix[_next_monster] = professions[rand % professions.length];
        prefix[_next_monster] = getPrefix(_next_monster);

        uint[] memory divides = divide(_next_monster);
        uint[] memory divide_points = new uint[](POINT-1);
        uint p;
        for (uint i=0; i<TOTAL; i++){
            if (divides[i] == 1){
                divide_points[p] = i;
                p++;
            }
        }

        get_base_points(professions[rand % professions.length]);

        health_Point[_next_monster] = divide_points[0] + basePoints[0];
        physical_damage_point[_next_monster] = divide_points[1] - divide_points[0] + basePoints[1];
        magical_damage_point[_next_monster] = divide_points[2] - divide_points[1] + basePoints[2];
        physical_defence[_next_monster] = divide_points[3] - divide_points[2] + basePoints[3];
        magical_defence[_next_monster] = divide_points[4] - divide_points[3] + basePoints[4];
        dodge[_next_monster] = divide_points[5] - divide_points[4] + basePoints[5];
        hit[_next_monster] = divide_points[6] - divide_points[5] + basePoints[6]; 
        critical[_next_monster] = divide_points[7] - divide_points[6] + basePoints[7];
        parry[_next_monster] = TOTAL - divide_points[7] + basePoints[8];
 
        _safeMint(msg.sender, _next_monster);
        
        emit monstered(msg.sender, _next_monster);
    }

    function get_base_points(uint _suffix) private {
        if (_suffix == 1){
            basePoints = [8, 10, 5, 6, 4, 10, 10, 5, 2];
        } else if (_suffix == 2){
            basePoints = [9, 7, 4, 6, 6, 5, 10, 10, 3];
        } else if (_suffix == 3){
            basePoints = [12, 5, 5, 10, 10, 3, 4, 3, 8];
        } else if (_suffix == 4){
            basePoints = [8, 9, 9, 7, 7, 8, 5, 5, 2];
        } else if (_suffix == 5){
            basePoints = [6, 3, 12, 4, 8, 10, 10, 5, 2];
        } else if (_suffix == 6){
            basePoints = [6, 5, 10, 8, 8, 7, 3, 5, 8];
        } else if (_suffix == 7){
            basePoints = [10, 12, 2, 12, 4, 2, 7, 7, 4];
        } else if (_suffix == 8){
            basePoints = [12, 8, 7, 12, 5, 9, 2, 2, 3];
        } else if (_suffix == 9){
            basePoints = [8, 9, 7, 7, 9, 5, 5, 5, 5];
        } else if (_suffix == 10){
            basePoints = [10, 5, 5, 12, 12, 5, 6, 3, 2];
        } else if (_suffix == 11){
            basePoints = [6, 12, 3, 3, 2, 12, 12, 8, 2];
        } else if (_suffix == 12){
            basePoints = [6, 12, 3, 4, 5, 8, 8, 8, 6];
        } else if (_suffix == 13){
            basePoints = [7, 5, 8, 5, 5, 12, 8, 6, 4];
        } else if (_suffix == 14){
            basePoints = [15, 5, 5, 8, 8, 2, 7, 2, 8];
        }else if (_suffix == 15){
            basePoints = [8, 9, 5, 10, 6, 5, 4, 8, 5];
        }
    }

    function divide(uint _token_id) public pure returns (uint[] memory){
        uint[] memory divides =  new uint[](TOTAL);

        uint rand;
        uint j;
        for(uint i=0; i<POINT-1; i++){
            uint d;
            while(d == 0  || divides[d] == 1){
                j++;
                rand = uint(keccak256(abi.encodePacked(_token_id, j)));
                d = rand % TOTAL;
            }
            divides[d] = 1;
        }

        return divides;
    }

    function tokenURI(uint _token_id) override public view returns (string memory) {
        string[21] memory parts;

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = string(abi.encodePacked("monster", " ", prefix[_token_id], " ", monster[_token_id], " ", suffix[_token_id]));

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = string(abi.encodePacked("health_Point", " ", health_Point[_token_id]));

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = string(abi.encodePacked("physical_damage_point", " ", physical_damage_point[_token_id]));

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = string(abi.encodePacked("magical_damage_point", " ", magical_damage_point[_token_id]));

        parts[8] = '</text><text x="10" y="100" class="base">';

        parts[9] = string(abi.encodePacked("physical_defence", " ", physical_defence[_token_id]));

        parts[10] = '</text><text x="10" y="120" class="base">';

        parts[11] = string(abi.encodePacked("magical_defence", " ", magical_defence[_token_id]));

        parts[12] = '</text><text x="10" y="140" class="base">';

        parts[13] = string(abi.encodePacked("dodge", " ", dodge[_token_id]));

        parts[14] = '</text><text x="10" y="160" class="base">';

        parts[15] = string(abi.encodePacked("hit", " ", hit[_token_id]));

        parts[16] = '</text><text x="10" y="160" class="base">';

        parts[17] = string(abi.encodePacked("critical", " ", critical[_token_id]));
        
        parts[18] = '</text><text x="10" y="160" class="base">';

        parts[19] = string(abi.encodePacked("parry", " ", parry[_token_id]));

        parts[20] = '</text></svg>';

        string memory output = string(abi.encodePacked(
            parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], 
            parts[8], parts[9], parts[10]));
        
        output = string(abi.encodePacked(output, parts[11], parts[12], parts[13], parts[14], 
            parts[15], parts[16], parts[17], parts[18], parts[19], parts[20]));

        string memory json = Base64.encode(bytes(string(
            abi.encodePacked('{"name": "Bag #', toString(_token_id), '", "description": "Monster NFT is a kind of NFT assets randomized generated and stored on blockchain with different names, prefessions, basic attribute value and random attribute value, which can be used in any scene. The rarity of monster NFT is determined by its peofession, arrtribute value and game ecology. Level, scene and image is ommitted as part of further expansions.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function claim() public payable{
        require(msg.value == 0.001e18, "10FTM IS REQUIRED");
        require(next_monster >= 0 && next_monster < 10000, "Token ID invalid");
        mintMonster();
    }
    
    function ownerClaim() public {
        require(msg.sender == owner, "Only Owner");
        require(next_monster >= 10000 && next_monster < 11000, "Token ID invalid");
        mintMonster();
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function withdraw() public {
        require(msg.sender == owner, "Only Owner");

        uint amount = address(this).balance;

        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}