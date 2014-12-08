extension Train {
    func cleanPassengerCars() -> String {
        return "Clean the passenger cars"
    }
}

class MaglevTrain: Train {
    func referToSpecialist() -> String {
        return "Refer the maglev to a specialist"
    }
}

let maglev = MaglevTrain()
let train = Train()