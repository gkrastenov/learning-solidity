const { expect } = require("chai");

describe('MyFirstContract Unit Test', function() {
    before(async function() {
        MyFirstContract = await ethers.getContractFactory('MyFirstContract');
        contract = await MyFirstContract.deploy();
        await contract.deployed(); 
    })

    beforeEach(async function() {
        await contract.setNumber(0);
    })

    it('Initial value is set to 0', async function() {
        expect(await contract.getNumber()).to.equal(0);
    })

    it('Retrieve returns a value previously stored value', async function() {
        await contract.setNumber(77);
        expect(await contract.getNumber()).to.equal(77);
    })
});