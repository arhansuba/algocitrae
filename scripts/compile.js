const { task } = require('hardhat/config');

// Define a task to compile contracts
task('compile', 'Compiles the Solidity contracts')
  .setAction(async function (args, hre) {
    try {
      // Run the compilation
      const { artifacts } = hre;
      await hre.run('clean'); // Optional: Clean artifacts before compilation
      await hre.run('compile'); // Compile the contracts
      console.log('Contracts compiled successfully!');
    } catch (error) {
      console.error('Error compiling contracts:', error);
      process.exitCode = 1;
    }
  });

// Ensure the task is defined
module.exports = {};
