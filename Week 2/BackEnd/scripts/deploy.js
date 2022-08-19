const hre = require("hardhat");

async function main() {
  const BuyMeACoffe = await hre.ethers.getContractFactory("BuyMeACoffe");
  const buyMeACoffe = await BuyMeACoffe.deploy();
  await buyMeACoffe.deployed();
  console.log("BuyMeACoffe deployed to: ", buyMeACoffe.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
