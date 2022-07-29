//
//  AttendanceCardViewModel.swift
//  Kantoranku
//
//  Created by Rizki Faris on 27/07/22.
//

import Foundation
import UIKit

class AttendanceCardViewModel: ObservableObject {
    // mulai checkin belum hari ini
    @Published var isStartAttending = false
    // udah checkout belum hari ini, status baru muncul setelah isStartAttending true
    @Published var statusAttendance = false
    
    @Published var isShowProgressView = false
    
    let baseUrl = "http://localhost:3000/api/"
    
    @Published var attendanceState: AttendanceDataModel = AttendanceDataModel(_id: "", status: "checkedout", overtimeNotes: "", businessTrip: "", updateAt: "", createdAt: "", creatorId: "", companyId: "")
    
    @Published var textCheck = "Checked Out"
    
    @Published var textCTAButtonCheck = "Belum absen?"
    
    @Published var textBtnCheck = "Check In"
    
    @Published var colorTextCheck = UIColor(.red)
    
    @Published var colorTextBtnCheck = UIColor(.green)
    
    @Published var errorAttend: AttendanceHandler.AttendanceFailed?
    
    @Published var attendancePostData = AttendanceDataPost()
    
    @Published var attendancePutData = AttendanceDataPut()
    
    
    func statusTextHandler(res: Bool) {
        isStartAttending = res
        print("isStartAttending", isStartAttending, statusAttendance)
        if isStartAttending && attendanceState.status.contains("in") {
            textCheck = "Checked In"
            colorTextCheck = UIColor(.green)
            textCTAButtonCheck = "Sudah selesai ngantor?"
            textBtnCheck = "Check Out"
            colorTextBtnCheck = UIColor(.red)
            statusAttendance = false
        } else if isStartAttending && attendanceState.status.contains("out") {
            textCheck = "Checked Out"
            colorTextCheck = UIColor(.red)
            textCTAButtonCheck = "Terimakasih sudah absen hari ini"
            textBtnCheck = ""
            statusAttendance = true
        } else {
            textCheck = "Checked Out"
            colorTextCheck = UIColor(.red)
            textCTAButtonCheck = "Belum absen?"
            textBtnCheck = "Check In"
            colorTextBtnCheck = UIColor(.green)
            statusAttendance = false
        }
    }
    
    func assignAttendVal(data: AttendanceDataModel) {
        attendanceState = data
        attendancePutData._id = attendanceState._id
        attendancePutData.status = attendanceState.status
//        if (isStartAttending && attendanceState.status == "checkedout") {
//            statusAttendance = true
//            print("state 2", statusAttendance)
//        } else {
//            statusAttendance = false
//        }
        print("state", attendanceState)
    }
 
    func getAttend() async throws -> AttendanceDataModel {
        guard let url = URL(string: baseUrl + "attendance") else {
            return AttendanceDataModel(_id: "", status: "", overtimeNotes: "", businessTrip: "", updateAt: "", createdAt: "", creatorId: "", companyId: "")
        }
        return try await APIFetchMethodGet.fetchObj(from: url)
    }
    
    func doCheckIn(completion: @escaping (Bool) -> Void) {
        isShowProgressView = true
        APIService.shared.postAttend(passedData: attendancePostData) { [unowned self](result:Result<AttendanceDataModel, AttendanceHandler.AttendanceFailed>) in
            isShowProgressView = false
            switch result {
            case .success(let successResult):
                print("success dicheck", successResult)
                assignAttendVal(data: successResult)
                completion(true)
            case .failure(let authError):
                print("fail dicheck", authError)
                errorAttend = authError
                statusTextHandler(res: false)
                completion(false)
            }
        }
    }
    
    func doCheckOut(completion: @escaping (Bool) -> Void) {
        isShowProgressView = true
        APIService.shared.putAttend(passedData: attendancePutData) { [unowned self](result:Result<AttendanceDataModel, AttendanceHandler.AttendanceFailed>) in
            isShowProgressView = false
            switch result {
            case .success(let successResult):
                print("success docheckOUT", successResult)
                assignAttendVal(data: successResult)
                completion(true)
            case .failure(let authError):
                print("fail docheckOUT", authError)
                errorAttend = authError
                statusTextHandler(res: false)
                completion(false)
            }
        }
    }
}
