//
//  Models.swift
//  CryptoTracker
//
//  Created by eduardo rivadeneira on 2022-01-27.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String
    let name: String?
    let price_usd: Float?
    let id_icon: String?
}

struct Icon: Codable {
    let asset_id: String
    let url: String
}
