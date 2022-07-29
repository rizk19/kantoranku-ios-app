//
//  LoginView.swift
//  Kantoranku
//
//  Created by Rizki Faris on 25/07/22.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @EnvironmentObject var auth: Authentication
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            VStack {
                Text("Kantoranku").font(Font.custom("Inter-ExtraBold", size: 50))
                    .multilineTextAlignment(.center)
                    .overlay {
                        LinearGradient(
                            colors: [.green, .cyan, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .mask(
                            Text("Kantoranku").font(Font.custom("Inter-ExtraBold", size: 50))
                                .multilineTextAlignment(.center)
                        )
                    }.frame(maxHeight: 40)
                Text("Lakukan pengajuan kantormu disini.").frame(maxHeight: 40)
                Spacer(minLength: 80).frame(maxHeight: 80)
                Text("Login").font(Font.custom("Inter-Bold", size: 22)).frame(maxHeight: 20)
                VStack {
                    Form {
                        Section {
                            TextField("Email", text: $loginViewModel.credentials.email).keyboardType(.emailAddress)
                            SecureField("Password", text: $loginViewModel.credentials.password)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: 150)
                    Button(action: {
                        loginViewModel.login { success in auth.updateValidation(success: success)
                        }
                    }) {
                        HStack {
                            if loginViewModel.isShowProgressView {    ProgressView().foregroundColor(.blue)
                            }
                            Text("Masuk")
                                .fontWeight(.semibold)
                                .font(.system(size: 18))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                        .padding(.horizontal, 25)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    }
                    .background(loginViewModel.isLoginDisabled ? Color.gray : loginViewModel.isShowProgressView ? Color.yellow : Color.green) // If you have this
                    .cornerRadius(25).padding(20)
                    .disabled(loginViewModel.isLoginDisabled)
                }
            }
        }
        .autocapitalization(.none)
        .disabled(loginViewModel.isShowProgressView)
        .alert(item: $loginViewModel.error) { error in
            Alert(title: Text("Invalid Login"), message: Text(error.localizedDescription))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
