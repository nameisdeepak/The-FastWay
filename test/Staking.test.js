const Staking = artifacts.require("Staking");

contract("Staking", accounts => {
    let staking;

    beforeEach(async () => {
        staking = await Staking.new({from: accounts[1]});
    });

    it("should allow staking", async () => {
        await staking.stake(100, { from: accounts[0] });
        assert.equal(await staking.stakes(accounts[0]), 100, "Stake value did not match");
    });

    

    it("should allow unstaking", async () => {
        await staking.stake(100, { from: accounts[0] });
        await staking.unstake({ from: accounts[0] });
        assert.equal(await staking.stakes(accounts[0]), 0, "Stake value did not match after unstaking");
    });

    it("should allow compounding rewards", async () => {
        await staking.stake(100, { from: accounts[0] });
        await staking.setRewardPerBlock(10);
        await staking.compound({ from: accounts[0] });
        assert.equal(await staking.stakes(accounts[0]), 1100, "Stake value did not match after compounding");
    });

   
    it("should not allow non-owner to set reward per block", async () => {
        try {
            await staking.setRewardPerBlock(10, { from: accounts[1] });
        } catch (error) {
            assert.equal(error.reason, "Only owner can set reward per block", "Error reason did not match");
        }
    });
    
});
