namespace my.maintenance;

entity Aircraft {
  key tailNumber    : String(10);
      model         : String(50);
      lastCheck     : Date;
      nextCheck     : Date;
      flightHours   : Integer;
      status        : MaintenanceStatus;
      virtual status_criticality : Integer;
}

type MaintenanceStatus : String enum {
  OK      = 'OK';
  Warning = 'Warning';
  Urgent  = 'Urgent';
}