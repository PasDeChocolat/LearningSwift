extension Train: Printable {
    
    var description: String {

        switch status {

        case .OnTime:
            // match against the OnTime enumeration case pattern
            return "On time"

        case .Delayed(let minutes) where 0...5 ~= minutes:
            // match against a pattern expression representing a range of values,
            // and use the "~=" operator to mean "where 'range' contains 'value'"
            return "Slight delay of \(minutes) min"

        case .Delayed(_):
            // match against all remaining Delayed enumeration cases,
            // using a wildcard pattern to match any number of minutes
            return "Delayed"

        }

    }
    
}