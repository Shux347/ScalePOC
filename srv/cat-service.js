const cds = require('@sap/cds');

module.exports = cds.service.impl(function() {
    this.after('READ', 'Aircraft', (each) => {
        const today = new Date();
        const nextCheckDate = new Date(each.nextCheck);
        const daysUntilCheck = (nextCheckDate - today) / (1000 * 60 * 60 * 24);

        if (daysUntilCheck < 0) {
            each.status = 'Urgent';
            // Value 1 corresponds to Red in this UI5 version
            each.status_criticality = 1;
        } else if (daysUntilCheck <= 30) {
            each.status = 'Warning';
            // Value 2 corresponds to Yellow in this UI5 version
            each.status_criticality = 2;
        } else {
            each.status = 'OK';
            // Value 3 corresponds to Green in this UI5 version
            each.status_criticality = 3;
        }
    });
});