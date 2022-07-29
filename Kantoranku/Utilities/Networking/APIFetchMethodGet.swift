//
//  APIFetchMethodGet.swift
//  Kantoranku
//
//  Created by Rizki Faris on 26/07/22.
//

import Foundation

enum APIFetchMethodGet {
    static func fetchArr<T: Decodable>(from url: URL) async throws -> [T] {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let result = try decoder.decode([T].self, from: data)
        
        return result;
    }
    
    static func fetchObj<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)
        
        return result;
    }
}
// base model
// 
