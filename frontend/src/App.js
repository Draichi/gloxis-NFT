import logo from "./logo.svg";
import "./App.css";
import { BigNumber, BigNumberish } from "ethers";
import getBlockchain from "./ethereum";
import { useState, useEffect } from "react";

function App() {
  const [gloxis, setGloxis] = useState(undefined);
  const [data, setData] = useState(undefined);

  useEffect(() => {
    const init = async () => {
      const { gloxis } = await getBlockchain();
      const data = await gloxis.characters(0);
      setGloxis(gloxis);
      setData(data);
      const dna = BigNumber.from(data.dna).toString();
      console.log(">", dna.slice(0, 3));
      console.log(">", dna);
    };
    init();
  }, []);
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        ></a>
      </header>
    </div>
  );
}

export default App;
