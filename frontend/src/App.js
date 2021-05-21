import logo from "./logo.svg";
import "./App.css";
import { BigNumber } from "ethers";
import getBlockchain from "./ethereum";
import { useState, useEffect } from "react";

const generateRGB = (dna) => {
  let colorPalette = [];
  let rgb = [];
  while (dna.length > 1) {
    let colorItem = Number(dna.slice(0, 3));
    if (colorItem > 255) {
      colorItem = Number(dna.slice(0, 2));
      dna = dna.substr(2, dna.length);
    } else {
      dna = dna.substr(3, dna.length);
    }
    if (rgb.length >= 3) {
      colorPalette.push(rgb);
      rgb = [];
    } else {
      rgb.push(colorItem);
    }
  }
  return colorPalette;
};

function App() {
  const [data, setData] = useState(undefined);

  useEffect(() => {
    const init = async () => {
      const { gloxis } = await getBlockchain();
      const data = await gloxis.characters(0);
      setData(data);
      let dna = BigNumber.from(data.dna).toString();
      const colorPalette = generateRGB(dna);
      console.log("> Nome:", data.name);
      console.log("> Level:", data.level);
      console.log("> Mana:", data.manaCount);
      console.log("> RGB:", colorPalette);
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

        {data && <h1>{data.name}</h1>}
      </header>
    </div>
  );
}

export default App;
