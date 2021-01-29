const MdtToken = artifacts.require('MdtToken');
const StakePool = artifacts.require('StakePool');

require('chai')
	.use(require('chai-as-promised'))
	.should()

function tokens(n) {
  return web3.utils.toWei(n, 'ether');
}

contract('StakePool', (accounts) =>{

	let mdtToken, stakePool

	before(async () =>{

		mdtToken = await MdtToken.new()
		stakePool = await StakePool.new(mdtToken.address)

		await mdtToken.transfer(accounts[1], tokens('10000'), { from : accounts[0]} )
		await mdtToken.transfer(accounts[2], tokens('10000'), { from : accounts[0]} )
		await mdtToken.transfer(accounts[3], tokens('30000'), { from : accounts[0]} )
	})

	describe('MDT Token Deployement', async ()=> {

		it('has a name', async () =>{
			//let mdtToken = await MdtToken.new()
			const name = await mdtToken.name()
			assert.equal(name, "MindDeft Token")
		})

		it('account 0 has 9950000 tokens', async () =>{
			//let mdtToken = await MdtToken.new()
			const bal = await mdtToken.balanceOf(accounts[0])
			assert.equal(bal.toString(), tokens('9950000'))
		})

		it('account 1 has 10000 tokens', async () =>{
			//let mdtToken = await MdtToken.new()
			const bal = await mdtToken.balanceOf(accounts[1])
			assert.equal(bal.toString(), tokens('10000'))
		})

		it('account 2 has 10000 tokens', async () =>{
			//let mdtToken = await MdtToken.new()
			const bal = await mdtToken.balanceOf(accounts[2])
			assert.equal(bal.toString(), tokens('10000'))
		})
		it('account 3 has 30000 tokens', async () =>{
			//let mdtToken = await MdtToken.new()
			const bal = await mdtToken.balanceOf(accounts[3])
			assert.equal(bal.toString(), tokens('30000'))
		})

		
	})

	describe('Stake Pool Deployement', async ()=> {

		it('has a name', async () =>{
			//let mdtToken = await MdtToken.new()
			const name = await stakePool.name()
			assert.equal(name, "Stake Pool System")
		})

	})

	describe('Staking and Farming Operations', async() =>{

		it('stakes MDT tokens',async() =>{

			let result = await mdtToken.balanceOf(accounts[1])
			assert.equal(result.toString(), tokens('10000'), 'Accounts[1] balance is correct before staking')

			await mdtToken.approve(stakePool.address, tokens('10000'), {from : accounts[1]})
			await stakePool.stakeTokens(tokens('10000'), {from : accounts[1]})

			result = await mdtToken.balanceOf(accounts[1])
			assert.equal(result.toString(), tokens('0'), 'Accounts[1] balance is correct after staking')

			result = await mdtToken.balanceOf(stakePool.address)
			assert.equal(result.toString(), tokens('10000'), 'StakePool address balance is correct after staking')

			result = await stakePool.stakingBalance(accounts[1])
			assert.equal(result.toString(), tokens('10000'), 'Accounts[1] staking balance in Stake Pool is correct after staking')

			result = await stakePool.isStaking(accounts[1])
			assert.equal(result.toString(), 'true', 'Accounts[1] is staking')

			result = await stakePool.hasStaked(accounts[1])
			assert.equal(result.toString(), 'true', 'Accounts[1] is in staking history')
		}) 

		it('gets balance', async() => {

			result = await stakePool.getBal(accounts[1])
			assert.equal(result.toString(), tokens('0'), 'Accounts[1] balance is correct after staking')
		})
	})
	
})