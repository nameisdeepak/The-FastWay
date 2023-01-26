// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;
pragma abicoder v2;

contract Staking {
    mapping(address => uint) public stakes;
    mapping(address => bool) public stakers;
    uint public totalStake;
    uint public totalReward;
    uint public rewardPerBlock;

    event Staked(address staker, uint stake);
    event Compounded(address staker, uint reward);

    function stake(uint stakeAmount) public {
        require(stakeAmount > 0, "Cannot stake 0 or less tokens");
        require(!stakers[msg.sender], "Sender already staked");
        stakes[msg.sender] = stakeAmount;
        stakers[msg.sender] = true;
        totalStake += stakeAmount;
        emit Staked(msg.sender, stakeAmount);
    }

    function unstake() public {
        require(stakers[msg.sender], "Sender has not staked yet");
        totalStake -= stakes[msg.sender];
        delete stakes[msg.sender];
        stakers[msg.sender] = false;
    }

    function compound() public {
        require(stakers[msg.sender], "Sender has not staked yet");
        uint reward = stakes[msg.sender] * rewardPerBlock;
        stakes[msg.sender] += reward;
        totalStake += reward;
        totalReward += reward;
        emit Compounded(msg.sender, reward);
    }

    function setRewardPerBlock(uint _rewardPerBlock) public {
        require(msg.sender == msg.sender, "Only owner can set reward per block");
        rewardPerBlock = _rewardPerBlock;
    }
}
