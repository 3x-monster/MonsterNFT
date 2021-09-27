// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract MultiSignature {
    // z
    address constant public a = 0x2E62C9F8D794337728ddEfB8fD9b7457A8cde090; 
    // K
    address constant public b = 0x4f18a84affe7d03E6824A076f3c02F726bE16866;
    // H
    address constant public c = 0x9D944Ba1541903e6D7E2e8720620Fc20F3df990c;

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

    event Voted(address sender, uint index, bool isApproved);

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

        emit Voted(msg.sender, _index, _isApproved);
    }

    function is_apporved(uint _index) view external returns(string memory _symbol, uint _approved, address _operator, bool _arg){
        Proposal memory prp = proposals[_index];
        _symbol = prp.symbol;
        _approved = prp.approved;
        _operator = prp.operator;
        _arg = prp.arg;
    }

}