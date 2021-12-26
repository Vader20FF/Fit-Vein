//
//  FirestoreManager.swift
//  Fit Vein
//
//  Created by Łukasz Janiszewski on 13/10/2021.
//

import Foundation
import Firebase
import SwiftUI
import grpc

class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    func getDatabase() -> Firestore {
        self.db
    }
    
    
    
    // Registration
    
    func signUpDataCreation(id: String, firstName: String, username: String, birthDate: Date, country: String, language: String, email: String, gender: String, completion: @escaping ((Profile) -> ())) {
        let documentData: [String: Any] = [
            "id": id,
            "firstName": firstName,
            "username": username,
            "birthDate": birthDate,
            "age": yearsBetweenDate(startDate: birthDate, endDate: Date()) == 0 ? 18 : yearsBetweenDate(startDate: birthDate, endDate: Date()),
            "country": country,
            "language": language,
            "email": email,
            "gender": gender,
            "followedIDs": [String](),
            "reactedPostsIDs": [String](),
            "commentedPostsIDs": [String]()
        ]
        
        self.db.collection("users").document(id).setData(documentData) { (error) in
            if let error = error {
                print("Error creating user's data: \(error.localizedDescription)")
            } else {
                print("Successfully created data for user: \(username) identifying with id: \(id) in database")
                completion(Profile(id: id, firstName: firstName, username: username, birthDate: birthDate, age: yearsBetweenDate(startDate: birthDate, endDate: Date()) == 0 ? 18 : yearsBetweenDate(startDate: birthDate, endDate: Date()), country: country,
                                   language: language, gender: gender, email: email, profilePictureURL: nil, followedIDs: nil, reactedPostsIDs: nil, commentedPostsIDs: nil))
            }
        }
    }
    
    func checkUsernameDuplicate(username: String) async throws -> Bool {
        let querySnapshot = try await self.db.collection("users").whereField("username", isEqualTo: username).getDocuments()
        
        if querySnapshot.documents.count != 0 {
            return true
        } else {
            return false
        }
    }
    
    func checkEmailDuplicate(email: String) async throws -> Bool {
        let querySnapshot = try await self.db.collection("users").whereField("email", isEqualTo: email).getDocuments()
        
        if querySnapshot.documents.count != 0 {
            return true
        } else {
            return false
        }
    }
    
    
    
    // User
    
    func fetchDataForProfileViewModel(userID: String, completion: @escaping ((Profile?) -> ())) {
        self.db.collection("users").whereField("id", isEqualTo: userID).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching profile data: \(error.localizedDescription)")
            } else {
                let profile = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Profile in
                    let data = queryDocumentSnapshot.data()

                    let firstName = data["firstName"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    let birthDate = data["birthDate"] as? Date ?? Date()
                    let age = data["age"] as? Int ?? 0
                    let country = data["country"] as? String ?? ""
                    let language = data["language"] as? String ?? ""
                    let gender = data["gender"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let profilePictureURL = data["profilePictureURL"] as? String ?? nil
                    let followedIDs = data["followedUsers"] as? [String]? ?? nil
                    let reactedPostsIDs = data["reactedPostsIDs"] as? [String]? ?? nil
                    let commentedPostsIDs = data["commentedPostsIDs"] as? [String]? ?? nil

                    return Profile(id: userID, firstName: firstName, username: username, birthDate: birthDate, age: age, country: country, language: language, gender: gender, email: email, profilePictureURL: profilePictureURL, followedIDs: followedIDs, reactedPostsIDs: reactedPostsIDs, commentedPostsIDs: commentedPostsIDs)
                }
                
                DispatchQueue.main.async {
                    if profile.count != 0 {
                        completion(profile[0])
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func addProfilePictureURLToUsersData(photoURL: String, completion: @escaping (() -> ())) {
        let documentData: [String: Any] = [
            "profilePictureURL": photoURL
        ]
        
        updateUserData(documentData: documentData) {
            print("Successfully added new profile picture URL to database.")
            completion()
        }
    }
    
    func editUserEmailInDatabase(email: String, completion: @escaping (() -> ())) {
        let documentData: [String: Any] = [
            "email": email
        ]
        
        updateUserData(documentData: documentData) {
            print("Successfully updated user's email in database.")
            completion()
        }
    }
    
    func deleteUserData(userUID: String, completion: @escaping (() -> ())) {
        self.db.collection("users").document(userUID).delete() { (error) in
            if let error = error {
                print("Could not delete user data: \(error)")
            } else {
                completion()
            }
        }
    }
    
    func addReactedPostID(userID: String, postID: String, completion: @escaping (() -> ())) {
        self.db.collection("users").document(userID).getDocument() { [self] (document, error) in
            if let error = error {
                print("Error getting document for adding reacted post for user: \(error.localizedDescription)")
            } else {
                if let document = document {
                    let reactedPostsIDs = document.get("reactedPostsIDs") as? [String]? ?? nil
                    
                    if let reactedPostsIDs = reactedPostsIDs {
                        var newReactionsPostsIDs = reactedPostsIDs
                        newReactionsPostsIDs.append(postID)
                        
                        let documentData: [String: Any] = [
                            "reactedPostsIDs": newReactionsPostsIDs
                        ]
                        updateUserData(documentData: documentData) {
                            print("Successfully added post \(postID) to user reacted")
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func addCommentedPostID(userID: String, postID: String, completion: @escaping (() -> ())) {
        self.db.collection("users").document(userID).getDocument() { [self] (document, error) in
            if let error = error {
                print("Error getting document for adding commented post for user: \(error.localizedDescription)")
            } else {
                if let document = document {
                    let commentedPostsIDs = document.get("commentedPostsIDs") as? [String]? ?? nil
                    
                    if let commentedPostsIDs = commentedPostsIDs {
                        var newCommentedPostsIDs = commentedPostsIDs
                        newCommentedPostsIDs.append(postID)
                        
                        let documentData: [String: Any] = [
                            "commentedPostsIDs": newCommentedPostsIDs
                        ]
                        updateUserData(documentData: documentData) {
                            print("Successfully added post \(postID) to user commented")
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    
    
    // Followed
    
    func fetchFollowed(userID: String, completion: @escaping (([String]?) -> ())) {
        self.db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching followed users data: \(error.localizedDescription)")
            } else {
                if let document = document {
                    let followedUsers = document.get("followedUsers") as? [String] ?? nil
                    completion(followedUsers)
                }
            }
        }
    }
    
    func addUserToFollowed(userID: String, userIDToFollow: String, completion: @escaping (() -> ())) {
        self.fetchFollowed(userID: userID) { [self] fetchedFollowed in
            if let fetchedFollowed = fetchedFollowed {
                var fetchedFollowedToBeModified = fetchedFollowed
                fetchedFollowedToBeModified.append(userIDToFollow)
                let documentData: [String: Any] = [
                    "followedUsers": fetchedFollowedToBeModified
                ]
                updateUserData(documentData: documentData) {
                    print("Successfully updated followed users for the user \(userID)")
                    completion()
                }
            } else {
                let documentData: [String: Any] = [
                    "followedUsers": [userIDToFollow]
                ]
                updateUserData(documentData: documentData) {
                    print("Successfully added first followed user for the user \(userID)")
                    completion()
                }
            }
        }
    }
    
    func removeUserFromFollowed(userID: String, userIDToStopFollow: String, completion: @escaping (() -> ())) {
        self.fetchFollowed(userID: userID) { [self] fetchedFollowed in
            if let fetchedFollowed = fetchedFollowed {
                var fetchedFollowedToBeModified = fetchedFollowed
                for (index, fetchedFollowedUser) in fetchedFollowedToBeModified.enumerated() {
                    if fetchedFollowedUser == userIDToStopFollow {
                        fetchedFollowedToBeModified.remove(at: index)
                    }
                }
                fetchedFollowedToBeModified.sort() {
                    $0 < $1
                }
                let documentData: [String: Any] = [
                    "followedUsers": fetchedFollowedToBeModified
                ]
                updateUserData(documentData: documentData) {
                    print("Successfully removed user \(userIDToStopFollow) from user \(userID) followed users")
                    completion()
                }
            }
        }
    }
    
    
    
    // Posts
    
    func fetchPosts(userID: String, completion: @escaping (([Post]?) -> ())) {
        var fetchedPosts: [Post] = [Post]()

        self.fetchFollowed(userID: userID) { fetchedFollowed in
            var fetchedFollowedAndSelf = [String]()
            if fetchedFollowed == nil {
                fetchedFollowedAndSelf = [userID]
            } else {
                fetchedFollowedAndSelf = fetchedFollowed!
                fetchedFollowedAndSelf.append(userID)
            }
            print(fetchedFollowedAndSelf)
            self.db.collection("posts").whereField("authorID", in: fetchedFollowedAndSelf).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching posts data: \(error.localizedDescription)")
                } else {
                    fetchedPosts = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Post in
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? ""
                        let authorID = data["authorID"] as? String ?? ""
                        let authorFirstName = data["authorFirstName"] as? String ?? ""
                        let authorUsername = data["authorUsername"] as? String ?? ""
                        let authorProfilePictureURL = data["authorProfilePictureURL"] as? String ?? ""
                        let addDate = data["addDate"] as? Timestamp
                        let text = data["text"] as? String ?? ""
                        let reactionsUsersIDs = data["reactionsUsersIDs"] as? [String]? ?? nil

                        return Post(id: id, authorID: authorID, authorFirstName: authorFirstName, authorUsername: authorUsername, authorProfilePictureURL: authorProfilePictureURL, addDate: (addDate?.dateValue())!, text: text, reactionsUsersIDs: reactionsUsersIDs, comments: nil)
                    }
                    
                    DispatchQueue.main.async {
                        if fetchedPosts.count != 0 {
                            fetchedPosts.sort() {
                                $0.addDate > $1.addDate
                            }
                            completion(fetchedPosts)
                        } else {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func postDataCreation(id: String, authorID: String, authorFirstName: String, authorUsername: String, authorProfilePictureURL: String, addDate: Date, text: String, reactionsUsersIDs: [String]?, comments: [Comment]?, completion: @escaping (() -> ())) {
        let documentData: [String: Any] = [
            "id": id,
            "authorID": authorID,
            "authorFirstName": authorFirstName,
            "authorUsername": authorUsername,
            "authorProfilePictureURL": authorProfilePictureURL,
            "addDate": Date(),
            "text": text,
            "reactionsUsersIDs": reactionsUsersIDs as Any,
            "comments": comments as Any
        ]
        
        self.db.collection("posts").document(id).setData(documentData) { (error) in
            if let error = error {
                print("Error creating post's data: \(error.localizedDescription)")
            } else {
                print("Successfully created post: \(id) by user: \(authorID)")
            }
        }
    }
    
    func postRemoval(id: String, completion: @escaping (() -> ())) {
        self.db.collection("posts").document(id).delete() { (error) in
            if let error = error {
                print("Error deleting post: \(error.localizedDescription)")
            } else {
                print("Successfully deleted post: \(id)")
            }
        }
    }
    
    func postEdit(id: String, text: String, completion: @escaping (() -> ())) {
        let documentData: [String: Any] = [
            "text": text
        ]
        updatePostData(postID: id, documentData: documentData) {
            print("Successfully changed post \(id) data.")
            completion()
        }
    }
    
    func postAddReaction(id: String, userID: String, completion: @escaping (() -> ())) {
        var removedReaction = false
        
        self.db.collection("posts").document(id).getDocument() { [self] (document, error) in
            if let error = error {
                print("Error getting document for post add reaction: \(error.localizedDescription)")
            } else {
                if let document = document {
                    let reactionsUsersIDs = document.get("reactionsUsersIDs") as? [String]? ?? nil
                    
                    if let reactionsUsersIDs = reactionsUsersIDs {
                        var newReactionsUsersIDs = reactionsUsersIDs
                        if newReactionsUsersIDs.contains(userID) {
                            for (index, userID) in newReactionsUsersIDs.enumerated() {
                                if userID == userID {
                                    newReactionsUsersIDs.remove(at: index)
                                    removedReaction = true
                                    break
                                }
                            }
                        } else {
                            newReactionsUsersIDs.append(userID)
                        }
                        
                        let documentData: [String: Any] = [
                            "reactionsUsersIDs": newReactionsUsersIDs
                        ]
                        updatePostData(postID: id, documentData: documentData) {
                            print("Successfully added reaction of \(userID) to post \(id)")
                            completion()
                        }
                    } else {
                        let newReactionsUsersIDs = [userID]
                        
                        let documentData: [String: Any] = [
                            "reactionsUsersIDs": newReactionsUsersIDs
                        ]
                        updatePostData(postID: id, documentData: documentData) {
                            print(!removedReaction ? "Successfully added reaction of \(userID) to post \(id)" : "Successfully removed reaction of \(userID) to post \(id)")
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    
    
    // Comments
    
    func fetchComments(userID: String, postID: String, completion: @escaping (([Comment]?) -> ())) {
        var fetchedComments: [Comment] = [Comment]()

        self.db.collection("comments").whereField("postID", isEqualTo: postID).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching comments data: \(error.localizedDescription)")
            } else {
                fetchedComments = querySnapshot!.documents.map { (queryDocumentSnapshot) -> Comment in
                    let data = queryDocumentSnapshot.data()

                    let id = data["id"] as? String ?? ""
                    let authorID = data["authorID"] as? String ?? ""
                    let postID = data["postID"] as? String ?? ""
                    let authorFirstName = data["authorFirstName"] as? String ?? ""
                    let authorUsername = data["authorUsername"] as? String ?? ""
                    let authorProfilePictureURL = data["authorProfilePictureURL"] as? String ?? ""
                    let addDate = data["addDate"] as? Timestamp
                    let text = data["text"] as? String ?? ""
                    let reactionsUsersIDs = data["reactionsUsersIDs"] as? [String]? ?? nil

                    return Comment(id: id, authorID: authorID, postID: postID, authorFirstName: authorFirstName, authorUsername: authorUsername, authorProfilePictureURL: authorProfilePictureURL, addDate: (addDate?.dateValue())!, text: text, reactionsUsersIDs: reactionsUsersIDs)
                }
                
                DispatchQueue.main.async {
                    if fetchedComments.count != 0 {
                        fetchedComments.sort() {
                            $0.addDate > $1.addDate
                        }
                        completion(fetchedComments)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func commentDataCreation(id: String, authorID: String, postID: String, authorFirstName: String, authorUsername: String, authorProfilePictureURL: String, addDate: Date, text: String, reactionsUsersIDs: [String]?, completion: @escaping (() -> ())) {
        let documentData: [String: Any] = [
            "id": id,
            "authorID": authorID,
            "postID": postID,
            "authorFirstName": authorFirstName,
            "authorUsername": authorUsername,
            "authorProfilePictureURL": authorProfilePictureURL,
            "addDate": Date(),
            "text": text,
            "reactionsUsersIDs": reactionsUsersIDs as Any
        ]
        
        self.db.collection("comments").document(id).setData(documentData) { (error) in
            if let error = error {
                print("Error creating post's data: \(error.localizedDescription)")
            } else {
                print("Successfully created comment: \(id) by user: \(authorID)")
            }
        }
    }
    
    func commentRemoval(id: String, completion: @escaping (() -> ())) {
        self.db.collection("comments").document(id).delete() { (error) in
            if let error = error {
                print("Error deleting post: \(error.localizedDescription)")
            } else {
                print("Successfully deleted comment: \(id)")
            }
        }
    }
    
    func commentEdit(id: String, text: String, completion: @escaping (() -> ())) {
        let documentData: [String: Any] = [
            "text": text
        ]
        updateCommentData(commentID: id, documentData: documentData) {
            print("Successfully changed comment \(id) data.")
            completion()
        }
    }
    
    func commentAddReaction(id: String, userID: String, completion: @escaping (() -> ())) {
        var removedReaction = false
        
        self.db.collection("comments").document(id).getDocument() { [self] (document, error) in
            if let error = error {
                print("Error getting document for comment add reaction: \(error.localizedDescription)")
            } else {
                if let document = document {
                    let reactionsUsersIDs = document.get("reactionsUsersIDs") as? [String]? ?? nil
                    
                    if let reactionsUsersIDs = reactionsUsersIDs {
                        var newReactionsUsersIDs = reactionsUsersIDs
                        if newReactionsUsersIDs.contains(userID) {
                            for (index, userID) in newReactionsUsersIDs.enumerated() {
                                if userID == userID {
                                    newReactionsUsersIDs.remove(at: index)
                                    removedReaction = true
                                    break
                                }
                            }
                        } else {
                            newReactionsUsersIDs.append(userID)
                        }
                        
                        let documentData: [String: Any] = [
                            "reactionsUsersIDs": newReactionsUsersIDs
                        ]
                        updateCommentData(commentID: id, documentData: documentData) {
                            print("Successfully added reaction of \(userID) to comment \(id)")
                            completion()
                        }
                    } else {
                        let newReactionsUsersIDs = [userID]
                        
                        let documentData: [String: Any] = [
                            "reactionsUsersIDs": newReactionsUsersIDs
                        ]
                        updateCommentData(commentID: id, documentData: documentData) {
                            print(!removedReaction ? "Successfully added reaction of \(userID) to comment \(id)" : "Successfully removed reaction of \(userID) to comment \(id)")
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    
    
    //Workouts
    
    func fetchWorkouts(userID: String, completion: @escaping (([IntervalWorkout]?) -> ())) {
        var fetchedWorkouts: [IntervalWorkout] = [IntervalWorkout]()

        self.db.collection("workouts").whereField("usersID", isEqualTo: userID).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching workouts data: \(error.localizedDescription)")
            } else {
                fetchedWorkouts = querySnapshot!.documents.map { (queryDocumentSnapshot) -> IntervalWorkout in
                    let data = queryDocumentSnapshot.data()

                    let id = data["id"] as? String ?? ""
                    let usersID = data["usersID"] as? String ?? ""
                    let type = data["type"] as? String ?? ""
                    let date = data["date"] as? Timestamp
                    let isFinished = data["isFinished"] as? Bool ?? true
                    let calories = data["calories"] as? Int? ?? 0
                    let series = data["series"] as? Int? ?? 0
                    let workTime = data["workTime"] as? Int? ?? 0
                    let restTime = data["restTime"] as? Int? ?? 0
                    let completedDuration = data["completedDuration"] as? Int? ?? 0
                    let completedSeries = data["completedSeries"] as? Int? ?? 0

                    return IntervalWorkout(forPreviews: false, id: id, usersID: usersID, type: type, date: (date?.dateValue())!, isFinished: isFinished, calories: calories, series: series, workTime: workTime, restTime: restTime, completedDuration: completedDuration, completedSeries: completedSeries)
                }
                
                DispatchQueue.main.async {
                    if fetchedWorkouts.count != 0 {
                        fetchedWorkouts.sort() {
                            $0.date < $1.date
                        }
                        completion(fetchedWorkouts)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func workoutDataCreation(id: String, usersID: String, type: String, date: Date, isFinished: Bool, calories: Int?, series: Int?, workTime: Int?, restTime: Int?, completedDuration: Int?, completedSeries: Int?, completion: @escaping (() -> ())) {
        let documentData: [String: Any] = [
            "id": id,
            "usersID": usersID,
            "type": type,
            "date": date,
            "isFinished": isFinished,
            "calories": calories as Any,
            "series": series as Any,
            "workTime": workTime as Any,
            "restTime": restTime as Any,
            "completedDuration": completedDuration as Any,
            "completedSeries": completedSeries as Any,
        ]
        
        self.db.collection("workouts").document(id).setData(documentData) { (error) in
            if let error = error {
                print("Error creating workout's data: \(error.localizedDescription)")
            } else {
                print("Successfully created data for workout: \(id) finished by user: \(usersID)")
            }
        }
    }
    
    
    
    // Universal
    
    func getAllUsersIDs(userID: String, completion: @escaping (([String]?) -> ())) {
        self.db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents in 'users' collection: \(error.localizedDescription)")
            } else {
                var usersIDs = [String]()
                for document in querySnapshot!.documents {
                    let data = document.data()

                    let userID = data["id"] as? String ?? ""
                    usersIDs.append(userID)
                }
                
                for (index, userID) in usersIDs.enumerated() {
                    if userID == userID {
                        usersIDs.remove(at: index)
                        break
                    }
                }
                
                completion(usersIDs)
            }
        }
    }
    
    private func updateUserData(documentData: [String: Any], completion: @escaping (() -> ())) {
        self.db.collection("users").document(user!.uid).updateData(documentData) { (error) in
            if let error = error {
                print("Error updating user's data: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    private func updatePostData(postID: String, documentData: [String: Any], completion: @escaping (() -> ())) {
        self.db.collection("posts").document(postID).updateData(documentData) { (error) in
            if let error = error {
                print("Error updating post's data: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    private func updateCommentData(commentID: String, documentData: [String: Any], completion: @escaping (() -> ())) {
        self.db.collection("comments").document(commentID).updateData(documentData) { (error) in
            if let error = error {
                print("Error updating comment's data: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
}
