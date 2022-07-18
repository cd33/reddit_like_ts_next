const hre = require('hardhat')

async function main() {
  const Reddit = await hre.ethers.getContractFactory('Reddit')
  const reddit = await Reddit.deploy()
  await reddit.deployed()
  console.log('Reddit deployed to:', reddit.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
