// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


// Only for easily test
contract CopperBoxTest {
    string public constant name = "Copper Box";
    string public constant symbol = "copper";
    uint8 public constant decimals = 18;

    uint public totalSupply = 0;
    uint public totalSupplyOfSummoner = 0;
    uint public totalSupplyOfMonster = 0;

    mapping(address => uint) public totalSupplyOfOperator;
    mapping(address => uint) public totalSupplyOfOperatorOfSummoner;
    mapping(address => uint) public totalSupplyOfOperatorOfMonster;
    
    // IMultiSignature constant ms = IMultiSignature(0x7B4b69B489c2b1000a61c3bfa9934194eCE68159);

    mapping(uint => uint) public balanceOfSummoner;
    mapping(uint => uint) public balanceOfMonster;

    mapping(address => bool) public isApproved;
    
    event Transfer(string subject, uint indexed from, uint indexed to, uint amount);
    event Whitelist(string symbol, uint index, address operator, bool arg);

    modifier is_approved() {
        require(isApproved[msg.sender], "Not approved");
        _;
    }

    function mint_to_summoner(uint _summnoer, uint _amount) external is_approved{
        totalSupply += _amount;
        totalSupplyOfSummoner += _amount;
        totalSupplyOfOperator[msg.sender] += _amount;
        totalSupplyOfOperatorOfSummoner[msg.sender] += _amount;

        balanceOfSummoner[_summnoer] += _amount;

        emit Transfer("Summoner", _summnoer, _summnoer, _amount);
    }

    function mint_to_monster(uint _monster, uint _amount) external is_approved{
        totalSupply += _amount;
        totalSupplyOfMonster += _amount;
        totalSupplyOfOperator[msg.sender] += _amount;
        totalSupplyOfOperatorOfMonster[msg.sender] += _amount;

        balanceOfMonster[_monster] += _amount;

        emit Transfer("Monster", _monster, _monster, _amount);
    }

    function transfer_to_summoner(uint _from, uint _to, uint _amount) external is_approved{
        balanceOfSummoner[_from] -= _amount;
        balanceOfSummoner[_to] += _amount;

        emit Transfer("Summoner", _from, _to, _amount);
    }

    function transfer_to_monster(uint _from, uint _to, uint _amount) external is_approved{
        balanceOfMonster[_from] -= _amount;
        balanceOfMonster[_to] += _amount;

        emit Transfer("Monster", _from, _to, _amount);
    }

    function whitelist(address _approved) external {
        address operator = _approved;
        
        isApproved[operator] = true;
    }

}