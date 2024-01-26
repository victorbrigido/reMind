//
//  TermEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 30/06/23.
//

import SwiftUI


struct TermEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isPresented: Bool
    @State  var term: String
    @State  var meaning: String

    
    var editingTerm: Term?
    var box: Box
    var onCancel: () -> Void

    @State var showAlert = false
    
    
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                reTextField(title: "Term", text: $term)
                reTextEditor(title: "Meaning", text: $meaning)
                
                Spacer()
                
                Button(action: {
                    if let editingTerm = editingTerm {
                        // Edite o termo existente
                        editingTerm.editTerm(value: term,
                                             meaning: meaning,
                                             termID: editingTerm.identifier ?? UUID(),
                                             context: box.managedObjectContext ?? CoreDataStack.inMemory.managedContext)
                        showAlert = true
                        dismissView()
                        onCancel()
                    } else {
                        // Crie um novo termo
                        let newTerm = Term(context: box.managedObjectContext ?? CoreDataStack.inMemory.managedContext)
                        newTerm.saveTerm(value: term,
                                         meaning: meaning,
                                         box: box,
                                         context: box.managedObjectContext ?? CoreDataStack.inMemory.managedContext)
                        showAlert = true
                        
                    }
                    onCancel()
                    dismissView()
                }, label: {
                    
                    
                    Text(editingTerm != nil ? "Save Changes" : "Save and Add New")
                        .foregroundColor(Color(.selection))
                        .frame(maxWidth: .infinity, alignment: .center)
                })
                .buttonStyle(reButtonStyle())
            }
            
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sucess"), message: Text("The term was saved successfully"), dismissButton: .default(Text("OK")))
            }
            .background(reBackground())
            .navigationTitle(editingTerm != nil ? "Edit Term": "New Term")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        print("cancel")
                        term = "" // Limpa o term
                        meaning = "" // Limpa o meaning
                        onCancel()
                        dismissView()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {                    
                        let newTerm = Term(context: box.managedObjectContext ?? CoreDataStack.inMemory.managedContext)
                        newTerm.saveTerm(value: term,
                                         meaning: meaning,
                                         box: box,
                                         context: box.managedObjectContext ?? CoreDataStack.inMemory.managedContext)

                            term = ""
                            meaning = ""
                            showAlert = true
                            onCancel()
                            dismissView()

                            print("Save")
                        
                    }
                    .fontWeight(.bold)
                }
                
            }
            
        }
    }
    
    
    
    private func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    
    
    

}



struct TermEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TermEditorView(
            isPresented: .constant(false),
            term: "",
            meaning: "",
            box: Box(),
            onCancel: {}
        )
    }
}



