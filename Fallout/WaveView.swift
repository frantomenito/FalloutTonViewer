//
//  WaveView.swift
//  Fallout
//
//  Created by Dmytro Maksymyak on 14.04.2024.
//

import SwiftUI

struct WaveView: View {
    @State var wavePhase: CGFloat = 0
    let waveTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    var color: Color = .green
    
    var body: some View {
        Wave(strength: 20, frequency: 60, phase: wavePhase)
            .stroke(color, lineWidth: 5)
            .onReceive(waveTimer) { _ in
                withAnimation {
                    wavePhase -= 0.2
                }
            }
            .clipped()
    }
}

#Preview {
    WaveView()
}
