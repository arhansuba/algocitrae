const Web3 = require('web3');

const providerUrl = 'https://rpc.devnet.citrea.xyz'; // Replace with your Citrea RPC URL
const web3 = new Web3(providerUrl);

module.exports = web3;
