//
//  DetailView.swift
//  Day54_BookWormApp
//
//  Created by Griffin Davidson on 11/7/20.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(10)
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown Author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text("Saved on \(self.book.date ?? Date().addingTimeInterval(0), style: .date)")
                    .font(.caption)
                
                Text(self.book.review ?? "No Review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("You are about to delete \"\(self.book.title ?? "a book")\".\nAre you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
            }, secondaryButton: .cancel())
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    
    func deleteBook() {
        moc.delete(book)
        
        try? self.moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test Title"
        book.author = "Test Author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Great book; really enjoyed it"
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
