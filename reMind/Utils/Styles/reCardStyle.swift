//
//  reCardStyle.swift
//  reMind
//
//  Created by Victor Brigido on 11/01/24.
//

import SwiftUI

struct reCardStyle: CardStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Palette.selectionColor.render)
            .background {
                Rectangle()
                    .fill(Color.accentColor)
                    .cornerRadius(10)
            }
    }
}


#Preview {
    reCardStyle()
}
