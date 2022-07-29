//
//  UserModel.swift
//  Kantoranku
//
//  Created by Rizki Faris on 25/07/22.
//

import Foundation
import SwiftUI

struct UserDataWrappedModel: Decodable {
    let user: UserDataModel
}

struct UserDataModel: Decodable, Encodable {
    let _id: String
    let emailVerified: Bool
    let email: String
    let name: String
    let username: String
    let bio: String
    let companyId: String
    let role: String
}
