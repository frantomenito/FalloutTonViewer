//
//  ContentView.swift
//  Fallout
//
//  Created by Dmytro Maksymyak on 10.04.2024.
//

import SwiftUI

struct ContentView: View {
    @State var selectedPeriod: Period = .day
    @ObservedObject var priceModel = CryptoPricesModel()
    @State var displayedPrice = 0.0

    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                header
                
                VStack(spacing: 0) {
                    topInfo
                    
                    Spacer()
                    
                    priceText
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .contentTransition(.numericText(countsDown: false))
                    
                    footer
                }
                .border(.greenAccent, width: 3)
            }
            .padding(.bottom, 10)
            
            FilterView(color: .greenAccent)
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }
        .onChange(of: priceModel.tonData) {
            withAnimation(.spring(Spring(duration: 0.3, bounce: 0.3))) {
                displayedPrice = priceModel.tonData?.marketData.currentPrice["usd"] ?? 0
            }
        }
        .task {
            priceModel.startUpdating()
        }
    }
    
    var topInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text("CAPITAL - ")
                    Text(priceModel.tonData?.marketData.marketCap["usd"] ?? 0,
                         format: .number.grouping(.automatic))
                    Text("$")
                    
                }
                .foregroundStyle(.secondaryGreen)

                Text("CURRENT PRICE")
                    .foregroundStyle(.greenAccent)
            }
            
            Spacer()

            VStack(alignment: .trailing) {
                HStack(alignment: .top, spacing: 0) {
                    Text("$")
                    Text("\(previousPeriodPrice, specifier: "%.2f")")
                    Text(" " + selectedPeriod.past)
                }
                .foregroundStyle(.secondaryGreen)

                HStack(spacing: 0) {
                    Triangle()
                        .frame(width: 15, height: 15)
                        .rotationEffect(Angle(degrees: (percentChange ?? 0) > 0 ? 0 : 180))
                        .animation(.easeInOut)
                    Text(" \(percentChange ?? 0, specifier: "%.2f")")
                        .contentTransition(.numericText(countsDown: false))
                    Text("%")
                }
                .foregroundStyle(.greenAccent)
            }
        }
        .fontWeight(.heavy)
        .font(.title2)
        .padding()
    }
    
    var previousPeriodPrice: Double {
        guard let tonData = priceModel.tonData else { return 0 }
        
        return displayedPrice *  (1 + -(percentChange ?? 0) / 100)
        
    }
    
    var percentChange: Double? {
        switch selectedPeriod {
        case .day:
            return priceModel.tonData?.marketData.dayChangePercentage
        case .week:
            return priceModel.tonData?.marketData.weekChangePercentage
        case .month:
            return priceModel.tonData?.marketData.monthChangePercentage
        }
    }
    
    var header: some View {
        StatusBar()
            .padding()
            .border(.greenAccent, width: 3)
            .padding(.top, 24)
    }
    
    var footer: some View {
        HStack(spacing: 0) {
            timeButtons
            
            WaveView(color: .greenAccent)
                .frame(height: 50)
                .border(.greenAccent, width: 1.5)
            
            
        }
        .border(.greenAccent, width: 3)
    }
    
    var priceText: some View {
        HStack(spacing: 0) {
            Text("$")
            
            Text(displayedPrice.debugDescription)
        }
        .minimumScaleFactor(0.3)
        .font(.system(size: 150, weight: .black))
        .foregroundStyle(.greenAccent)
    }
    
    
    var timeButtons: some View {
        HStack(spacing: 0) {
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
}


#Preview {
    ContentView()
}
