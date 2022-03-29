const { assert } = require('chai');

const Auction = artifacts.require('./Auction.sol');

require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('Auction', ([deployer]) => {
    let auction;

    before(async () => {
        auction = await Auction.deployed();
    })

    describe('deployment', async () => {
        it('deploys successfully', async () => {
            const address = await auction.address;
            assert.notEqual(address, 0x0);
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
        })
    })
})