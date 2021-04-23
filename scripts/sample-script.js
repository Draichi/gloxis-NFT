const RINKEBY_VRF_COORDINATOR = "0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B";
const RINKEBY_LINKTOKEN = "0x01BE23585060835E02B77ef475b0Cc51aA1e0709";
const RINKEBY_KEYHASH =
  "0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311";

async function main() {
  const Greeter = await hre.ethers.getContractFactory("Gloxis");
  const greeter = await Greeter.deploy(
    RINKEBY_VRF_COORDINATOR,
    RINKEBY_LINKTOKEN,
    RINKEBY_KEYHASH
  );

  await greeter.deployed();
  console.log("Greeter deployed to:", greeter.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
