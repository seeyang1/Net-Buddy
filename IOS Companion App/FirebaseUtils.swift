//
//  FirebaseUtils.swift
//  Net Buddy
//
//  Created by Nick Dimitrakas on 3/21/22.
//  Copyright © 2022 Nick Dimitrakas. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseUtils {
    static var db: Firestore {
        Firestore.firestore()
    }
    //static var functions: Functions {
    //    Functions.functions()
    //}
}

/*
 * Authentication methods
 */
extension FirebaseUtils {
    /*
     * Creates a user with the default email/password login scheme.
     *
     * param password: String longer than 8 characters represesenting the user's password
     * param email: String formatted as, ******@****.***, representing the user's email
     * param completion: Closure that takes in a Bool (representing whether the user was
     *                   created successfully) and executes any code required for completion
     */
    static func createUserWith(_ password: String, _ email: String, completion: ((Bool) -> ())?) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                if let completion = completion {
                    completion(false)
                }
                return
            }
            guard let user = authResult?.user else { return }
            let uid = user.uid
            upload(data: [
                "email": email,
            ], at: "userEmails/\(uid)", completion: completion)
        }
    }
    
    /*
    
    static func createBatchWith(_ type: String, _ status: String, _ batchNumber: String, _ dateCollected: String, _ dateRecieved: String, _ client: String, _ projectLocation: String, _ numberOfSamples: String, _ typeOfSamples: String, completion: @escaping (()->Void)) {
        db.collection("batches").addDocument(data: ["type":type, "status":status, "batchNumber":batchNumber, "dateCollected":dateCollected, "dateRecieved":dateRecieved, "client":client, "projectLocation":projectLocation, "numberOfSamples":numberOfSamples, "typeOfSamples":typeOfSamples]) { error in
            completion()
        }
        
    }
     
    */
    
    /*
     * Login with the default email/password scheme.
     *
     * param email: String formatted as, ******@****.***, representing the user's email
     * param password: String longer than 8 characters represesenting the user's password
     * param completion: Closure that takes in a Bool (representing whether the user was
     *                   created successfully) and executes any code required for completion
     */
    static func signInWith(_ email: String, _ password: String,
                          completion: @escaping ((Bool) -> ())) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error logging in ", error)
                completion(false)
                return
            }
            completion(true)
        }
    }
}

/*
 * Firestore methods
 */
extension FirebaseUtils {
    /*
     * Takes in a string describing the documents location and returns a document reference
     * for that document.
     *
     * param for location: String formatted like "foo/bar/foobar/barfoo" where the last token
     *                     is the name of the document being looked for. Number of tokens must
     *                     be an even number.
     * return: DocumentReference pointing to the given document in the database if it could be
     *         found, nil otherwise.
     */
    private static func getDocumentRefence(for location: String) -> DocumentReference? {
        var path = location.split(separator: "/")
        guard path.count % 2 == 0 else {
            return nil
        }
        var collectionRef: CollectionReference = db.collection(String(path.removeFirst()))
        var documentRef: DocumentReference?
        while !path.isEmpty {
            if path.count % 2 == 0 {
                collectionRef = (documentRef?.collection(String(path.removeFirst())))!
            } else {
                documentRef = collectionRef.document(String(path.removeFirst()))
            }
        }
        return documentRef
    }
    
    /*
     * Deletes document at the specified location.
     *
     * param at location: String formatted like "foo/bar/foobar/barfoo" where the last token
     *                    is the name of the document being looked for. Number of tokens must
     *                    be an even number.
     */
    static func deleteDocument(at location: String, completion: @escaping (() -> Void)) {
        let documentRef = getDocumentRefence(for: location)
        documentRef?.delete() { error in
            if let _ = error {
                print("Error deleting document.")
            }
            completion()
        }
    }
    
    /*
     * Gets the value associated with the gien key from the document at the location. Saves
     * this value with the given closure.
     *
     * param key: The desired key to access in the document.
     * param from location: String formatted like "foo/bar/foobar/barfoo" where the last token
     *                 is the name of the document being looked for. Number of tokens must
     *                 be an even number.
     * param saveAt save: Closure that saves the given value.
     */
    static func getField(_ key: String, from location: String, saveAt save: @escaping ((Any?) -> ())) {
        let documentRef = getDocumentRefence(for: location)
        documentRef?.getDocument() { (document, err) in
            if let err = err {
                print("Error getting document ", err.localizedDescription)
                return
            }
            save(document!.get(key))
        }
    }
    
    /*
     * Updates the document at the location with an updated key-value pair.
     *
     * param key: The desired key to update in the document.
     * param value: The new value to store in the document.
     * param at location: String formatted like "foo/bar/foobar/barfoo" where the last token
     *                 is the name of the document being looked for. Number of tokens must
     *                 be an even number.
     */
    static func updateField(_ key: AnyHashable, _ value: Any, at location: String) {
        let documentRef = getDocumentRefence(for: location)
        documentRef?.updateData([
            key : value
        ])
    }
    
    /*
    * Updates the document at the location with the updated key-value pairs.
    *
    * param with data: The updated key-value pairs.
    * param at location: String formatted like "foo/bar/foobar/barfoo" where the last token
    *                 is the name of the document being looked for. Number of tokens must
    *                 be an even number.
    */
    static func updateDocument(with data: [AnyHashable: Any], at location: String, completion: @escaping ((Bool) -> Void)) {
        let documentRef = getDocumentRefence(for: location)
        documentRef?.updateData(data) { error in
            if let error = error {
                print("Error updating document ", error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    /*
     * Uploads a document to the Firestore database.
     *
     * param data: all key-value pairs for the new document.
     * param at location: String formatted like "foo/bar/foobar/barfoo" where the last token
     *                 is the name of the document being created. Number of tokens must
     *                 be an even number.
     * param completion: Closure that takes in a Bool (representing whether the user was
     *                   created successfully) and executes any code required for completion
     */
    static func upload(data: [String: Any], at location: String, completion: ((Bool) -> ())?) {
        if let documentRef = getDocumentRefence(for: location) {
            documentRef.setData(data) { err in
                guard let completion = completion else { return }
                if let err = err {
                    print("Error writing documents: \(err.localizedDescription)")
                    completion(false)
                } else {
                    print("Documents written sucessfully")
                    completion(true)
                }
            }
        }
    }
    
    /*
     * Determines whether a document exists and passes this Bool into the completion closure.
     *
     * param at location: the location you want to upload the image in Firebase Storage
     * param completion: Closure that takes in a Bool (representing whether the user was
     *                   created successfully) and executes any code required for completion
     */
    static func documentExists(at location: String, completion: @escaping ((Bool) -> ())) {
        if let documentRef = getDocumentRefence(for: location) {
            documentRef.getDocument { (document, error) in
                if let error = error {
                    print("Error checking if \(location) exists: ", error)
                    return
                }
                if let document = document, document.exists {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    static func getUserInformation(for user: String, completionHandler: @escaping (( String) -> Void)) {
        let userRef = db.collection("userEmails").document(user)
        userRef.getDocument() { (document, error) in
            if let error = error {
                print("Error getting user information: ", error)
                return
            }
            guard let document = document else { return }
            let email = (document.get("email") as? String) ?? ""

            completionHandler(email)
        }
    }
    
    /*
    static func getLogbookBatches(for type: String, completionHandler: @escaping (( [Batch]) -> Void)) {
        let batchesRef = db.collection("batches").whereField("type", isEqualTo: type)
        batchesRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error occured getting logbook", err.localizedDescription)
                return
            }
            var batches: [Batch] = []
            for document in querySnapshot!.documents {
                let uid = document.documentID
                let batchNumber = (document.get("batchNumber") as? String) ?? ""
                let client = (document.get("client") as? String) ?? ""
                let dateCollected = (document.get("dateCollected") as? String) ?? ""
                let dateRecieved = (document.get("dateRecieved") as? String) ?? ""
                let numberOfSamples = (document.get("numberOfSamples") as? Int) ?? 0
                let projectLocation = (document.get("projectLocation") as? String) ?? ""
                let status = (document.get("status") as? String) ?? ""
                let type = (document.get("type") as? String) ?? ""
                let typeOfSamples = (document.get("typeOfSamples") as? String) ?? ""
                let batch = Batch(uid:uid, type: type, status: status, batchNumber: batchNumber, dateCollected: dateCollected, dateRecieved: dateRecieved, client: client, projectLocation: projectLocation, numberOfSamples: numberOfSamples, typeOfSamples: typeOfSamples)
                batches.append(batch)
            }
            completionHandler(batches)
        }
    }
     
    */
    
    /*
     * FOR REFERENCE
     *
     */
//    static func getSearchResultsFor(query: String, completion: @escaping (([User]) -> Void)) {
//        let searchRef = db.collection("users").whereField("username", isEqualTo: query)
//        searchRef.getDocuments() { querySnapshot, error in
//            if let _ = error {
//                return
//            }
//            guard querySnapshot!.count > 0 else {
//                completion([])
//                return
//            }
//            var searchResults: [User] = []
//            for document in querySnapshot!.documents {
//                let uid = document.documentID
//                let profilePicture = (document.get("profilePicture") as? String) ?? ""
//                let username = (document.get("username") as? String) ?? ""
//                let user = User(username: username, uid: uid, profilePictureUrl: URL(string: profilePicture)!)
//                searchResults.append(user)
//            }
//            completion(searchResults)
//        }
//    }
    
    /*
     * FOR REFERENCE
     *
     */
//    static func reportLink(by user: String, linkId link: String, completion: @escaping ((Bool) -> Void)) {
//        self.functions.httpsCallable("reportLink").call([
//            "user": user,
//            "link": link
//        ]) { (result, error) in
//            if let error = error as NSError? {
//                if error.domain == FunctionsErrorDomain {
//                    let code = FunctionsErrorCode(rawValue: error.code)
//                    let message = error.localizedDescription
//                    let details = error.userInfo[FunctionsErrorDetailsKey]
//                    print("\(String(describing: code)) \(message) \(String(describing: details))")
//                }
//                completion(false)
//            } else {
//                completion(true)
//            }
//        }
//    }
}

