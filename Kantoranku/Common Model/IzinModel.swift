//
//  IzinModel.swift
//  Kantoranku
//
//  Created by Rizki Faris on 28/07/22.
//

import Foundation

struct IzinModel: Codable {
    var startedAt: Date = Date()
    var type: String = "izin"
    var notes: String = ""
}

enum TypeIzin: String, CaseIterable, Identifiable {
    case izin
    case sakit

    var id: String { self.rawValue }
}
