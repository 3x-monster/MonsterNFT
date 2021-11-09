// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


interface IMonster {
    function transferFrom(address from, address to, uint256 tokenId) external;
}


contract Monster2 is ERC721 {

    IMonster constant mm = IMonster(0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE);

    address public owner;
           
    uint public next_monster;

    mapping(uint => string) public monster;
    mapping(uint => string[8]) public monsterAttrs;
    mapping(uint => uint) public myMonster;

    uint total = 2;

    constructor() ERC721("Monster2 Manifested", "M2MS"){
        owner = msg.sender;

        monster[0] = "Aboleth";
        monster[1] = "Aboleth Mage";

        monsterAttrs[0] = ["Huge", "Aberration", "Null", "Underground", "Null", "7", "Lawful", "Evil"];
        monsterAttrs[1] = ["Huge", "Aberration", "Null", "Underground", "Null", "17", "Lawful", "Evil"];
    }

    event monstered(address indexed owner, uint monster);
    
    function mint_monster() private{
        next_monster ++;

        uint rand = uint(keccak256(abi.encodePacked(next_monster, block.timestamp)));
        
        myMonster[next_monster] = rand % total;

        _safeMint(msg.sender, next_monster);
        
        emit monstered(msg.sender, next_monster);
    }

    function claim_by_v1(uint _token_id) public{
        mm.transferFrom(msg.sender, address(this), _token_id);
        mint_monster();
    }

    function tokenURI(uint _token_id) override public view returns (string memory) {
        string[19] memory parts;

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#160C0A" /><text x="10" y="20" class="base">';

        parts[1] = string(abi.encodePacked(monster[myMonster[_token_id]]));

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = string(abi.encodePacked("Size", " ", monsterAttrs[myMonster[_token_id]][0]));

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = string(abi.encodePacked("Type", " ", monsterAttrs[myMonster[_token_id]][1]));

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = string(abi.encodePacked("Climate", " ", monsterAttrs[myMonster[_token_id]][2]));

        parts[8] = '</text><text x="10" y="100" class="base">';

        parts[9] = string(abi.encodePacked("Terrain", " ", monsterAttrs[myMonster[_token_id]][3]));

        parts[10] = '</text><text x="10" y="120" class="base">';

        parts[11] = string(abi.encodePacked("Plane", " ", monsterAttrs[myMonster[_token_id]][4]));

        parts[12] = '</text><text x="10" y="140" class="base">';

        parts[13] = string(abi.encodePacked("CR", " ", monsterAttrs[myMonster[_token_id]][5]));

        parts[14] = '</text><text x="10" y="160" class="base">';

        parts[15] = string(abi.encodePacked("Ethical Alignment", " ", monsterAttrs[myMonster[_token_id]][6]));

        parts[16] = '</text><text x="10" y="180" class="base">';

        parts[17] = string(abi.encodePacked("Moral Alignment", " ", monsterAttrs[myMonster[_token_id]][7]));

        parts[18] = '</text></svg>';

        string memory output = string(abi.encodePacked(
            parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], 
            parts[8], parts[9], parts[10]));
        
        output = string(abi.encodePacked(output, parts[11], parts[12], parts[13], parts[14], 
            parts[15], parts[16], parts[17], parts[18]));

        string memory json = Base64.encode(bytes(string(
            abi.encodePacked('{"name": "Bag #', toString(_token_id), '", "description": "", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
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