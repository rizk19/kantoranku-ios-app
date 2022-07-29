//
//  IzinViewModel.swift
//  Kantoranku
//
//  Created by Rizki Faris on 28/07/22.
//

import Foundation
import SwiftUI

class IzinViewModel: ObservableObject {
    @Published var izintype: TypeIzin = .izin
    @Published var izinModel = IzinModel()
    

}
