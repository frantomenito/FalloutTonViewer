//
//  SlidableText.swift
//  Fallout
//
//  Created by Dmytro Maksymyak on 14.04.2024.
//

import SwiftUI

struct SlidableText: View {
    let characters: [Character]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<characters.count, id: \.self) { charIndex in
                
                Text(characters[charIndex].description)
                    .transition(.asymmetric(
                        insertion: .offset(y: -30)
                            .animation(.spring(Spring(duration: 0.3, bounce: 0.3)))
                            .combined(with:
                                    .opacity.animation(.linear.delay(delayFor(index: charIndex)))
                            ),
                        
                        removal: .offset(y: 30)
                            .combined(with: .opacity)
                            .combined(with: .scale(scale: 0.8)
                                .animation(
                                    .spring(Spring(duration: 0.3, bounce: 0.3))
                                    .delay(delayFor(index: charIndex))
                                )
                            )
                            .animation(
                                .spring(Spring(duration: 0.3, bounce: 0.3))
                                .delay(delayFor(index: charIndex))
                            )

                    ))
                    
                    .animation(
                        .spring(Spring(duration: 0.3, bounce: 0.3))
                        .delay(delayFor(index: charIndex))
                    )

                    .id(characters[charIndex].description + Date().timeIntervalSince1970.description)

            }
        }
    }
    
    private func delayFor(index: Int) -> TimeInterval {
        let delayPerChar: CGFloat = 0.07

        return TimeInterval(CGFloat(index) * delayPerChar)
    }
    
    init(text: String) {
        self.characters = Array(text)
    }

}

struct SlidableTextPreview: View {
    @State var isShowingMore: Bool = false

    var body: some View {
        VStack {
            SlidableText(text: isShowingMore ? "109.78" : "50.42")
                .font(.system(size: 80, weight: .black))
                .foregroundStyle(.green)
            
            Button {
                withAnimation(.spring(Spring(duration: 0.3, bounce: 0.3))) {
                    isShowingMore = !isShowingMore
                }
            } label: {
                Text("Switch")
                
            }
            .buttonStyle(.bordered)

        }
    }
    
}

#Preview {
    SlidableTextPreview()
}
