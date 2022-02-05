//
//  APICaller.swift
//  CryptoTracker
//
//  Created by eduardo rivadeneira on 2022-01-27.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants{
        static let apiKey = "B8F44991-B591-456E-9362-C38E7C6C670B"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets/"
    }
    
    private init() {}
    
    public var icons: [Icon] = []
    
    private var WhenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    public func getAllCryptoData(
        completion: @escaping (Result<[Crypto], Error>) -> Void
    ){
        guard !icons.isEmpty else {
            WhenReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else {
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptos.sorted { first, second -> Bool in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                }))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public func getAllIcons() {
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=B8F44991-B591-456E-9362-C38E7C6C670B")
        else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.WhenReadyBlock {
                    self?.getAllCryptoData(completion: completion)
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
