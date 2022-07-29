//
//  AttendanceErrorHandler.swift
//  Kantoranku
//
//  Created by Rizki Faris on 27/07/22.
//

import SwiftUI

class AttendanceHandler: ObservableObject {
    
    enum AttendanceFailed: Error, LocalizedError, Identifiable {
        case invalidConnections
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidConnections:
                return NSLocalizedString("Something went wrong. Please try again later", comment: "")
            }
        }
    }
}

