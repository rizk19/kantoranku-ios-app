//
//  AttendanceModel.swift
//  Kantoranku
//
//  Created by Rizki Faris on 27/07/22.
//

import Foundation
import SwiftUI

struct AttendanceDataWrappedModel: Decodable {
    let attend: AttendanceDataModel
}

struct AttendanceDataModel: Decodable, Encodable {
    let _id: String
    let status: String
    let overtimeNotes: String
    let businessTrip: String
    let updateAt: String
    let createdAt: String
    let creatorId: String
    let companyId: String
}

struct AttendanceDataPost: Codable {
    var status: String = ""
    var overtimeNotes: String = ""
    var businessTrip: String = ""
}

struct AttendanceDataPut: Codable {
    var _id: String = ""
    var status: String = ""
    var overtimeNotes: String = ""
    var businessTrip: String = ""
}
