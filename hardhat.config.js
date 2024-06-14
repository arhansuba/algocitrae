require("@nomiclabs/hardhat-waffle");

module.exports = {
    solidity: "0.8.20",
    networks: {
        citrea: {
            url: "https://rpc.devnet.citrea.xyz",
            chainId: 62298,
            accounts: ["60f87dd6f28de6062dd2a69a22d358a712d4f0781c0bf356abde83cbf6fae31f"],
        },
    },
};
