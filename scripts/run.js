const main = async () => {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.4"),
  });
  await waveContract.deployed();
  console.log("Contract address:", waveContract.address);

  // Get Contract Balance
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract Balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  // Send a wave
  const waveTxn1 = await waveContract.wave("Wave Numero Uno");
  await waveTxn1.wait();

  // See result to contract balance after wave
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract Balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  // Get and store all waves and messages for UI
  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
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
