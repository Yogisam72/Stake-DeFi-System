const MdtToken = artifacts.require('MdtToken');
const StakePool = artifacts.require('StakePool');

module.exports = async function(deployer, network, accounts) {

	await deployer.deploy(MdtToken)
	const mdtToken = await MdtToken.deployed()

	await deployer.deploy(StakePool, mdtToken.address)
	const stakePool = await StakePool.deployed()

	await mdtToken.transfer(accounts[1], '10000000000000000000000')
	await mdtToken.transfer(accounts[2], '10000000000000000000000')
	await mdtToken.transfer(accounts[3], '30000000000000000000000')
}