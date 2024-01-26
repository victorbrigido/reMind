//
//  EditBox.swift
//  reMind
//
//  Created by Victor Brigido on 13/01/24.
//

    
import SwiftUI

struct EditBoxButton: View {
    @State private var isDisclosureGroupOpen = false

    var body: some View {
        VStack {
            Button(action: {
                isDisclosureGroupOpen.toggle()
            }) {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .frame(maxWidth: 10, maxHeight: 10)
                }
                .padding()
                .foregroundColor(.black)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
            }
            .font(.system(size: 35))
            
            if isDisclosureGroupOpen {
                DisclosureGroup("", isExpanded: $isDisclosureGroupOpen) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Editar")
                            Image(systemName: "pencil")
                                .padding(.leading, 25)
                                .foregroundColor(.black)
                        }
                        Divider().background(Color.gray)

                        HStack {
                            Text("Excluir")
                            Image(systemName: "trash")
                                .padding(.leading)
                                .foregroundColor(.red)
                        }
                    }
                }
                .background(Color(UIColor.systemBackground))
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            }
            
        }
    }
}

struct EditBoxButton_Previews: PreviewProvider {
    static var previews: some View {
        EditBoxButton()
    }
}
