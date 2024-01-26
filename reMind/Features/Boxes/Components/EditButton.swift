//
//  EditButton.swift
//  reMind
//
//  Created by Victor Brigido on 24/01/24.
//

import SwiftUI

struct EditButton: View {
    var body: some View {
        List {
            Button(action: {
                // Ação para a opção "EditBox"
                print("EditBox option tapped")
            }) {
                HStack {
                    Text("EditBox")
                    Spacer()
                    Image(systemName: "square.and.pencil")
                }
                .padding(6)
            }

            Button(action: {
                // Ação para a opção "RemoveBox"
                print("RemoveBox option tapped")
            }) {
                HStack {
                    Text("RemoveBox")
                    Spacer()
                    Image(systemName: "trash")
                }
                .padding(6)
            }
        }
//        .listStyle(PlainListStyle())
        .frame(maxWidth: 250, maxHeight: 150)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EditButton()
    }
}
