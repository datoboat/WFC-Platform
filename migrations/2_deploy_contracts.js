const WfcRegistry = artifacts.require('WfcRegistry')
const WfcManagmentStorage = artifacts.require('WfcManagmentStorage')
const WfcManagmentLogical = artifacts.require('WfcManagmentLogical')
const WfcHelpRequestStorage = artifacts.require('WfcHelpRequestStorage')
const WfcHelpRequestLogical = artifacts.require('WfcHelpRequestLogical')
module.exports = async function (deployer, network, accounts) {
    owner = accounts[0]
    await deployer.deploy(WfcRegistry, owner, { from: owner, gas: 1800000 })
    await deployer.deploy(WfcManagmentStorage, WfcRegistry.address, { from: owner, gas: 600000 })
    await deployer.deploy(WfcManagmentLogical, WfcRegistry.address, 'WfcManagmentStorage', { from: owner, gas: 1500000 })
    await deployer.deploy(WfcHelpRequestStorage, WfcRegistry.address, { from: owner, gas: 2700000 })
    await deployer.deploy(WfcHelpRequestLogical, WfcRegistry.address, 'WfcHelpRequestStorage', 'WfcDonationsStorage', 'WfcManagmentStorage', 'WfcReserveStorage', { from: owner, gas: 4400000 })
}
