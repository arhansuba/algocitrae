// Import dependencies
const jest = require('jest');

// Function to run tests
async function runTests() {
  try {
    // Run Jest tests
    console.log('Running tests...');
    const testResults = await jest.runCLI({
      config: 'jest.config.js',
      roots: ['<rootDir>/src']
    });

    // Print test results
    console.log(testResults.results);

    if (testResults.numFailedTests > 0) {
      console.error(`Failed tests: ${testResults.numFailedTests}`);
      process.exit(1);
    } else {
      console.log('All tests passed!');
    }
  } catch (error) {
    console.error(error);
  }
}

// Run tests
runTests();