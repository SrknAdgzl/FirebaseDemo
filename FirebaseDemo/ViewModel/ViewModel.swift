//
//  ViewModel.swift
//  FirebaseDemo
//
//  Created by Serkan ADIGÜZEL on 27.10.2023.
//

import Foundation
import Firebase

class ViewModel: ObservableObject {
    @Published var list = [Todo]()
    
    func updateData(todoToUpdate: Todo) {
        // get a reference to the database
        let db = Firestore.firestore()
        
        // set the data to update
        db.collection("todos").document(todoToUpdate.id).setData(["name": "updated todo merge"], merge: true) { error in
        // Check for error
            if error == nil {
                self.getData()
            }
        }
    }
    
    func deleteData(todoToDelete: Todo) {
        
        // get a reference to the database
        let db = Firestore.firestore()
        
        // specify the document to delete
        db.collection("todos").document(todoToDelete.id).delete { error in
            
            // check for errors
            
            if error == nil {
                // no errors
                
                //update the ui from the main thread
                
                DispatchQueue.main.async {
                    // remove todo that was just deleted
                    self.list.removeAll { todo in
                        
                        // check for the todo to remove
                        return todo.id == todoToDelete.id
                    }
                }
            }
        }
    }
    
    func addData(name: String, notes: String) {
        // get a reference to the database
        let db = Firestore.firestore()
        // add a documents at a specific path
        db.collection("todos").addDocument(data: ["name":name, "notes":notes]) { error in
            // check for error
            if error == nil {
                //no error
                
                //call get data to retrieve latest data
                self.getData()
            } else {
                //handle the error
            }
        }
    }
    
    func getData() {
        // get a reference to the database
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("todos").getDocuments { snapshot, error in
            
            // check for error
            if error == nil {
                //no errors
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async {
                        //get all the documents
                        self.list = snapshot.documents.map { d in
                            return Todo(id: d.documentID,
                                        name: d["name"] as? String ?? "",
                                        notes: d["notes"] as? String ?? "")
                        }
                    }
                    
                }
            }
        }
        
    }
    
}
