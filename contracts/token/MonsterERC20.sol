// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IMultiSignature {
    function is_apporved(uint) external view returns (string memory, uint, address, bool);
}

contract MonsterERC20 is ERC20 {
    uint256 public constant Limitation = 100_000_000e18;

    string public constant name = "Monster";
    string public constant symbol = "MST";

    IMultiSignature constant ms = IMultiSignature(0x7B4b69B489c2b1000a61c3bfa9934194eCE68159);

    mapping(address => bool) public isApproved;
    mapping(uint => bool) public hasBeenProcessed;

    constructor() ERC20(name, symbol){
        owner = msg.sender;
    }

    modifier is_approved() {
        require(isApproved[msg.sender], "Not approved");
        _;
    }

    function mint(address _to, uint256 _value) public is_approved{
        require(_totalSupply + _value <= Limitation, "Total supply overflow the limitation");

        _mint(_to, _value);
    }

    function burn(address _account, uint256 _amount) public is_approved{

        _burn(_account, _amount);
    }
 
    function whitelist(uint _proposal_index) external {
        string memory _symbol;
        uint approved = 0;
        address operator = address(0);
        bool arg = false;
        
        (_symbol, approved, operator, arg) = ms.is_apporved(_proposal_index);
        
        require(!hasBeenProcessed[_proposal_index], "Proposal has been processed");
        require(keccak256(abi.encodePacked(_symbol)) == keccak256(abi.encodePacked(symbol)));
        require(approved >= 2, "Approved less than 2");

        isApproved[operator] = arg;
        hasBeenProcessed[_proposal_index] = true;

        emit Whitelist(_symbol, _proposal_index, operator, arg);
    }
}