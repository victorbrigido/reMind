//
//  TodaysCardsView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI

struct TodaysCardsView: View {
    @State var numberOfPendingCards: Int
    @State var theme: reTheme
    @State private var isSwipperViewPresented = false

    @StateObject var box: Box
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Cards")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("\(numberOfPendingCards) cards to review")
                    .font(.title3)
                
                Button(action: {
                    isSwipperViewPresented = true
                    print("swippe time!")

                }, label: {
                    Text("Start Swipping")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(reColorButtonStyle(theme))
                .padding(.top, 10)
            }
            .padding(.vertical, 16)
            
            
            NavigationLink(destination: SwipperView(box:box,
                                                    termsToReview: [],
                                                    review: SwipeReview(termsToReview: [])),
                           isActive: $isSwipperViewPresented) {
                EmptyView()
            }
                           .hidden()
        }

    }
}
struct TodaysCardsView_Previews: PreviewProvider {
        static var previews: some View {
            TodaysCardsView(numberOfPendingCards: 10,
                            theme: .mauve,
                            box: Box()
                            )
        .padding()
    }
}
    
