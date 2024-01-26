//
//  BoxEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 29/06/23.
//

import SwiftUI

struct BoxEditorView: View {
    @Binding var isPresented: Bool
    @State var name: String
    @State var keywords: String
    @State var description: String
    @State var theme: Int
    
    var onCancel: () -> Void // Closure para limpar campos
    var box: Box?
    
    var isEditingBox: Bool {
            return box != nil
        }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                reTextField(title: "Name", text: $name)
                reTextField(title: "Keywords",
                            caption: "Separated by , (comma)",
                            text: $keywords)
                
                reTextEditor(title: "Description",
                             text: $description)
                
                reRadioButtonGroup(title: "Theme",
                                   currentSelection: $theme)
                Spacer()
                
                
                
            }
            .padding()
            .background(reBackground())
            .navigationTitle(isEditingBox ? "Edit Box" : "New Box")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Save") {
                                        if isEditingBox {
                                            // Editar a box existente
                                            box?.editBox(
                                                    name: name,
                                                    theme: theme,
                                                    context: CoreDataStack.shared.managedContext
                                                        )
                                            print("Edit Box tapped")
                                        } else {
                                            // Criar uma nova box
                                            Box.createBox(
                                                name: name,
                                                theme: theme,
                                                context: CoreDataStack.shared.managedContext
                                            )
                                            print("SaveBox")
                                        }
                                        isPresented = false
                                    }
                                    .fontWeight(.bold)
                                }
            }
        }
    }
      
}

struct BoxEditorView_Previews: PreviewProvider {
    static var previews: some View {
        BoxEditorView(
                    isPresented: .constant(false),
                    name: "",
                    keywords: "",
                    description: "",
                    theme: 0,
                    onCancel: {})
    }
}
