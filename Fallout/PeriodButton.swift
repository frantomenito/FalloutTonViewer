//
//  PeriodButton.swift
//  Fallout
//
//  Created by Dmytro Maksymyak on 18.04.2024.
//

import SwiftUI

struct PeriodButton: View {
    var text: String = "Day"
    var color: Color = .green
    
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            Text(text)
                .fontWeight(.black)
                .padding(16)
                .foregroundStyle(color)
                .background(.clear)
                .opacity(isSelected ? 0 : 1)

            Text(text)
                .fontWeight(.bold)
                .padding(16)
                .foregroundStyle(.black)
                .background(color)
                .opacity(isSelected ? 1 : 0)
        }
        .border(color, width: 1.5)
    }
}

enum Period: String, CaseIterable {
    case day = "DAY"
    case week = "WEEK"
    case month = "MONTH"
    
    var past: String {
        switch self {
        case .day:
            return "YESTERDAY"
        case .week:
            return "LAST WEEK"
        case .month:
            return "LAST MONTH"
        }
    }
}

#Preview {
    @State var selectedPeriod: Period = .day
    
    return HStack(spacing: 0) {
        ForEach(Period.allCases, id: \.self) { period in
            PeriodButton(text: period.rawValue,
                         isSelected: selectedPeriod == period)
            .onTapGesture {
                withAnimation(.snappy) {
                    selectedPeriod = period
                }
            }
        }
    }
}

