require("@nomiclabs/hardhat-waffle");

module.exports = {
    solidity: "0.8.4",
    networks: {
        citrea: {
            url: "https://rpc.devnet.citrea.xyz",
            chainId: 62298,
            accounts: ["YOUR_PRIVATE_KEY"],
        },
    },
};
