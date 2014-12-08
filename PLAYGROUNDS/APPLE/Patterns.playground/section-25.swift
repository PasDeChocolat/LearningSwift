func trainDescription(train: Train) -> String {
    switch train {
    case is MaglevTrain:
        return "The fastest train on earth."
    default:
        return "Some other kind of train."
    }
}