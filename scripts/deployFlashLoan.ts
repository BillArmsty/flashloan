import { ethers} from "hardhat";




async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());
  

  const FlashLoan = await ethers.getContractFactory("FlashLoan");
  
  
  const flashLoan = await FlashLoan.deploy("0x0496275d34753A48320CA58103d5220d394FF77F");

  await flashLoan.deployed();
  console.log("Flash loan contract deployed to:", flashLoan.address);
 
}


main().catch((error) => {

  console.error(error);
  process.exitCode = 1;
});
