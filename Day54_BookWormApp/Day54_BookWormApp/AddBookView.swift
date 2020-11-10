//
//  AddBookView.swift
//  Day54_BookWormApp
//
//  Created by Griffin Davidson on 11/6/20.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 2
    @State private var genre = 0
    @State private var review = ""
    var date = Date()
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Book Name", text: $title)
                    TextField("Author's Name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres.indices, id: \.self) {
                            Text(genres[$0])
                        }
                    }
                }
                
                Section {
                    
//                    Picker("Rating", selection: $rating) {
//                        ForEach(1..<6) {
//                            Text("\($0)")
//                        }
//                    }
// My Personal Favorite Rating system:
//                    Stepper(value: $rating, in: 1...5, step: 1) {
//                        Text("Rating: \(rating)")
//                    }
                    HStack {
                        Spacer()
                        RatingView(rating: $rating)
                        Spacer()
                    }
                    
                    TextField("Writer Review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: self.moc)
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genres[genre]
                        newBook.review = self.review
                        newBook.date = self.date
                        
                        try? self.moc.save()
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add Book", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
