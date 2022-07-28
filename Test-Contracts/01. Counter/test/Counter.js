const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");


describe('Counter contract', function () { 
  async function deployCounterFixture() {

  const Counter = await ethers.getContractFactory("Counter");
  const [owner, otherAddr] = await ethers.getSigners();

  const hardhatCounter = await Counter.deploy();
  await hardhatCounter.deployed();

  return { Counter, hardhatCounter, owner, otherAddr };
  };

describe('Deployment', function () {
  it('Should set the right owner', async function () {
    const { hardhatCounter, owner } = await loadFixture(deployCounterFixture);
    expect(await hardhatCounter.owner()).to.equal(owner.address);
  })

  it('Should set the right initial values of the variables', async function () {
    const { hardhatCounter } = await loadFixture(deployCounterFixture);
    expect(await hardhatCounter.value()).to.equal(0);
    expect(await hardhatCounter.times()).to.equal(0);
  })
});

describe('Contract logic', function () {
      it('Should increase the owner counter value', async function() {
          const { hardhatCounter } = await loadFixture(deployCounterFixture);

          await hardhatCounter.increment(50);
          expect(await hardhatCounter.value()).to.equal(50);
          expect(await hardhatCounter.times()).to.equal(1);

          await hardhatCounter.increment(50);
          expect(await hardhatCounter.value()).to.equal(100);
          expect(await hardhatCounter.times()).to.equal(2);
      })

      it('Should revert if not owner try to increase counter value', async function() {
        const { hardhatCounter, otherAddr } = await loadFixture(deployCounterFixture);       
        await expect(hardhatCounter.connect(otherAddr.address).increment(50)).to.be.reverted;
      })


    it('Should emit event when ownership is transferred', async function () {
      const { hardhatCounter, owner, otherAddr } = await loadFixture(deployCounterFixture);       

      expect(await hardhatCounter.transferOwnership(otherAddr.address))
          .to.emit(hardhatCounter, "OwnershipTransferred")
          .withArgs(owner.address, otherAddr.address);
      })

      it('Should transfer new ownership', async function() {
        const { hardhatCounter, otherAddr } = await loadFixture(deployCounterFixture);

        await hardhatCounter.transferOwnership(otherAddr.address);
        expect(await hardhatCounter.owner()).to.equal(otherAddr.address);
      })
})});