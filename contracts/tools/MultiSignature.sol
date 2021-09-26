// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract MultiSignature {
    address constant public a = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address constant public b = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    address constant public c = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    struct Proposal {
        string symbol;
        string description;
        address operator;
        bool arg;
        uint8 approved; 
        uint8 disapproved;
    }

    Proposal[] public proposals;

    mapping (uint=> mapping (address => bool)) public isVoted;

    modifier only_admin() {
        require(msg.sender == a || msg.sender == b || msg.sender == c, "Not admin");
        _;
    }

    modifier not_voted(uint _index) {
        require(!isVoted[_index][msg.sender], "Had voted");
        _;
    }

    function get_proposals_length() external view returns (uint) {
        return proposals.length;
    }

    function create(string memory _symbol, string memory _desc, address _operator, bool _arg) external only_admin{
        proposals.push(Proposal(_symbol, _desc, _operator, _arg, 0, 0));
    }

    function vote(uint _index, bool _isApproved) external only_admin not_voted(_index){
        if(_isApproved){
            proposals[_index].approved += 1;
        } else {
            proposals[_index].disapproved += 1;
        }

        isVoted[_index][msg.sender] = true;
    }

    function is_apporved(uint _index) view external returns(string memory _symbol, uint _approved, address _operator, bool _arg){
        Proposal memory prp = proposals[_index];
        _symbol = prp.symbol;
        _approved = prp.approved;
        _operator = prp.operator;
        _arg = prp.arg;
    }

}