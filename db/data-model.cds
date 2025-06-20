namespace my.maintenance;

entity Aircraft {
  key tailNumber          : String(10);
      model               : String(50);
      lastCheck           : Date;
      nextCheck           : Date;
      flightHours         : Integer;
      // Add a "to-many" composition to link to its maintenance records
      maintenanceHistory  : Composition of many MaintenanceRecords on maintenanceHistory.aircraft = $self;
}

entity MaintenanceRecords {
    key ID          : UUID;
        timestamp   : DateTime;
        technician  : String(100);
        comments    : String;
        // Add a "to-one" association back to the parent aircraft
        aircraft    : Association to Aircraft;
}

// Entity for the filter dropdown
entity MaintenanceStatuses {
    key name : MaintenanceStatus;
}

// New entity for the maintenance interval dropdown
entity Intervals {
    key months: Integer;
    description: String;
}

type MaintenanceStatus : String enum {
  OK      = 'OK';
  Warning = 'Warning';
  Urgent  = 'Urgent';
}