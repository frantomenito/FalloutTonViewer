//
//  FilterView.swift
//  Fallout
//
//  Created by Dmytro Maksymyak on 11.04.2024.
//

import SwiftUI

struct FilterView: View {
    let gridBlockSide: CGFloat = 3
    
    @State var scrollCount: CGFloat = 0
    
    let staticLineHeight: CGFloat = 3 * 0.6
    let staticLineOpacity: CGFloat = 0.35

    let lineHeight: CGFloat = 50
    let lineSpacing: CGFloat = 1.5
    let lineOpacity: CGFloat = 0.22
    
    var color: Color

    let scrollTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            gridCanvas
            linesCanvas
            staticLinesCanvas
            vingeteCanvas
        }
        .onReceive(scrollTimer) { _ in
            scrollCount += 1.5
        }
    }
    
    
    var gridCanvas: some View {
        Canvas { context, size in
            let widthCount = Int(size.width / gridBlockSide)
            let heightCount = Int(size.height / gridBlockSide)
            
            for x in 0..<widthCount {
                for y in 0..<heightCount {
                    let shouldX = x%2 == 0
                    let shouldY = y%2 == 0
                    
                    let shouldFill = shouldY && shouldX
                    context.fill(Path(roundedRect: CGRect(x: CGFloat(x)*gridBlockSide, y: CGFloat(y)*gridBlockSide,
                                                              width: gridBlockSide, height: gridBlockSide),
                                          cornerRadius: 1),
                                 with: .color(shouldFill ? color.opacity(0.5) : color.opacity(0)))
                    
                }
            }
        }
    }
    
    var staticLinesCanvas: some View {
        Canvas { context, size in
            let heightCount = Int(size.height / gridBlockSide)
            
            for y in 0..<heightCount {
                let shouldFill = y%2 == 0
                
                context.fill(Path(roundedRect: CGRect(x: 0, y: CGFloat(y)*gridBlockSide,
                                                      width: size.width, height: staticLineHeight),
                                  cornerRadius: 0),
                             with: .color(shouldFill ? color.opacity(staticLineOpacity) : color.opacity(0)))
                
            }
        }
    }
    
    var linesCanvas: some View {
        Canvas { context, size in
            let linesCount = Int(size.height / (lineHeight*lineSpacing)) + 1

            for lineIndex in 0..<linesCount {
                let y = scrollCount + CGFloat(lineIndex) * lineHeight * CGFloat(lineSpacing)
                let borderedY = y.truncatingRemainder(dividingBy: size.height + lineHeight)
                let safeY = borderedY - lineHeight

                context.fill(.init(roundedRect: CGRect(x: 0, y: safeY,
                                                       width: size.width, height: lineHeight),
                                   cornerRadius: 0),
                             with: .linearGradient(.init(colors:
                                                            [.clear,
                                                             color.opacity(lineOpacity),
                                                             color.opacity(lineOpacity),
                                                             .clear]),
                                                   startPoint: .init(x: 0, y: lineHeight + safeY),
                                                   endPoint: .init(x: 0, y: safeY)))
            }
        }
        .blendMode(.exclusion)
    }
    
    var vingeteCanvas: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(
                    EllipticalGradient(colors:[.white, .black], center: .center, startRadiusFraction: 0.2, endRadiusFraction: 1)
                )
                .blendMode(.multiply)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
}

#Preview {
    let color: Color = .init(uiColor: .init(red: 0, green: 238/255, blue: 0, alpha: 1))

    return ZStack {
        Color.black
        FilterView(color: color)
    }
    .ignoresSafeArea()
}
