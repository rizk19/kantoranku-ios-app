//
//  APIService.swift
//  Kantoranku
//
//  Created by Rizki Faris on 25/07/22.
//

import Foundation

class APIService {
    static let shared = APIService()
    let baseUrl = "http://localhost:3000/api/"
    
    func login(credentials: Credentials,
               completion: @escaping (Result<UserDataModel,Authentication.AuthenticationError>) -> Void) {
        // query sengaja untuk nembak create user dan masuk ke company nya juga langsung

        guard let loginUrl = URL(string: baseUrl + "users?cid=62d9255d4751345980d47826&mobile=1") else {
            return
        }
        
        let data: [String: Any] = ["email": credentials.email, "password": credentials.password]
        
        let body = try! JSONSerialization.data(withJSONObject: data)
        
        var request = URLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if error != nil {
                print("error", error?.localizedDescription ?? "error not detected")
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(UserDataWrappedModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result.user))
                    }
                } else {
                    print("No Data")
                    completion(.failure(.invalidCredentials))
                }
            } catch let JsonError {
                print("fetch json error", JsonError.localizedDescription)
                completion(.failure(.invalidConnections))
            }
        }.resume()
    }

//    func fetchGet<T>(passUrl: String) -> [T] {
//        let result:[T] = []
//        guard let url = URL(string: passUrl) else {
//            return []
//        }
//
//        return result
//    }
    // do checkin
    func postAttend(passedData: AttendanceDataPost,
                    completion: @escaping (Result<AttendanceDataModel,AttendanceHandler.AttendanceFailed>) -> Void) {
        guard let attendUrl = URL(string: baseUrl + "attendance/today") else {
            return
        }
        
        let data: [String: Any] = ["status": "checkedin", "overtimeNotes": passedData.overtimeNotes, "businessTrip": passedData.businessTrip]
        
        let body = try! JSONSerialization.data(withJSONObject: data)
        
        var request = URLRequest(url: attendUrl)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if error != nil {
                print("error", error?.localizedDescription ?? "error not detected")
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(AttendanceDataWrappedModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result.attend))
                    }
                } else {
                    print("No Data")
                    completion(.failure(.invalidConnections))
                }
            } catch let JsonError {
                print("fetch json error", JsonError.localizedDescription)
                completion(.failure(.invalidConnections))
            }
        }.resume()
    }
    
    func putAttend(passedData: AttendanceDataPut,
                    completion: @escaping (Result<AttendanceDataModel,AttendanceHandler.AttendanceFailed>) -> Void) {
        guard let attendUrl = URL(string: baseUrl + "attendance/today") else {
            return
        }
        
        let data: [String: Any] = ["_id": passedData._id, "status": "checkedout", "overtimeNotes": passedData.overtimeNotes, "businessTrip": passedData.businessTrip]
        
        let body = try! JSONSerialization.data(withJSONObject: data)
        
        var request = URLRequest(url: attendUrl)
        request.httpMethod = "PUT"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if error != nil {
                print("error", error?.localizedDescription ?? "error not detected")
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(AttendanceDataWrappedModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result.attend))
                    }
                } else {
                    print("No Data")
                    completion(.failure(.invalidConnections))
                }
            } catch let JsonError {
                print("fetch json error", JsonError.localizedDescription)
                completion(.failure(.invalidConnections))
            }
        }.resume()
    }
    
    func deleteAuth() {
            guard let url = URL(string: baseUrl + "auth") else {
                print("Error: cannot create URL")
                return
            }
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling DELETE")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
}
    

