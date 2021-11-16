// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
 * @dev These functions deal with verification of Merkle Trees proofs.
 *
 * The proofs can be generated using the JavaScript library
 * https://github.com/miguelmota/merkletreejs[merkletreejs].
 * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
 *
 * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
 */
library MerkleProof {
    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
     * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
     * hash matches the root of the tree. When processing the proof, the pairs
     * of leafs & pre-images are assumed to be sorted.
     *
     * _Available since v4.4._
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (computedHash <= proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }
        return computedHash;
    }
}

interface IMerkleProofDistributor {
    function token() external view returns (address);

    function merkleRoot() external view returns (bytes32);

    function isClaimed(uint256 _index) external view returns (bool);

    function claim(uint256 _index, address _receiver, uint256 _amount, bytes32[] calldata _merkleProof) external;

    event Claimed(uint256 index, address receiver, uint256 amount);
}


interface IMonsterERC20 {
    function mint(address to, uint256 amount) external returns (bool);
}

contract MerkleProofDistributor is IMerkleProofDistributor {
    address public immutable override token;
    bytes32 public immutable override merkleRoot;

    mapping(uint256 => uint256) private claimedBitMap;

    constructor(address token_, bytes32 merkleRoot_) {
        token = token_;
        merkleRoot = merkleRoot_;
    }

    function isClaimed(uint256 _index) public view override returns (bool) {
        uint256 claimedWordIndex = _index / 256;
        uint256 claimedBitIndex = _index % 256;
        uint256 claimedWord = claimedBitMap[claimedWordIndex];
        uint256 mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    function _setClaimed(uint256 _index) private {
        uint256 claimedWordIndex = _index / 256;
        uint256 claimedBitIndex = _index % 256;
        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
    }

    function claim(uint256 _index, address _receiver, uint256 _amount, bytes32[] calldata _merkleProof) external override {
        require(!isClaimed(_index), 'Already claimed');

        bytes32 node = keccak256(abi.encodePacked(_index, _receiver, _amount));
        require(MerkleProof.verify(_merkleProof, merkleRoot, node), 'Invalid proof');

        _setClaimed(_index);
        require(IMonsterERC20(token).mint(_receiver, _amount), 'Mint failed');

        emit Claimed(_index, _receiver, _amount);
    }
}
