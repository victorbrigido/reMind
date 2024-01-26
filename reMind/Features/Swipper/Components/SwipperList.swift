//
//  SwipperList.swift
//  reMind
//
//  Created by Victor Brigido on 11/01/24.
//


import SwiftUI

struct SwipperList: View {
    
    @Binding var termMovedLeft: Bool
    @Binding var termMovedRight: Bool
    
    @State private var isTermExpanded: [UUID: Bool] = [:]
    @State private var termColors: [UUID: Color] = [:] // Novo estado para armazenar as cores
    
    @Binding var draggedTermIndex: Int?
    
    var box: Box
    
    
    
    var body: some View {
        List {
            ForEach(Array(box.fetchTerms().enumerated()), id: \.element.identifier) { index, term in
                let color: Color = {
                    if let draggedIndex = draggedTermIndex {
                        if index == draggedIndex && termMovedLeft {
                return Palette.error.render
                        } else if index == draggedIndex && termMovedRight {
                return Palette.success.render
                        }
                    }
                return Palette.background.render
                }()
                
                DisclosureGroup(isExpanded: Binding(
                    get: { isTermExpanded[term.identifier ?? UUID()] ?? false },
                    set: { isTermExpanded[term.identifier ?? UUID()] = $0 }
                )) {
                    if let meaning = term.meaning {
                        Text("Meaning: \(meaning)")
                            .padding(.top, -50)
                            .padding(.horizontal, -20)
                            .frame(height: 100)
                            .foregroundColor(.black)
                    }
                } label: {
                    if termMovedLeft {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.black)
                        
                    } else if termMovedRight {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.black)
                    }
                    Text(term.value ?? "")
                        .bold()
                        .padding(.leading, 0)
                        .frame(height: 40)
                        .foregroundColor(.black)
                    Spacer()
                }
                .listRowBackground(color)
                .onTapGesture {
                    withAnimation {
                        isTermExpanded[term.identifier ?? UUID()]?.toggle()
                    }
                }
                .accentColor(.black)
            }
        }
        .listStyle(InsetListStyle())
        .frame(height: 250)
        .cornerRadius(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .onChange(of: draggedTermIndex) { newIndex in
            // Atualizar a cor quando o índice arrastado muda
            if let newIndex = newIndex {
                let currentTerm = box.fetchTerms()[newIndex]
                termColors[currentTerm.identifier ?? UUID()] = termMovedLeft ? Palette.error.render : (termMovedRight ? Palette.success.render : Palette.background.render)
            }
        }
    }
}
    struct SwipperList_Previews: PreviewProvider {
        static var previews: some View {
            SwipperList(
                        termMovedLeft: .constant(true),
                        termMovedRight: .constant(false),
                        draggedTermIndex: .constant(nil),
                        box: Box())
        }
    }




