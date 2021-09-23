// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface rarity {
    function adventure(uint _summoner) external;

    function level_up(uint _summoner) external;

    function xp(uint _summoner) external pure returns (uint);

    function level(uint _summoner) external pure returns (uint);

    function xp_required(uint curent_level) external pure returns (uint);
    
    function ownerOf(uint) external view returns (address);

    function approve(address, uint) external;
    
    function getApproved(uint) external view returns (address);
    
    function isApprovedForAll(address owner, address operator) external pure returns (bool) ;

}

interface rarity_gold {
    function claim(uint summoner) external;
    
    function claimed(uint summoner) external pure returns (uint);
}

contract RarityBatch {
    rarity constant rm = rarity(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);
    rarity_gold constant rg = rarity_gold(0x2069B76Afe6b734Fb65D1d099E7ec64ee9CC76B2);

    function batch_adventure(uint[] calldata _summoners) external{
        for (uint i = 0; i < _summoners.length; i++) {
            rm.adventure(_summoners[i]);
        }
    }

    function batch_level_up(uint[] calldata _summoners) external {
        for (uint i = 0; i < _summoners.length; i++) {
            if(rm.xp(_summoners[i]) >= rm.xp_required(rm.level(_summoners[i]))){
                rm.level_up(_summoners[i]);
            }
        }
    }
    
    function batch_claim_gold(uint[] calldata _summoners) external {
        for (uint i = 0; i < _summoners.length; i++) {
            if(rm.level(_summoners[i]) >= 2 && rm.level(_summoners[i]) > rg.claimed(_summoners[i])){
                rg.claim(_summoners[i]);
            }
        }
    }
    
    function approve_all(uint[] calldata _summoners) external {
        for (uint i = 0; i < _summoners.length; i++) {
            rm.approve(address(this), _summoners[i]);
        }
    }

    function is_approved(uint[] calldata _summoners) external view returns (bool[] memory _is_approved) {
        _is_approved = new bool[](_summoners.length);
        
        for (uint i = 0; i < _summoners.length; i++) {
            _is_approved[i] = rm.getApproved(_summoners[i]) == address(this);
        }
    }

    function is_approved(uint _summoner) external view returns (bool) {
        return (rm.getApproved(_summoner) == address(this));
    }
    
    function is_approved_for_all(uint _summoner) external view returns (bool) {
        return rm.isApprovedForAll(rm.ownerOf(_summoner), address(this));
    }
}