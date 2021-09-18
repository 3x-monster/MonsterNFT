# README 中文版

**首先向 Rarity 和 Loot 致敬**

# Addresses

| Name                   | Address                                                                                                              |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Rarity Contract        | [0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb](https://ftmscan.com/address/0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb) |
| Rarity Battle Contract | [0x42b18313fc4b4b93916a2a454f0f0b7c8fde27c7](https://ftmscan.com/address/0x42b18313fc4b4b93916a2a454f0f0b7c8fde27c7) |
| Monster Contract       | [0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE](https://ftmscan.com/address/0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE) |

<br />

# Front End

[monsternft.vercel.app](https://monsternft.vercel.app)

[monsternft-mint-list.pages.dev](https://monsternft-mint-list.pages.dev/)

<br />

# (Rarity Battle Contract) PVE: 指南

## 打开合约地址：

[https://ftmscan.com/address/0x42b18313fc4b4b93916a2a454f0f0b7c8fde27c7](https://ftmscan.com/address/0x42b18313fc4b4b93916a2a454f0f0b7c8fde27c7#writeContract)

## 前置条件：

- 确保输入的 Rarity 英雄 ID 属于您的账户

![Untitled](https://github.com/crypto-shuraba/MonsterNFT/blob/main/README/guide.png)

- 场景一：消灭指定的怪物

  - 玩法 1：指定怪物、指定等级

    调用 Battle 函数，输入 Rarity Token ID，Monster Token ID 和怪物的等级，进行 PK

  - 玩法 2：指定怪物，不指定等级

    调用 Battle 函数，输入 Rarity Token ID，Monster Token ID，怪物等级输入 0，进行 PK

- 场景二：遭遇战

  - 玩法 1：不指定怪物、指定等级

    调用 Battle 函数，输入 Rarity Token ID，Monster Token ID 输入 0，输入怪物的等级，进行 PK

  - 玩法 2：不指定怪物，不指定等级

    调用 Battle 函数，输入 Rarity Token ID，Monster Token ID 和怪物的等级输入 0，进行 PK

## 注：

1. Monster Token ID 为 0 时，系统随机指定怪物

2. 怪物等级为 0 时，系统指定的怪物等级与英雄等级同级

3. 战胜怪物赢得 copper 的数量与怪物等级相关，等级越高，掉落越多

4. 胜率由等级差决定，英雄等级比怪物越高，胜率越高

## 胜率公式：

- 当英雄等级大于怪物等级时，假设 x 是等级差，y 是胜率，
  y = (x^2+4)/(x^2+5)

- 当怪物等级大于英雄等级时，假设 x 是等级差，y 是胜率，
  y = 1/(x^2+2)

# (Monster Contract) MonsterNFT 指南

## 简述

MonsterNFT 是一种随机产生并储存在区块链上的 NFT 资产，有不同的名称、职业、基础属性值和随机属性值。您可以把它应用在任何场景中。它的稀有度是通过职业、属性和游戏生态共同决定的。等级、场景和形象将作为进一步扩展的部分。

## 召唤

- Step1.进入合约：[https://ftmscan.com/address/0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE](https://ftmscan.com/address/0x2D2f7462197d4cfEB6491e254a16D3fb2d2030EE)

- Step2.用 Claim 函数支付**10ftm**召唤怪兽

## NFT 介绍

### 数量与分配

MonsterNFT 总量 11000 个，1 ～ 10000 由社区用户随机获得，10001 ～ 11000 属于开发团队。

### 职业和基础属性值

每个 Monster 的属性值由 60 点的基础属性值和 30 点的随机属性值构成。基础属性值如下：

[立即查看](https://github.com/crypto-shuraba/MonsterNFT/blob/main/README/Instantly1.csv)

### 怪物字典

共有 79 种怪物，15 类职业，每类职业都有相应的编号。如下：

[立即查看](https://github.com/crypto-shuraba/MonsterNFT/blob/main/README/Instantly2.csv)

### 怪物前缀

我们为怪物设计了一些有意思的形容词，随机组合。如下：

Angry,Hungry,Scary,Damned,Corrupt,Gloomy,Horrific,Ghostly,Freaky,Amnesic,Painful,Overjoyed,Sorrowful,Blusterous,Degraded

# 未来展望

在一个完整的元宇宙生态里，不仅有英雄，还需要有怪物。欢迎社区开发者调用它，一起创造出各种好玩的游戏场景。请有兴趣的开发者、美术设计、游戏策划联系我们，共同创建元宇宙生态。加油～

## 社区 & 奖励

- 我们将持续开展社区活动并奖励为 Rarity 和 MonsterNFT 提供好的点子和创造性贡献的社区成员。
- 欢迎提交合约扩展和前端页面。
- 欢迎志同道合的朋友联系我们.

## FQA

Q: 你们要做什么？
A：初期，我们为Rarity开发了PVE模式的Battle合约，发现没有怪物，于是设计了MonsterNFT。然后又发现，第一版对战逻辑不适用了，又重新开发了Battle合约。当踩完很多坑之后，终于明确了发展方向：我们要为Rarity社区做完整游戏，包括不限于：开发更好用的前端，更精彩的对战场景以及怪物NFT。

Q: 为什么我需要支付10个 FTM 才能获得一个 MonsterNFT ？
A: 如果仅需要支付 gas fee 就可以获得 MonsterNFT，我们担忧NFT会过度集中。是为了防止滥刷，而设置了条件。最终，FTM 会奖励给社区成员。比如，开发者、创造贡献的人。

Q: 持有MonsterNFT对我有什么好处？
A: 在游戏角度分析，Monster是PVE的重要组成部分。在元宇宙游戏里不仅有Rarity英雄人物，还需要反面人物。在DeFi角度分析，MonsterNFT可以被任何Battle合约调用，随着调用次数的增加，持有它就是持有一份资产。它可能会给你带来源源不断的现金流。

Q: PVE能获得什么？
A: 我们开发的PVE模式，是利用Battle合约调用 RarityNFT 和 MonsterNFT 对战的一次尝试和示例。如果您胜利了，可以获得一些铜币，战胜的怪物级别越高，获得的奖励越多。欢迎更多开发者参与建设。

Q: 铜币有什么用？
A：铜币可以用来购买装备和其它游戏元素，未来也可获得空投。如果你有更好的创意，欢迎提交到：[https://github.com/crypto-shuraba/MonsterNFT/issues](https://github.com/crypto-shuraba/MonsterNFT/issues)  
如果被采用，会得到奖励。

Q: 参与游戏建设会得到什么？
A: 随着越来越多的人加入我们，我们会将治理权限交给社区成员。未来游戏的经济模型，副本设计，发展方向等，将由社区投票决定。早期支持者，会更容易获得权利。



**联系我们**

Gmail: [cryptoshuraba@gmail.com](mailto:cryptoshuraba@gmail.com)

Twitter: [https://twitter.com/Crypto_Shuraba](https://twitter.com/Crypto_Shuraba)

**友情链接**

Rarity: [https://github.com/andrecronje/rarity](https://github.com/andrecronje/rarity)

Loot: [https://www.lootproject.com/](https://www.lootproject.com/)
