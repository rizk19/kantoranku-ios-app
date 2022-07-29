//
//  ContentView.swift
//  Kantoranku
//
//  Created by Rizki Faris on 25/07/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var auth = Authentication()
    @State var tabSelection: Tabs = .tab1
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        if auth.isValidated {
            NavigationView {
                TabView(selection: $tabSelection) {
                    HomeView().environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }.tag(Tabs.tab1)
//                    HomeSubmissionView()
                    PengajuanView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .tabItem {
                            Label("Pengajuan", systemImage: "list.dash")
                        }.tag(Tabs.tab2)
                    ProfileView()
                        .environmentObject(auth)
                        .tabItem {
                            Label("Profil", systemImage: "person.fill")
                        }.tag(Tabs.tab3)
                }.accentColor(.black)
                    .navigationTitle(returnNavBarTitle(tabSelection: self.tabSelection))
            }
        } else {
            LoginView()
                .environmentObject(auth)
                .onAppear(perform: {
                    if let data = UserDefaults.standard.data(forKey: "UserData") {
                        if let decoded = try? JSONDecoder().decode(UserDataModel.self, from: data) {
                            print(decoded)
                            auth.updateValidation(success: true)
                        }
                    }
                    tabSelection = .tab1
                })
        }
    }
}

enum Tabs{
    case tab1, tab2, tab3
}

func returnNavBarTitle(tabSelection: Tabs) -> String{//this function will return the correct NavigationBarTitle when different tab is selected.
    switch tabSelection{
        case .tab1: return "Kantoranku"
        case .tab2: return "Pengajuanku"
        case .tab3: return "Profilku"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
