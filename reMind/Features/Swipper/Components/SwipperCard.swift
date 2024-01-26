//
//  SwipperCard.swift
//  reMind
//
//  Created by Pedro Sousa on 04/07/23.
//

import SwiftUI

struct SwipperCard<FrontContent: View, BackContent: View>: View {
    @Binding var direction: SwipperDirection

    @ViewBuilder var frontContent: () -> FrontContent
    @ViewBuilder var backContent: () -> BackContent
    
    var term: Term
    var termMovedLeft: Bool
    var termMovedRight: Bool
    
    
    
    var onRightSwipe: (Term) -> Void
    var onLeftSwipe: (Term) -> Void  
    var cardColor: Color // Adiciona a propriedade cardColor
    var box: Box
    var theme: reTheme = .lavender
    
    // Tap States
    @State private var isFlipped: Bool = false
    @State private var frontAngle = Angle(degrees: 0)
    @State private var backAngle = Angle(degrees: 90)
    
    // Drag States
    @State private var dragAmout: CGSize = .zero
    @State private var cardAngle: Angle = .zero
    
    private let duration: CGFloat = 0.18
    private let screenSize = UIScreen.main.bounds.size
    private let axis: (CGFloat, CGFloat, CGFloat) = (0, 1, 0)
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(cardColor)
                backContent()
            }
            .rotation3DEffect(backAngle, axis: axis)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(cardColor)
                frontContent()
            }
            .rotation3DEffect(frontAngle, axis: axis)
            
        }
        .background(reBackground()) //verificar
        .frame(width: screenSize.width - 60, height: 404)
        .offset(dragAmout)
        .rotationEffect(cardAngle)
        .onTapGesture(perform: flip)
        .gesture(
            DragGesture()
                .onChanged(dragDidChange)
                .onEnded(dragDidEnd)
                )
            }
    
    private func flip() {
        isFlipped.toggle()
        
        if isFlipped {
            withAnimation(.linear(duration: duration)) {
                frontAngle = Angle(degrees: -90)
            }
            withAnimation(.linear(duration: duration).delay(duration)) {
                backAngle = Angle(degrees: 0)
            }
        } else {
            withAnimation(.linear(duration: duration)) {
                backAngle = Angle(degrees: 90)
            }
            withAnimation(.linear(duration: duration).delay(duration)) {
                frontAngle = Angle(degrees: 0)
            }
        }
    }
    
    private func dragDidChange(_ gesture: DragGesture.Value) {
        dragAmout = gesture.translation
        cardAngle = Angle(degrees: gesture.translation.width * 0.05)
        
        if gesture.translation.width > 0 && direction != .right {
            withAnimation(.linear(duration: duration)) {
                direction = .right
            }
        }

        if gesture.translation.width < 0 && direction != .left {
            withAnimation(.linear(duration: duration)) {
                direction = .left
            }
        }

        if gesture.translation == .zero && direction != .none {
            withAnimation(.linear(duration: duration)) {
                direction = .none
            }
        }
    }
    
    private func dragDidEnd(_ gesture: DragGesture.Value) {
        withAnimation(.linear(duration: duration)) {
            dragAmout = .zero
            cardAngle = .zero
            direction = .none
        }
        
        if gesture.translation.width < 0 {
            onLeftSwipe(term) // Chama a função de deslize para a esquerda
            resetCardAngles()
        } else {
            onRightSwipe(term) // Chama a função de deslize para a direita
            resetCardAngles()
        }
    }
    private func resetCardAngles() {
            // Redefine as rotações para a posição inicial
            frontAngle = Angle(degrees: 0)
            backAngle = Angle(degrees: 90)
        }
    
    
}

struct SwipperCard_Previews: PreviewProvider {
    static var previews: some View {
        SwipperCard(direction: .constant(.none),
                    frontContent: {
                        Text("Term")
                    }, backContent: {
                        Text("Meaning")
                    }, term: Term(),
                    termMovedLeft: false,
                    termMovedRight: false,
                    onRightSwipe: {_ in },
                    onLeftSwipe: {_ in },
                    cardColor: Palette.mauve.render,
                    box: Box())
    }
}

