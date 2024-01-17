////
//ContentView.swift
//StoreCheckout
//
//Created by Basel Baragabah on 04/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI
import FXSwipeAction

struct ContentView: View {
    
    struct NoteItem: Identifiable {
        let id = UUID()
        var note: LocalizedStringKey
        var creationDate: LocalizedStringKey
        var isComplete: Bool
    }
    
    @State var notesArray: [NoteItem] = [
        NoteItem(note: "Discuss budget constraints", creationDate: "22 Jan 2023", isComplete: false),
        NoteItem(note: "Assign tasks for next week", creationDate: "23 Jan 2023", isComplete: false),
        NoteItem(note: "Discuss budget UI/UX Des..", creationDate: "25 Feb 2023", isComplete: false),
        NoteItem(note: "John proposed moving the..", creationDate: "28 Apr 2023", isComplete: false)
    ]
    
    
    var body: some View {
        
        SwipeViewGroup {
            
            NavigationStack {
                
                ZStack {
                    
                    Color(.systemGray6).ignoresSafeArea()
                    
                    VStack {
                        
                        List($notesArray) { $item in
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.note)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .strikethrough(item.isComplete, color: .black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                                
                                Text(item.creationDate)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                                
                            }
                            
                            .swipeActions(
                                leading:
                                    SwipeActionButton(
                                        iconType: !item.isComplete ? .system("checkmark.circle.fill") :
                                                .system("xmark.circle.fill")
                                        ,
                                        type: .leading,
                                        action: {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                item.isComplete = !item.isComplete ? true : false
                                                sortNotes()
                                            }
                                            
                                        }, tint: !item.isComplete ? .green : .orange),
                                
                                trailing:
                                    SwipeActionButton(
                                        iconType:.system("trash.fill"),
                                        type: .trailing,
                                        action: {
                                            withAnimation {
                                                if let index = notesArray.firstIndex(where: { $0.id == item.id }) {
                                                    notesArray.remove(at: index)
                                                }
                                            }
                                        }, tint: .red)
                                
                            )
                            .swipeActionsStyle(
                                main: .init(cornerRadius: 20, swipeSpacing: 0, padding: 12),
                                shadow: .init(shadowColor: .gray.opacity(0.2), shadowRadius: 8, shadowOffset: CGSize(width: 0, height: 10)),
                                style: .init(backgroundColor: .white))
                            
                            
                            .frame(height: 80)
                            
                        }
                        .listStyle(.plain)
                        .listRowSpacing(-10)
                        
                    }
                    .navigationTitle("Reminders")
                    
                }
            }
        }
        
    }
    
    private func sortNotes() {
        let sortedArray = notesArray.sorted {
            if $0.isComplete == $1.isComplete {
                return true // If both items have the same completion status, we don't change their order
            } else {
                return !$0.isComplete // Items not complete should come first
            }
        }
        notesArray = sortedArray
    }
    
}

#Preview {
    ContentView()
}
