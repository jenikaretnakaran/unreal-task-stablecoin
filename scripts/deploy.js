const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();

  console.log("Deploying contracts with account: ", deployer.address);
  console.log("Account balance: ", accountBalance.toString());

  const coinContractFactory = await hre.ethers.getContractFactory(
    "NUSDStableCoin"
  );
  const coinContract = await coinContractFactory.deploy(
    "0x694AA1769357215DE4FAC081bf1f309aDC325306"
  );
  await coinContract.deployed();

  console.log("coinContract address: ", coinContract.address);

//   // Fetch ETH price from Chainlink Oracle
//   const ethPrice = await coinContract.getEthToUsdExchangeRate();
//   console.log("ETH Price (USD): ", ethPrice.toString());
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
