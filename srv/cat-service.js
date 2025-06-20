const cds = require('@sap/cds');

module.exports = cds.service.impl(function() {
    this.after('READ', 'Aircraft', (each) => {
        const today = new Date();
        const nextCheckDate = new Date(each.nextCheck);
        const daysUntilCheck = (nextCheckDate - today) / (1000 * 60 * 60 * 24);

        if (daysUntilCheck < 0) {
            each.status = 'Urgent';
            each.status_criticality = 3; // Red
        } else if (daysUntilCheck <= 30) {
            each.status = 'Warning';
            each.status_criticality = 2; // Yellow
        } else {
            each.status = 'OK';
            each.status_criticality = 1; // Green
        }
    });
});