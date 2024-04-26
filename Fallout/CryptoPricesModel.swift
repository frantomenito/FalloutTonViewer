//
//  CryptoPricesModel.swift
//  Fallout
//
//  Created by Dmytro Maksymyak on 15.04.2024.
//

import Foundation

@MainActor
class CryptoPricesModel: ObservableObject {
    @Published var tonData: TonData?
    
    private var updateTimer: Timer?
    
    func startUpdating() {
        updateTimer?.invalidate()
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
            Task {
                await self.loadTonData()
            }
        })
        
        updateTimer?.fire()
    }
    
    func stopUpdating() {
        updateTimer?.invalidate()
    }
    
    private func loadTonData() async {
        print("loading data")
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/the-open-network")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "x-cg-demo-api-key": "CG-5yZCKd6QUQm8TUcuz2ffKrR2"
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try JSONDecoder().decode(TonData.self, from: data)
            
            tonData = decodedData
        } catch {
            print("Nah")
        }
    }
}

struct TonData: Decodable, Equatable {
    let marketData: MarketData
    
    enum CodingKeys: String, CodingKey {
        case marketData = "market_data"
    }
}

struct MarketData: Decodable, Equatable {
    let currentPrice: [String: Double]
    let marketCap: [String: Int]
    
    let dayChange: Double

    let dayChangePercentage: Double
    let weekChangePercentage: Double
    let monthChangePercentage: Double
    let yearChangePercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        
        case dayChange = "price_change_24h"

        case dayChangePercentage = "price_change_percentage_24h"
        case weekChangePercentage = "price_change_percentage_7d"
        case monthChangePercentage = "price_change_percentage_30d"
        case yearChangePercentage = "price_change_percentage_1y"
    }
}
