const cds = require('@sap/cds');

module.exports = cds.service.impl(function() {
    // Get the Aircraft entity from the service
    const { Aircraft } = this.entities;

    // Implement the 'performMaintenance' action
    this.on('performMaintenance', 'Aircraft', async (req) => {
        // The key of the specific aircraft is in req.params
        const aircraftKey = req.params[0].tailNumber;
        const tx = cds.transaction(req);

        // Set the new 'lastCheck' to today
        const today = new Date().toISOString().slice(0, 10);

        // Calculate the new 'nextCheck' date (e.g., one year from today)
        const nextYear = new Date();
        nextYear.setFullYear(nextYear.getFullYear() + 1);
        const nextCheck = nextYear.toISOString().slice(0, 10);

        console.log(`Performing maintenance for ${aircraftKey}. New nextCheck is ${nextCheck}.`);

        // Update the aircraft record in the database
        await tx.update(Aircraft, aircraftKey).with({
            lastCheck: today,
            nextCheck: nextCheck
        });

        // Return the updated aircraft data
        return await SELECT.one.from(Aircraft, aircraftKey);
    });
});
