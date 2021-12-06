//
//  CloudKitEnum.swift
//  TD Coach Cam
//
//  Created by Theo Davis on 12/6/21.
//

import Foundation

enum CloudKitError: LocalizedError {
    case iCloudAccountNotFound
    case iCloudAccountNotDetermined
    case iCloudAccountRestricted
    case iCloudAccountUnknown
    
    var errorDescription: String? {
        switch self {
        case .iCloudAccountNotFound:
            return "Could not find your iCloud Account"
        case .iCloudAccountNotDetermined:
            return "Could not determine the current iCloud Account"
        case .iCloudAccountRestricted:
            return "iCloud Account is restricted"
        case .iCloudAccountUnknown:
            return "iCloud Account is unknown"
        }
    }
}//End of Enum
