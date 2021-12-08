//
//  CoachController.swift
//  TD Coach Cam
//
//  Created by Theo Davis on 12/8/21.
//

import CloudKit
import UIKit

class CoachController {
    //MARK: - Properties
    static let sharedInstance = CoachController()
    var currentCoach: Coach?
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - Methods: CRUD Functions
    func createCoachWith(_ coachName: String, profilePhoto: UIImage?, completion: @escaping (Result<Coach?, CoachError>) -> Void) {
        fetchAppleUserRef { (result) in
            switch result {
            case .success(let reference):
                guard let reference = reference else { return completion(.failure(.noCoachLoggedIn)) }
                let newCoach = Coach(coachName: coachName, appleUserRef: reference)
                let record = CKRecord(coach: newCoach)
                
                self.publicDB.save(record) {(record, error) in
                    
                    if let error = error {
                        return completion(.failure(.ckError(error)))
                    }
                    
                    guard let record = record else { return completion(.failure(.unexpectedRecordsFound))}
                    
                    guard let savedCoach = Coach(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
                    
                    print("Created Coach: \(record.recordID.recordName)")
                    completion(.success(savedCoach))
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }//end of func
    
    func fetchCoach(completion: @escaping (Result<Coach?, CoachError>) -> Void) {
        fetchAppleUserRef { (result) in
            switch result {
            case .success(let reference):
                guard let reference = reference else { return completion(.failure(.noCoachLoggedIn))}
                
                let predicate = NSPredicate(format: "%K == %@", argumentArray: [CoachStrings.appleUserRefKey, reference])
                
                let query = CKQuery(recordType: CoachStrings.recordTypeKey, predicate: predicate)
                
                self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
                    
                    if let error = error {
                        return completion(.failure(.ckError(error)))
                    }
                    
                    guard let record = records?.first else { return completion(.failure(.unexpectedRecordsFound))}
                    
                    guard let foundCoach = Coach(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
                    
                    print("Fetched Coach: \(record.recordID.recordName)")
                    completion(.success(foundCoach))
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }//end of func
    
    //This function fetches User from Cloud Container
    private func fetchAppleUserRef(completion: @escaping (Result<CKRecord.Reference?, CoachError>) -> Void) {
        CKContainer.default().fetchUserRecordID { recordID, error in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            
            if let recordID = recordID {
                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                
                completion(.success(reference))
            }
        }
    }
}//End of class
