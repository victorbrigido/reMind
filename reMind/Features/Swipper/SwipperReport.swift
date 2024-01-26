//
//  SwipperReport.swift
//  reMind
//
//  Created by Victor Brigido on 30/11/23.
//

import SwiftUI
import CoreData

struct SwipperReport: View {
    
    @Environment(\.presentationMode) var presentationMode
    var box: Box
    
    @Binding var termMovedLeft: Bool
    @Binding var termMovedRight: Bool
    @Binding var draggedTermIndex: Int?
    
    

    
    
    var body: some View {
        VStack {
            Text("Swipper Report")
                .fontWeight(.bold)
                .padding(10)
            Text("5/10 terms were reviewed")
            SwipperList(termMovedLeft: $termMovedLeft,
                        termMovedRight: $termMovedRight,
                        draggedTermIndex: $draggedTermIndex,
                        box: box)// aqui
                .padding(.top)
            Spacer()
            
            Button(action: {
                closeReport()
                print("Close report")
            }, label: {
                Text("Close Report")
                    .foregroundColor(Color(.selection))
                    .frame(maxWidth: .infinity, alignment: .center)
            })
            .buttonStyle(reButtonStyle())
            .padding(.bottom, 30)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(reBackground())
        }
        
    private func closeReport() {
        presentationMode.wrappedValue.dismiss()
        }
}

#Preview {
    SwipperReport(box: Box(), 
                  termMovedLeft: .constant(false),
                  termMovedRight: .constant(false), 
                  draggedTermIndex: Binding<Int?>(
                                        get: { 0 },
                                        set: { _ in }
                                    ))
                    
}


