const { assert } = require('chai');

const CrowdFunding = artifacts.require('./CrowdFunding.sol');

require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('CrowdFunding', ([deployer, contributor]) => {
    let crowdfunding;

    before(async () => {
        crowdfunding = await CrowdFunding.deployed();
    })

    describe('deployment', async () => {
        it('deploys successfully', async () => {
            const address = await crowdfunding.address;
            assert.notEqual(address, 0x0);
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
        })
    })

    describe('contribution', async () => {
        it('contributes succefully', async () => {
            
        })
    })
})