# README中文版

**致敬 Rarity 和 Loot**

## **合约地址**

| Name | Address |
| :--- | :--- |
| Rarity Contract | [0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb](https://ftmscan.com/address/0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb) |
| Rarity Battle Contract | [0x42b18313fc4b4b93916a2a454f0f0b7c8fde27c7](https://ftmscan.com/address/0x42b18313fc4b4b93916a2a454f0f0b7c8fde27c7) |
| Monster Contract | [0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE](https://ftmscan.com/address/0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE) |

## \(Rarity Battle Contract\) 指南

打开合约地址：[https://ftmscan.com/address/0x42b18313fc4b4b93916a2a454f0f0b7c8fde27c7](https://ftmscan.com/address/0x42b18313fc4b4b93916a2a454f0f0b7c8fde27c7)

### 前置条件：

确保输入的Rarity英雄ID属于您的账户

* 场景一：消灭指定的怪物
  * 玩法1：指定怪物、指定等级

    调用Battle函数，输入Rarity Token ID，Monster Token ID和怪物的等级，进行PK

  * 玩法2：指定怪物，不指定等级

    调用Battle函数，输入Rarity Token ID，Monster Token ID，怪物等级输入0，进行PK
* 场景二：遭遇战
  * 玩法1：不指定怪物、指定等级

    调用Battle函数，输入Rarity Token ID，Monster Token ID输入0，输入怪物的等级，进行PK

  * 玩法2：不指定怪物，不指定等级

    调用Battle函数，输入Rarity Token ID，Monster Token ID和怪物的等级输入0，进行PK

#### 注：

1. Monster Token ID为0时，系统随机指定怪物
2. 怪物等级为0时，系统指定的怪物等级与英雄等级同级
3. 战胜怪物赢得copper的数量与怪物等级相关，等级越高，掉落越多
4. 胜率由等级差决定，英雄等级比怪物越高，胜率越高

* 胜率公式： 当英雄等级大于怪物等级时，假设x是等级差，y是胜率， y = \(x^2+4\)/\(x^2+5\) 当怪物等级大于英雄等级时，假设x是等级差，y是胜率， y = 1/\(x^2+2\)

## \(Monster Contract\) 指南

## 简述

```text
    Monster NFT is a kind of NFT assets randomized generated and stored on blockchain with different names, prefessions, basic attribute value and random attribute value, which can be used in any scene. The rarity of monster NFT is determined by its peofession, arrtribute value and game ecology. Level, scene and image is ommitted as part of further expansions.
```

### 召唤

* Step1. 进入合约：[https://ftmscan.com/](https://ftmscan.com/)[0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE](https://ftmscan.com/address/0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE)
* Step2. 用Claim函数支付10ftm召唤怪兽

### NFT介绍

#### 数量与分配

MonsterNFT总量11000个，1～10000由社区用户随机获得，10001～11000属于开发团队。

#### 职业和基础属性值

每个Monster的属性值由60点的基础属性值和30点的随机属性值构成。基础属性值如下：

[快速查看](https://github.com/crypto-shuraba/MonsterNFT/blob/56312831be1ccf922dde49fddcb0c283b752589e/README%2045600350dd3a4a71aaddb5cc7b5d87f7/Instantly%20View%20542f0c2db21a4273bd49d2ff81a40d13.csv)

#### 怪物字典

共有79种怪物，15类职业，每类职业都有相应的编号。如下：

[快速查看](https://github.com/crypto-shuraba/MonsterNFT/blob/56312831be1ccf922dde49fddcb0c283b752589e/README%2045600350dd3a4a71aaddb5cc7b5d87f7/Instantly%20View%20d694f54fdd854b21a9556976ca5be3c0.csv)

#### 怪物前缀

我们为怪物设计了一些有意思的形容词，随机组合。如下：

Angry, Hungry, Scary, Damned, Corrupt, Gloomy, Horrific, Ghostly, Freaky, Amnesic, Painful, Overjoyed, Sorrowful, Blusterous, Degraded

## 未来展望

在一个完整的元宇宙生态里，不仅有英雄，还需要有怪物。欢迎社区开发者调用它，一起创造出各种好玩的游戏场景。请有兴趣的开发者、美术设计、游戏策划联系我们，共同创建元宇宙生态。加油～

**联系我们**

Gmail: [cryptoshuraba@gmail.com](mailto:cryptoshuraba@gmail.com)

Twitter: [https://twitter.com/Crypto\_Shuraba](https://twitter.com/Crypto_Shuraba)

**友情链接**

Rarity: [https://github.com/andrecronje/rarity](https://github.com/andrecronje/rarity)

Loot: [https://www.lootproject.com/](https://www.lootproject.com/)



