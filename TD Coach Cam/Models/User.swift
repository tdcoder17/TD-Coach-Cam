//
//  User.swift
//  TD Coach Cam
//
//  Created by Theo Davis on 12/3/21.
//

import CloudKit
import UIKit

//This gives CloudKit points of reference
struct UserStrings {
    static let recordTypeKey = "User"
    fileprivate static let userNameKey = "username"
    static let appleUserRefKey = "apperUserRef"
    fileprivate static let photoAssetKey = "photoAsset"
}//End of struct

class User {
    var username: String
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    
    var profilePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoData: Data?
    
    var photoAsset: CKAsset {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(username: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference) {
        self.username = username
        self.recordID = recordID
        self.appleUserRef = appleUserRef
    }
}//End of class

//MARK: - Extensions
extension User {
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserStrings.userNameKey] as? String,
              let appleUserRef = ckRecord[UserStrings.appleUserRefKey] as? CKRecord.Reference else { return nil }
        
        var foundPhoto: UIImage?
        
        if let photoAsset = ckRecord[UserStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not get data for asset")
            }
        }
        
        self.init(username: username, recordID: ckRecord.recordID, appleUserRef: appleUserRef)
    }
}//End of extension
