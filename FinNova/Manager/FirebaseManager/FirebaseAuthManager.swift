//
//  FirebaseAuthManager.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import FirebaseAuth

class FirebaseAuthManager {
    
    func createUserWithEmailAndPassword(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completionBlock(false, error.localizedDescription)
            } else if let user = authResult?.user {
                print("User created: \(user)")
                completionBlock(true, nil)
            } else {
                completionBlock(false, "Unknown error")
            }
        }
    }
    
    func isEmailVerified(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        user.reload { (error) in
            if let error = error {
                print("Error reloading user: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(user.isEmailVerified)
            }
        }
    }
    
    func loginUserWithEmailAndPassword(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error logging in user: \(error.localizedDescription)")
                completionBlock(false, error.localizedDescription)
            } else if let user = authResult?.user {
                print("User logged in: \(user)")
                completionBlock(true, nil)
            } else {
                completionBlock(false, "Unknown error")
            }
        }
    }
}
