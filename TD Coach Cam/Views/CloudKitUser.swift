//
//  CloudKitUser.swift
//  TD Coach Cam
//
//  Created by Theo Davis on 12/6/21.
//

import SwiftUI
import CloudKit

class CloudKitUserSign: ObservableObject {
    
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    
    init() {
        getiCloudStatus()
    }
    
    //This function checks to see if the system can access the user's iCloud account
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self]returnedStatus, Error in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.localizedDescription
                case .available:
                    self?.isSignedInToiCloud = true
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.localizedDescription
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.localizedDescription
                default:
                    self?.error = CloudKitError.iCloudAccountUnknown.localizedDescription
                }
            }
        }
    }
}//End of class

struct CloudKitUser: View {
    
    @StateObject private var vm = CloudKitUserSign()
    
    var body: some View {
        Text("Is Signed In: \(vm.isSignedInToiCloud.description.uppercased())")
        Text(vm.error)
    }
}

struct CloudKitUser_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitUser()
    }
}
