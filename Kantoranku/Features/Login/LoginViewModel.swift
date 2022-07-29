//
//  LoginViewModel.swift
//  Kantoranku
//
//  Created by Rizki Faris on 25/07/22.
//
import Foundation

class LoginViewModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var isShowProgressView = false
    @Published var error: Authentication.AuthenticationError?
    
    var isLoginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.count < 4
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        isShowProgressView = true
        APIService.shared.login(credentials: credentials) { [unowned self](result:Result<UserDataModel, Authentication.AuthenticationError>) in
         isShowProgressView = false
            switch result {
            case .success(let successResult):
                if let encoded = try? JSONEncoder().encode(successResult) {
                    UserDefaults.standard.set(encoded, forKey: "UserData")
                }
                completion(true)
                print("masuk sini woy")
            case .failure(let authError):
//                credentials = Credentials()
                error = authError
                completion(false)
                print("gagal euy")
            }
        }
    }
//    func getUser(completion: @escaping (Bool) -> Void) async {
//        var getuser = try await APIService.shared.fetchGetUser(passUrl: "") { [unowned self](result:Result<AttendanceDataModel,AttendanceHandler.AttendanceFailed>) in
//            switch result {
//            case .success(let successResult):
//                print(successResult)
//            case .failure(let error):
//                errorAttend = error
//                print(errorAttend)
//            }
//
//        }
//    }
}
