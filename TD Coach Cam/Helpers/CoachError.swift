//
//  CoachError.swift
//  TD Coach Cam
//
//  Created by Theo Davis on 12/8/21.
//

import Foundation

enum CoachError: Error {
    case ckError(Error)
    case couldNotUnwrap
    case unexpectedRecordsFound
    case noCoachLoggedIn
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Could not unwrap the data"
        case .unexpectedRecordsFound:
            return "Unexpected records found."
        case .noCoachLoggedIn:
            return "No coach logged in. Check for currentCoach"
        }
    }
}//End of enum
