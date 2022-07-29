//
//  ProfileView.swift
//  Kantoranku
//
//  Created by Rizki Faris on 28/07/22.
//

import SwiftUI

struct ProfileView: View {
    @State var stateProfile = UserDataModel(_id: "", emailVerified: false, email: "", name: "", username: "", bio: "", companyId: "", role: "")
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HStack(spacing: 20) {
                    Button(action: {} ) {
                        Image(systemName: "user.fill").resizable().scaledToFit().frame(width: 40, height: 40, alignment: .top)
                            .foregroundColor(.white)
                    }
                    .background(Circle().frame(width: 65, height: 65, alignment: .center))
                    .foregroundColor(Color(UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)))
                    Spacer()
                    Text(stateProfile.email).font(.title)
                }.frame(width: 320).padding(.horizontal, 20)
                Button(action: {
                    UserDefaults.standard.removeObject(forKey: "UserData")
                    auth.updateValidation(success: false)
                    APIService.shared.deleteAuth()
                } ) {
                    Image(systemName: "power").resizable().scaledToFit().frame(width: 40, height: 40, alignment: .top)
                        .foregroundColor(.red)
                }
            }.padding(.top, 20)
        }.onAppear(perform: {
            if let data = UserDefaults.standard.data(forKey: "UserData") {
                if let decoded = try? JSONDecoder().decode(UserDataModel.self, from: data) {
                    stateProfile = decoded
                }
            }
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
