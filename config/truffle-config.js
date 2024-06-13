module.exports = {
    networks: {
      citrea: {
        url: "https://rpc.devnet.citrea.xyz",
        chainId: 62298,
        accounts: ["YOUR_PRIVATE_KEY"]
      }
    },
    compilers: {
      solc: {
        version: "0.8.10", // Specify your Solidity compiler version
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    }
  };
  