//
//  User.swift
//  TD Coach Cam
//
//  Created by Theo Davis on 12/3/21.
//

import CloudKit
import UIKit

//This gives CloudKit points of reference
struct CoachStrings {
    static let recordTypeKey = "User"
    fileprivate static let coachNameKey = "username"
    static let appleUserRefKey = "apperUserRef"
    fileprivate static let photoAssetKey = "photoAsset"
}//End of struct

class Coach {
    var coachName: String
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
    
    init(coachName: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference) {
        self.coachName = coachName
        self.recordID = recordID
        self.appleUserRef = appleUserRef
    }
}//End of class

//MARK: - Extensions
extension Coach {
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[CoachStrings.coachNameKey] as? String,
              let appleUserRef = ckRecord[CoachStrings.appleUserRefKey] as? CKRecord.Reference else { return nil }
        
        var foundPhoto: UIImage?
        
        if let photoAsset = ckRecord[CoachStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not get data for asset")
            }
        }
        
        self.init(coachName: username, recordID: ckRecord.recordID, appleUserRef: appleUserRef)
    }
}//End of extension

extension Coach: Equatable {
    static func == (lhs: Coach, rhs: Coach) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}//End of extension

extension CKRecord {
    convenience init(coach: Coach) {
        self.init(recordType: CoachStrings.recordTypeKey, recordID: coach.recordID)
        
        setValuesForKeys([
            CoachStrings.coachNameKey : coach.coachName,
            CoachStrings.appleUserRefKey : coach.appleUserRef,
            CoachStrings.photoAssetKey : coach.photoAsset
        ])
    }
}//End of extension
