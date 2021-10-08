// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


interface IRarity {
    function level(uint) external view returns (uint);
    function getApproved(uint) external view returns (address);
    function ownerOf(uint) external view returns (address);
    function class(uint) external view returns (uint);
}

struct ability_score {
    uint32 strength;
    uint32 dexterity;
    uint32 constitution;
    uint32 intelligence;
    uint32 wisdom;
    uint32 charisma;
}

interface IRarityAttributes{
    function ability_scores(uint) external view returns (ability_score calldata);    
}

interface IMonster {
    function next_monster() external view returns (uint);
    function ownerOf(uint) external view returns (address);
    function health_Point(uint) external view returns (uint);
    function physical_damage_point(uint) external view returns (uint);
    function physical_defence(uint) external view returns (uint);
    function dodge(uint) external view returns (uint);
    function hit(uint) external view returns (uint);
}

interface ICopperBox{
    function mint_to_summoner(uint, uint) external;
    function mint_to_monster(uint, uint) external; 
}

contract MonkFirstAdventure {
    
    IRarity constant rm = IRarity(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);
    IMonster constant mm = IMonster(0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE);
    IRarityAttributes constant ra = IRarityAttributes(0xB5F5AF1087A8DA62A23b08C00C6ec9af21F397a1);
    ICopperBox constant cb = ICopperBox(0x253e55363F9440B532D13C228CB633Bac94F3b7C);

    mapping(uint => uint) public baseAttackBonus;
    mapping(uint => uint) public unarmedDamage;

    mapping(uint => mapping(uint=>AdventureLog[])) public processes;

    mapping(uint => uint) public adventureCount;
    mapping(uint => uint) public winsCount;

    mapping(uint => uint) public rewards;
    mapping(uint =>  mapping(uint=>uint)) public result;

    struct AdventureLog{
        uint round; 
        uint8 offence; 
        uint8 defence;
        int damage;
        int HP;
        uint8 isAttacked;
    }

    // level range 2-7
    constructor () {
        baseAttackBonus[2] = 1;
        baseAttackBonus[3] = 2;
        baseAttackBonus[4] = 3;
        baseAttackBonus[5] = 3;
        baseAttackBonus[6] = 4;
        baseAttackBonus[7] = 5;

        unarmedDamage[2] = 6;
        unarmedDamage[3] = 6;
        unarmedDamage[4] = 8;
        unarmedDamage[5] = 8;
        unarmedDamage[6] = 8;
        unarmedDamage[7] = 8;

        rewards[2] = 10e18;
        rewards[3] = 10e18;
        rewards[4] = 10e18;
        rewards[5] = 12e18;
        rewards[6] = 12e18;
        rewards[7] = 14e18;
    }

    // 10:0 
    function ability_modifier(uint _score) public pure returns(int _m){
        if(_score >= 10){
            _m = int((_score-10)/2);
        }else{
            _m = -int((11-_score)/2);
        }
    }

    // roll a d20, d6 ...
    function roll(uint _a, uint _b, uint _dx) public view returns (uint){
        return uint(keccak256(abi.encodePacked(block.timestamp, _a, _b)))%_dx + 1;
    }

    // Monk d8
    // Adds Constitution bonus
    function hit_die(uint _summoner) public view returns(int){
        return int(roll(0, 0, 8)) + ability_modifier(ra.ability_scores(_summoner).constitution);
    }

    //d6
    function hit_die_of_monster(uint _monster) public view returns(int){
        // return int(roll(1, 0, 6)) + ability_modifier(mm.health_Point(_monster));
        return int(mm.health_Point(_monster));
    }

    //roll for initiative
    function initiative_check(uint _summoner, uint _monster) public view returns(uint8 _order){
        int summonerCheck = int(roll(2, 0, 20)) + ability_modifier(ra.ability_scores(_summoner).dexterity);
        int monsterCheck = int(roll(3, 0, 20)) + ability_modifier(mm.dodge(_monster));

        if (summonerCheck >= monsterCheck){
            _order = 0;
        } else{
            _order = 1;
        }
    }

    // attack roll
    // Monk, d20 + Base Attack Bonus + strength bonus
    function attack(uint _round, uint _summoner, uint _monster) public view returns(int _summonerAttack, int _monsterAttack){
        _summonerAttack = int(roll(4, _round, 20)) + int(baseAttackBonus[rm.level(_summoner)]) + ability_modifier(ra.ability_scores(_summoner).strength);
        _monsterAttack = int(roll(5, _round, 20)) + ability_modifier(mm.hit(_monster));
    }

    // gains 1 bonus at 5th level, increases by 1 for every 5 levels
    // Adds wisdom bonus when unarmed
    // Adds Dexterity bonus
    function ac(uint _summoner, uint _monster) public view returns(int _summonerAC, int _monsterAC){
        _summonerAC = 10 + int(rm.level(_summoner)/5) + ability_modifier(ra.ability_scores(_summoner).wisdom) + ability_modifier(ra.ability_scores(_summoner).dexterity);
        _monsterAC = 10 + ability_modifier(mm.physical_defence(_monster));
    }

    // Adds strength bonus
    // Minum 1 point of damage
    function damage(uint _round, uint _summoner, uint _monster) public view returns(int _summonerDamage, int _monsterDamage){
        _summonerDamage = int(roll(6, _round, unarmedDamage[rm.level(_summoner)])) + ability_modifier(ra.ability_scores(_summoner).strength);
        if (_summonerDamage < 1){
            _summonerDamage = 1;
        }
        _monsterDamage = int(roll(7, _round, 6)) + ability_modifier(mm.physical_damage_point(_monster));
        if (_monsterDamage < 1){
            _monsterDamage = 1;
        }
    }

    function cal(int _attack, int _ac, int _hp, int _damage) internal pure returns(int, uint8){
        uint8 isAttacked = 0;
        if (_attack >= _ac){
            _hp -= _damage;
            isAttacked = 1;
        }
        return (_hp, isAttacked);
    }

    function fight(uint _summoner, uint _monster, uint8 _order, uint _count) internal returns(int summonerHP, int monsterHP){
        summonerHP = hit_die(_summoner);
        monsterHP = hit_die_of_monster(_monster);
        int summonerDamage; int monsterDamage;
        int summonerAttack; int monsterAttack; 
        uint round = 0;
        uint8 isAttacked;
        int summonerAC; int monsterAC;
        (summonerAC, monsterAC) = ac(_summoner, _monster);

        // round, offence, defence, damage, HP, isAttacked
        while (summonerHP > 0 && monsterHP > 0){
            round += 1;
            (summonerAttack, monsterAttack) = attack(round, _summoner, _monster);
            (summonerDamage, monsterDamage) = damage(round, _summoner, _monster);
            if (_order == 0){
                (monsterHP, isAttacked) = cal(summonerAttack, monsterAC, monsterHP, summonerDamage);
                processes[_summoner][_count].push(AdventureLog(round, 0, 1, summonerDamage, monsterHP, isAttacked));
                if (monsterHP <= 0) {
                    break;
                }

                (summonerHP, isAttacked) = cal(monsterAttack, summonerAC, summonerHP, monsterDamage);
                processes[_summoner][_count].push(AdventureLog(round, 1, 0, monsterDamage, summonerHP, isAttacked));
                if (summonerHP <= 0){
                    break;
                }
            } else {
                (summonerHP, isAttacked) = cal(monsterAttack, summonerAC, summonerHP, monsterDamage);
                processes[_summoner][_count].push(AdventureLog(round, 1, 0, monsterDamage, summonerHP, isAttacked));
                if (summonerHP <= 0){
                    break;
                }

                (monsterHP, isAttacked) = cal(summonerAttack, monsterAC, monsterHP, summonerDamage);
                processes[_summoner][_count].push(AdventureLog(round, 0, 1, summonerDamage, monsterHP, isAttacked));
                if (monsterHP <= 0) {
                    break;
                }
            }
        }
        
    }

    function adventure(uint _summoner) external returns(uint, uint){
        require(_isApprovedOrOwner(_summoner), "Only approved or owner");
        require(rm.class(_summoner) == 6, "Only Monk");
        require(rm.level(_summoner) >= 2 && rm.level(_summoner) <= 7, "Requires greater than or equal to 2 and less than or equal to 7");

        uint count = adventureCount[_summoner] + 1; 
        adventureCount[_summoner] = count;

        uint _monster = uint(keccak256(abi.encodePacked(block.timestamp))) % mm.next_monster() + 1;

        uint8 order = initiative_check(_summoner, _monster);

        int summonerHP; int monsterHP;

        (summonerHP, monsterHP) = fight(_summoner, _monster, order, count);

        result[_summoner][count] = 0;
        if (monsterHP <= 0){
            winsCount[_summoner] += 1;
            cb.mint_to_summoner(_summoner, rewards[rm.level(_summoner)]);
            result[_summoner][count] = rewards[rm.level(_summoner)];
        } else {
            cb.mint_to_monster(_monster, rewards[rm.level(_summoner)]);
        }

        return (count, processes[_summoner][count].length);
    }

    function _isApprovedOrOwner(uint _summoner) internal view returns (bool) {
        return rm.getApproved(_summoner) == msg.sender || rm.ownerOf(_summoner) == msg.sender;
    }
    
}