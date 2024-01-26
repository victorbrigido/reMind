//
//  BoxView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI
import CoreData



struct BoxView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isTermEditorViewPresented = false
    @State private var searchText: String = ""
    @State private var showingDeleteAlert = false
    @State private var showingActionSheet = false
    @State private var isEditingBox = false
    
    @State private var selectedTerm: Term? // Adicione um estado para armazenar o termo selecionado
        
    
    var box: Box
    
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Term.value, ascending: true)],
            animation: .default)
        private var terms: FetchedResults<Term>

    
    
    private var filteredTerms: [Term] {
        guard let boxTerms = box.terms as? Set<Term> else {
            return []
        }
        
        let sortedTerms = Array(boxTerms).sorted { lhs, rhs in
            (lhs.value ?? "") < (rhs.value ?? "")
        }
        
        if searchText.isEmpty {
            return sortedTerms
        } else {
            return sortedTerms.filter { ($0.value ?? "").contains(searchText) }
        }
    }

    
    
    
    var body: some View {
        let listContent =
        List {  
                          
            TodaysCardsView(numberOfPendingCards: box.numberOfTerms,
                            theme: box.theme,
                            box: box)
                                .padding()

            Section(header:
                        Text("All Cards")
                .textCase(.none)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Palette.label.render)
                .padding(.leading, 0)
                .padding(.bottom, 16)
            ) {
                ForEach(filteredTerms, id: \.identifier) { term in
                    Text(term.value ?? "Unknown")
                        .padding(.vertical, 8)
                        .fontWeight(.bold)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                term.deleteTerm(context: box.managedObjectContext ?? CoreDataStack.inMemory.managedContext)
                                print("delete")
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                            Button(role: .none) {
                                isTermEditorViewPresented = true
                                selectedTerm = term
                                print("editTerm")
                    
                            } label: {
                                Image(systemName: "pencil")
                            }
                        }
                }
            }
            .onAppear {
                // Chama a função para carregar os termos
                _ = box.fetchTerms()
                print("Fetching terms")
            }
        }
        
        
        
            listContent
                .scrollContentBackground(.hidden)
                .background(reBackground())
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(box.name ?? "Unknown")
                .searchable(text: $searchText, prompt: "")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            showingActionSheet = true
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        .actionSheet(isPresented: $showingActionSheet) {
                            ActionSheet(title: Text("Box Options"), buttons: [
                                .default(Text("Edit Box")) {
                                    //lógica para editar a Box
                                    isEditingBox = true
                                    print("Edit Box tapped")
                                },
                                .destructive(Text("Remove Box")) {
                                    //lógica para remover a Box
                                    showingDeleteAlert = true
                                },
                                .cancel()
                            ])
                        }
                        .sheet(isPresented: $isEditingBox) {
                            BoxEditorView(
                                isPresented: $isEditingBox,
                                name: box.name ?? "",
                                keywords: "",
                                description: "",
                                theme: Int(box.rawTheme),
                                onCancel: {
                                    isEditingBox = false
                                },
                                box: box
                            )
                            .environment(\.managedObjectContext, box.managedObjectContext ?? CoreDataStack.inMemory.managedContext)
                        }
                    
            
                        .alert(isPresented: $showingDeleteAlert) {
                            Alert(
                                title: Text("Confirm Removal"),
                                message: Text("Are you sure you want to remove this box? This action cannot be undone."),
                                primaryButton: .destructive(Text("Remove")) {
                                    box.deleteBox()
                                    presentationMode.wrappedValue.dismiss()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    
                        
                        Button(action: {
                            self.isTermEditorViewPresented = true
                            print("Adding term to box: \(box.name ?? "Unknown")")
                            
                        }) {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $isTermEditorViewPresented) {
                            TermEditorView(
                                isPresented: $isTermEditorViewPresented,
                                term: selectedTerm?.value ?? "",
                                meaning: selectedTerm?.meaning ?? "",
                                editingTerm: selectedTerm,
                                box: box,
                                onCancel: {
                                    selectedTerm = nil
                                    isTermEditorViewPresented = false
                                }
                                
                            )
                            .environment(\.managedObjectContext, box.managedObjectContext ?? CoreDataStack.inMemory.managedContext)
                            .navigationBarHidden(true)
                        }
                   
                    }
                }
            }
        
        }



struct BoxView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.inMemory.managedContext
        
        let box = Box(context: context)
        box.name = "Box 1"
        box.rawTheme = 0
        
        let term1 = Term(context: context)
        term1.value = "Term 1"
        
        let term2 = Term(context: context)
        term2.value = "Term 2"
        
        let term3 = Term(context: context)
        term3.value = "Term 3"
        
        box.addToTerms(term1)
        box.addToTerms(term2)
        box.addToTerms(term3)
        
        return NavigationView {
            BoxView(box: box)
        }
    }
}

