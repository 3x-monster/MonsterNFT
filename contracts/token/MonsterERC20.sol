// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IMultiSignature {
    function is_apporved(uint) external view returns (string memory, uint, address, bool);
}

interface IMonsterERC20 {
    function mint(address to, uint256 amount) external returns (bool);

    function burn(address account, uint256 amount) external returns (bool);

    function whitelist(uint proposalIndex) external;

    event IntoWhitelist(string symbol, uint index, address operator, bool arg);
}

contract MonsterERC20 is ERC20, IMonsterERC20 {
    uint256 public constant Limitation = 100_000_000e18;

    IMultiSignature immutable ms;

    mapping(address => bool) public isApproved;
    mapping(uint => bool) public hasBeenProcessed;

    constructor(string memory name_, string memory symbol_, address multiSig_) ERC20(name_, symbol_){
        ms = IMultiSignature(multiSig_);
    }

    modifier is_approved() {
        require(isApproved[msg.sender], "Not approved");
        _;
    }

    function mint(address to, uint256 amount) external is_approved override returns (bool) {
        require(totalSupply() + amount <= Limitation, "Total supply overflow the limitation");

        _mint(to, amount);
        return true;
    }

    function burn(address account, uint256 amount) external is_approved override returns (bool) {
        _burn(account, amount);

        return true;
    }
 
    function whitelist(uint proposalIndex) external override {
        string memory applySymbol;
        uint approved = 0;
        address operator = address(0);
        bool arg = false;
        
        (applySymbol, approved, operator, arg) = ms.is_apporved(proposalIndex);
        
        require(!hasBeenProcessed[proposalIndex], "Proposal has been processed");
        require(keccak256(abi.encodePacked(applySymbol)) == keccak256(abi.encodePacked(symbol())));
        require(approved >= 2, "Approved less than 2");

        isApproved[operator] = arg;
        hasBeenProcessed[proposalIndex] = true;

        emit IntoWhitelist(symbol(), proposalIndex, operator, arg);
    }
}