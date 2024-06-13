// Import dependencies
const db = require('../db');

// Function to migrate database
async function migrate() {
  try {
    // Get current database version
    const currentVersion = await db.getVersion();

    // Get migration scripts
    const migrationScripts = require('../migrations');

    // Apply migration scripts
    console.log('Applying migration scripts...');
    for (const script of migrationScripts) {
      if (script.version > currentVersion) {
        await script.up(db);
        console.log(`Applied migration script ${script.version}`);
      }
    }

    // Update database version
    await db.setVersion(migrationScripts[migrationScripts.length - 1].version);

    console.log('Migration successful!');
  } catch (error) {
    console.error(error);
  }
}

// Run migration script
migrate();