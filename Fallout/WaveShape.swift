//
//  WaveShape.swift
//  Fallout
//
//  Created by Dmytro Maksymyak on 11.04.2024.
//

import SwiftUI

struct Wave: Shape {
    var strength: Double
    var frequency: Double
    var phase: Double

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        let width = Double(rect.width)
        let height = Double(rect.height)
        
        let midHeight = height/2
        
        let waveLength = width/frequency
        
        path.move(to: .init(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relX = x / waveLength
            
            let sine = sin(relX + phase)
            
            let y = strength * sine + midHeight
            
            path.addLine(to: .init(x: x, y: y))
        }
        
        return Path(path.cgPath)
    }
}
