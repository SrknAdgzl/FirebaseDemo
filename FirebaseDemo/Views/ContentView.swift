//
//  ContentView.swift
//  FirebaseDemo
//
//  Created by Serkan ADIGÜZEL on 27.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
    
    @State var name = ""
    @State var notes = ""
    var body: some View {
        VStack {
            List (model.list) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    
                    // update button
                    Button(action: {
                        
                        //delete todo
                        model.updateData(todoToUpdate: item)
                    }, label: {
                        Image(systemName: "pencil")
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
                    // delete button
                    Button(action: {
                        
                        //delete todo
                        model.deleteData(todoToDelete: item)
                    }, label: {
                        Image(systemName: "minus.circle")
                    })
                }
            }
            
            Divider()
            
            VStack(spacing: 5) {
                TextField("name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("notes", text: $notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    
                    // call add data
                    model.addData(name: name, notes: notes)
                    
                    // clear the text fields
                    name = ""
                    notes = ""
                    
                }, label: {
                    Text("Add Todo Item")
                })
            }
            .padding()
        }
    }
    
    init() {
        model.getData()
    }
}

#Preview {
    ContentView()
}
