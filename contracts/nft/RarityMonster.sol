// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// deprecated
contract rarityMonster is ERC721 {
    uint public next_monster;

    address public owner;
    
    string[] public classes;
    mapping(uint => uint) public classMinLevel;
    mapping(uint => uint) public class;
    mapping(uint => uint) public level;
    
    event monstered(address indexed owner, uint class, uint level, uint monster);

    constructor() ERC721("Rarity Monster Manifested", "RMM"){
        owner = msg.sender;
        classes = ["monster"];
        classMinLevel[1] = 2;
    }

    function mint_monster(uint _class, uint _level) external {
        require(msg.sender == owner, "Only Owner");
        require(1 <= _class && _class <= classes.length, "Class Not Exist");
        require(_level >= classMinLevel[_class], "Too low-level");
        
        uint _next_monster = next_monster;
        
        class[_next_monster] = _class;
        level[_next_monster] = _level;
        
        _safeMint(msg.sender, _next_monster);
        
        emit monstered(msg.sender, _class, _level, _next_monster);
        
        next_monster++;
    }
    
    function add_classes(string memory _description, uint _level) external {
        require(msg.sender == owner, "Only Owner");
        require(_level >= 1);
        
        classes.push(_description);
        classMinLevel[classes.length] = _level;
    }
    
    function get_classes() public view returns(string[] memory){
        return classes;
    }

    function classes_description(uint id) public view returns (string memory description) {
        description = classes[id-1];
    }
}