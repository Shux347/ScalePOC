using my.maintenance as my from '../db/data-model';

service MaintenanceService {
    // Expose the Aircraft entity with calculated fields and actions
    entity Aircraft as projection on my.Aircraft {
        *,
        // This case statement calculates the status on the fly
        case 
            when (julianday(nextCheck) - julianday('now')) < 0 then 'Urgent'
            when (julianday(nextCheck) - julianday('now')) <= 30 then 'Warning'
            else 'OK'
        end as status : my.MaintenanceStatus,
        // This case statement calculates the criticality on the fly
        case
            when (julianday(nextCheck) - julianday('now')) < 0 then 1 
            when (julianday(nextCheck) - julianday('now')) <= 30 then 2
            else 3
        end as status_criticality : Integer
    } actions {
        // Action to record a maintenance check
        action performMaintenance();
    };

    // Expose the separate entity for the filter's value help
    @readonly
    entity MaintenanceStatuses as projection on my.MaintenanceStatuses;
}

// Annotations for the main list report table and search
annotate MaintenanceService.Aircraft with @(
    UI: {
        LineItem : [
            { Value: tailNumber, Label: 'Tail Number' },
            { Value: model, Label: 'Model' },
            { Value: lastCheck, Label: 'Last Check' },
            { Value: nextCheck, Label: 'Next Check' },
            { Value: flightHours, Label: 'Flight Hours' },
            { 
              Value: status, 
              Label: 'Status',
              Criticality: status_criticality
            },
            // Add a button to trigger the action
            { 
                $Type: 'UI.DataFieldForAction', 
                Label: 'Perform Maintenance', 
                Action: 'MaintenanceService.performMaintenance'
            }
        ],
        // Add a filter bar for the 'status' field
        SelectionFields: [ status ]
    },
    // Enable search for these fields
    Search.defaultSearchElement: tailNumber
);

// Annotation to provide a value list for the status filter
annotate MaintenanceService.Aircraft with {
    status @(Common.ValueList : {
        CollectionPath : 'MaintenanceStatuses',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                ValueListProperty : 'name',
                LocalDataProperty : status
            }
        ],
        Label          : 'Maintenance Status'
    });
}