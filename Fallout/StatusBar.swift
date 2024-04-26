//
//  StatusBar.swift
//  Fallout
//
//  Created by Dmytro Maksymyak on 18.04.2024.
//

import SwiftUI

struct StatusBar: View {
    @State private var networkMonitor = NetworkMonitor()

    var body: some View {
        HStack(spacing: 16) {
            Text("TON COIN")
            
            Image(systemName: "sun.max.fill")

            Spacer()
            
            Image(systemName: networkMonitor.isConnected ? "wifi" : "wifi.slash")
            
            Text(Date.now, format: .dateTime.day())
            Text(Date.now, format: .dateTime.month())

            Text(Date.now.formatted(date: .omitted, time: .shortened))
        }
        .font(.title2)
        .foregroundStyle(.white)
        .fontWeight(.heavy)
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()

        StatusBar()
    }
}
