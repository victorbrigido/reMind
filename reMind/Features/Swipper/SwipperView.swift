//
//  SwipperView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI

struct SwipperView: View {
    @ObservedObject var box: Box
    @State private var currentIndex = 0
    @State private var isReviewFinished = false
    @State private var isSwipperReportPresented = false
    
    @State private var termMovedLeft = false//alteracao de cor
    @State private var termMovedRight = false//aletaracao de cor
    
    @State private var draggedTermIndex: Int?
    
    
    @State private var movedRightCount = 0
    
    @State var termsToReview: [Term]
    @State var review: SwipeReview
    @State private var direction: SwipperDirection = .none
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Term.entity(), sortDescriptors: [], predicate: nil)
    private var terms: FetchedResults<Term>
    
    
    
    var body: some View {
        VStack {
            SwipperLabel(direction: $direction)
                .padding()
            
            Spacer()
            
            if let term = box.fetchTerms().indices.contains(currentIndex) ? box.fetchTerms()[currentIndex] : nil {
                
                SwipperCard(direction: $direction,
                            frontContent: {
                    Text(term.value ?? "")
                        .foregroundColor(.black)
                }, backContent: {
                    Text(term.meaning ?? "")
                        .foregroundColor(.black)
                }, term: term,//apagar o term
                    termMovedLeft: termMovedLeft,
                    termMovedRight: termMovedRight,
                    onRightSwipe: { term in
                    moveToRightTerm(term: term)
                    termMovedRight = true
                },
                    onLeftSwipe: { term in
                    moveToLeftTerm (term: term)
                    termMovedLeft = true //aqui
                },cardColor: box.theme.render,
                            box: Box()
                ) // Passando o binding para o índice arrastado
                
            }
            
            Spacer()
            
            if isReviewFinished {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                    .padding(.bottom, -10)
                // Mostra a mensagem quando a revisão está concluída
                Text("Finish terms!")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding()
                
                Spacer()
                
            }
            
            Button(action: {
                finishReview(reviewCount: movedRightCount)
                print("finish review")
            }, label: {
                Text("Finish Review")
                    .foregroundColor(Color(.selection))
                    .frame(maxWidth: .infinity, alignment: .center)
            })
            .buttonStyle(reButtonStyle())
            .padding(.bottom, 30)
            
            
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(reBackground())
        .navigationTitle("\(review.termsToReview.count) terms left")
        .navigationBarTitleDisplayMode(.inline)
        
        .fullScreenCover(isPresented: $isSwipperReportPresented) {
            SwipperReport(box: box, 
                          termMovedLeft: $termMovedLeft,
                          termMovedRight: $termMovedRight,
                          draggedTermIndex: $draggedTermIndex)
                }

    }
    

    private func moveToLeftTerm(term: Term) {
        draggedTermIndex = (draggedTermIndex ?? -1) + 1 // Se draggedTermIndex for nil, começamos com -1

        if let currentIndex = draggedTermIndex, currentIndex < box.fetchTerms().count {
            let currentTerm = box.fetchTerms()[currentIndex]
            review.termsToReview.append(currentTerm)
            self.currentIndex += 1

            if currentIndex == box.fetchTerms().count - 1 {
                isReviewFinished = true
            }
        }
    }

    private func moveToRightTerm(term: Term) {
        draggedTermIndex = (draggedTermIndex ?? -1) + 1 // Se draggedTermIndex for nil, começamos com -1

        if let index = draggedTermIndex, index < box.fetchTerms().count {
            //contador de termos arrastados para a direita
            movedRightCount += 1
            currentIndex += 1
        }

        checkReviewFinished()
    }

    private func checkReviewFinished() {
        if currentIndex >= box.fetchTerms().count {
            isReviewFinished = true
        }
    }

    
    
    private func finishReview(reviewCount: Int) {
            // Lógica para finalizar a revisão
            
            // Abra a tela SwipperReport
            isSwipperReportPresented = true
        }

}



struct SwipperView_Previews: PreviewProvider {
    static let term: Term = {
        let term = Term(context: CoreDataStack.inMemory.managedContext)
        term.value = "Term"
        term.meaning = "Meaning"
        term.rawSRS = 0
        term.rawTheme = 0
        

        return term
    }()
    
    static var previews: some View {
        NavigationStack {
            SwipperView( box: Box(),
                         termsToReview: [term],
                         review: SwipeReview(termsToReview: [])
        )}
    }
}

