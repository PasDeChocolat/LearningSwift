func determineMaintenanceRequirements(train: Train) -> String {
    switch train {
    case let maglev as MaglevTrain:
        return maglev.referToSpecialist()
    default:
        return train.cleanPassengerCars()
    }
}

determineMaintenanceRequirements(train)
determineMaintenanceRequirements(maglev)