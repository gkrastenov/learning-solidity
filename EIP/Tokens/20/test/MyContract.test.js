const { expect } = require("chai");
const { ethers } = require("hardhat");

describe('MyGLDToken with total supply', async function () {
    const totalSupply = 10000;
    beforeEach(async function () {
        [deployer, acc1, acc2] = await ethers.getSigners();

        this.MyGLDTokenContract = await (await ethers.getContractFactory("MyGLDToken"))
        .deploy(totalSupply);
    });

    describe("Deployment", async function () {
        it('should set the name of the token', async function() {
            expect(await this.MyGLDTokenContract.name()).to.equal("Gold");
        });

        it('should set the symbol of the token', async function() {
            expect(await this.MyGLDTokenContract.symbol()).to.equal("GLD");
        });

        it('should set the total supply of the token', async function() {
            const totalsupply = await this.MyGLDTokenContract.totalSupply();
            expect(totalsupply.toNumber()).to.equal(totalSupply);
        });

        it('should set the decimals of the token', async function() {
            expect(await this.MyGLDTokenContract.decimals()).to.equal(18);
        });

        it('should set the total supply to balance of the owner of the token', async function() {
            const balanceOfOwner = await this.MyGLDTokenContract.balanceOf(deployer.address)
            expect(balanceOfOwner.toNumber()).to.equal(totalSupply);
        });
    });

    describe("Implementation", async function () {
        it('should transfer token to other address', async function () {
            await this.MyGLDTokenContract.connect(deployer).transfer(acc1.address, 5);
            await this.MyGLDTokenContract.connect(deployer).transfer(acc2.address, 250);

            const balanceOfAcc1 = await this.MyGLDTokenContract.balanceOf(acc1.address);
            const balanceOfAcc2 = await this.MyGLDTokenContract.balanceOf(acc2.address);

            expect(balanceOfAcc1.toNumber()).to.equal(5);
            expect(balanceOfAcc2.toNumber()).to.equal(250);
        });

        it('should approve token to other address', async function () {
            await this.MyGLDTokenContract.connect(deployer).approve(acc1.address, 500);
            const allowedToken = await this.MyGLDTokenContract.allowance(deployer.address, acc1.address);
            expect(allowedToken.toNumber()).to.equal(500);
        });

        it('should increase allowed token to other address', async function () {
            await this.MyGLDTokenContract.connect(deployer).approve(acc1.address, 500);
            await this.MyGLDTokenContract.connect(deployer).increaseAllowance(acc1.address, 400);
            const allowedToken = await this.MyGLDTokenContract.allowance(deployer.address, acc1.address);
            expect(allowedToken.toNumber()).to.equal(900);
        });
        
        it('should decreases allowed token to other address', async function () {
            await this.MyGLDTokenContract.connect(deployer).approve(acc1.address, 500);
            await this.MyGLDTokenContract.connect(deployer).decreaseAllowance(acc1.address, 400);
            const allowedToken = await this.MyGLDTokenContract.allowance(deployer.address, acc1.address);
            expect(allowedToken.toNumber()).to.equal(100);
        });

        it('should transfer from token to other address', async function () {
            await this.MyGLDTokenContract.connect(deployer).approve(deployer.address, 500); // first should allow to be transfered
            await this.MyGLDTokenContract.connect(deployer).transferFrom(deployer.address, acc1.address, 500);

            const balanceOfAcc1 = await this.MyGLDTokenContract.balanceOf(acc1.address);
            expect(balanceOfAcc1.toNumber()).to.equal(500);
        });
    });

    describe("Events", async function () {
        it("should emit Approval event after succesfully called approve function", async function () {
            await expect(this.MyGLDTokenContract.connect(deployer).approve(acc1.address, 500))
                .to.emit(this.MyGLDTokenContract, "Approval").withArgs(deployer.address, acc1.address, 500);
        });
        it("should emit Approval event after succesfully called increaseAllowance function", async function () {
            await expect(this.MyGLDTokenContract.connect(deployer).increaseAllowance(acc1.address, 500))
                .to.emit(this.MyGLDTokenContract, "Approval").withArgs(deployer.address, acc1.address, 500);
        });
        it("should emit Approval event after succesfully called decreaseAllowance function", async function () {
            await this.MyGLDTokenContract.connect(deployer).approve(acc1.address, 500);
            await expect(this.MyGLDTokenContract.connect(deployer).decreaseAllowance(acc1.address, 100))
                .to.emit(this.MyGLDTokenContract, "Approval").withArgs(deployer.address, acc1.address, 400);
        });
        it("should emit Transfer event after succesfully called transfer function", async function () {
            await expect(this.MyGLDTokenContract.connect(deployer).transfer(acc1.address, 100))
                .to.emit(this.MyGLDTokenContract, "Transfer").withArgs(deployer.address, acc1.address, 100);
        });
        it("should emit Transfer event after succesfully called transferFrom function", async function () {
            await this.MyGLDTokenContract.connect(deployer).approve(deployer.address, 500);
            await expect(this.MyGLDTokenContract.connect(deployer).transferFrom(deployer.address, acc1.address, 100))
                .to.emit(this.MyGLDTokenContract, "Transfer").withArgs(deployer.address, acc1.address, 100);
        });
    });

    // hardhat-waffle is needed for using of revertedWith
    describe("Errors", async function () {
        it('should not transfer token to zero address', async function () {
            await expect(this.MyGLDTokenContract.connect(deployer).transfer(ethers.constants.AddressZero, 5))
            .to.be.revertedWith("ERC20: transfer to the zero address");
        });
        it('should not transfer token if amount is bigger than balance of address', async function () {
            await expect(this.MyGLDTokenContract.connect(acc1).transfer(acc2.address, 5))
            .to.be.revertedWith("ERC20: transfer amount exceeds balance");
        });

        it('should not decreased allowance below zero', async function () {
            await this.MyGLDTokenContract.connect(deployer).approve(acc1.address, 500);
            await expect(this.MyGLDTokenContract.connect(deployer).decreaseAllowance(acc1.address, 600))
            .to.be.revertedWith("ERC20: decreased allowance below zero");
        });

    });
});