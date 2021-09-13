// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface rarity {
    function level(uint) external view returns (uint);
    function getApproved(uint) external view returns (address);
    function ownerOf(uint) external view returns (address);
}

interface monster {
    function level(uint) external view returns (uint);
    function ownerOf(uint) external view returns (address);
}

contract rarityBattle {
    string public constant name = "Rarity Battle";
    string public constant symbol = "copper";
    uint8 public constant decimals = 18;

    uint public totalSupply = 0;

    uint public battleCount = 0;
    
    rarity constant rm = rarity(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);
    monster constant mm = monster(0xDFc9Aaf6C56975a3a498051461A6734af5cbc3CC);

    mapping(uint => uint) public balanceOf;

    event Transfer(uint indexed from, uint indexed to, uint amount);
    event Battle(uint indexed summoner, uint indexed monster, bool isWin, uint copperAmount);

    function battle(uint _summoner, uint _monster) external returns(bool){
        require(_isApprovedOrOwner(_summoner));
        mm.ownerOf(_monster);

        uint summonerLevel = rm.level(_summoner);
        uint monsterLevel = mm.level(_monster);

        battleCount++;
        if (isWin(summonerLevel, monsterLevel)){
            uint copperAmount = 2**monsterLevel*10e18;
            _mint(_summoner, copperAmount);
            emit Battle(_summoner, _monster, true, copperAmount);
            return true;
        }
        
        emit Battle(_summoner, _monster, false, 0);
        return false;
    } 

    function isWin(uint _summonerLevel, uint _monsterLevel) public view returns(bool){
        uint levelDiffer;
        uint modulus;

        if (_summonerLevel < _monsterLevel) {
            levelDiffer = _monsterLevel-_summonerLevel;
            modulus = levelDiffer*levelDiffer + 2;
            if (uint(keccak256(abi.encodePacked(block.timestamp, battleCount))) % modulus == 1){
                return true;
            }
        }else{
             levelDiffer = _summonerLevel-_monsterLevel;
             modulus = levelDiffer*levelDiffer + 5;
             if (uint(keccak256(abi.encodePacked(block.timestamp, battleCount))) % modulus != 1){
                return true;
            }
        }

        return false;
    }

    function _isApprovedOrOwner(uint _summoner) internal view returns (bool) {
        return rm.getApproved(_summoner) == msg.sender || rm.ownerOf(_summoner) == msg.sender;
    }
    
    function _mint(uint dst, uint amount) internal {
        totalSupply += amount;
        balanceOf[dst] += amount;
        emit Transfer(dst, dst, amount);
    }


    function transfer(uint from, uint to, uint amount) external returns (bool) {
        require(_isApprovedOrOwner(from));
        _transferTokens(from, to, amount);
        return true;
    }

    function _transferTokens(uint from, uint to, uint amount) internal {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
    }
}