//
//  AttendanceCardView.swift
//  Kantoranku
//
//  Created by Rizki Faris on 26/07/22.
//

import SwiftUI

struct AttendanceCardView: View {
    @StateObject var attendanceModel: AttendanceCardViewModel
    
    @State var temp: Any
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color(uiColor: UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00))).frame(height: 170, alignment: .top).cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.black, lineWidth: 1)
                )
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Text("Status").frame(alignment: .leading).font(Font.custom("Inter-Regular", size: 15))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("\(attendanceModel.textCheck)").font(Font.custom("Inter-Bold", size: 35))
                            .foregroundColor(Color(attendanceModel.colorTextCheck))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal, 20).padding(.top, 25).frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                ZStack {
                    Rectangle().cornerRadius(15)
                        .overlay(
                            RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 15)
                        )
                    HStack {
                        Text("\(attendanceModel.textCTAButtonCheck)").foregroundColor(.white)
                        Spacer()
                        if !attendanceModel.statusAttendance {
                            Button(action: {
                                if attendanceModel.isStartAttending && attendanceModel.attendanceState.status == "checkedin" {
                                    attendanceModel.doCheckOut { success in
                                        attendanceModel.statusTextHandler(res: success)
        
                                    }
                                } else {
                                    attendanceModel.doCheckIn { success in
                                        attendanceModel.statusTextHandler(res: success)
                                    
                                    }
                                }
                            }) {
                                    HStack {
                                        if attendanceModel.isShowProgressView == false {
                                            Image(systemName: attendanceModel.isStartAttending ? "arrow.down.left" : "arrow.up.forward")
                                            
                                        } else {
                                            ProgressView()
                                        }
                                        Text("\(attendanceModel.textBtnCheck)")
                                    }.foregroundColor(.white).padding(.horizontal, 10).padding(.vertical, 5)
                                
                            }.background(Color(attendanceModel.colorTextBtnCheck)).cornerRadius(10)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.horizontal, 15)
                }.frame(maxHeight: 70)
            }.frame(maxHeight: 170, alignment: .bottom)
        }.frame(width: .infinity, height: 300, alignment: .top)
            .task {
                do {
                    temp = try await attendanceModel.getAttend()
                    attendanceModel.assignAttendVal(data: temp as! AttendanceDataModel)
                    attendanceModel.statusTextHandler(res: true)
                } catch {
                    attendanceModel.statusTextHandler(res: false)
                    
                    print("dari tempe",error)
                }
            }
    }
}

struct AttendanceCardView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceCardView(attendanceModel: AttendanceCardViewModel(), temp: (Any).self)
    }
}
