import detectEthereumProvider from "@metamask/detect-provider";
import { ethers, Contract } from "ethers";
import Gloxis from "./Gloxis.json";

const getBlockchain = () =>
  new Promise(async (resolve, reject) => {
    let provider = await detectEthereumProvider();
    if (provider) {
      await provider.request({ method: "eth_requestAccounts" });
      const networkId = await provider.request({ method: "net_version" });
      provider = new ethers.providers.Web3Provider(provider);
      const signer = provider.getSigner();
      const gloxis = new Contract(
        "0xfe467A14D37F52E3de95Df63BC82E641B5D72B64",
        Gloxis.abi,
        signer
      );
      resolve({ gloxis });
      return;
    }
    reject("Install Metamask");
  });

export default getBlockchain;
