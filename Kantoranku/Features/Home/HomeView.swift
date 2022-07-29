//
//  HomeView.swift
//  Kantoranku
//
//  Created by Rizki Faris on 26/07/22.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pengajuan.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Pengajuan>
    var body: some View {
        ScrollView {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
//                    Rectangle().fill(.red).ignoresSafeArea().padding(.top, 100).frame(width: .infinity, height: 300, alignment: .top)
                    VStack(spacing: 0) {
                        AttendanceCardView(attendanceModel: AttendanceCardViewModel(), temp: (Any).self).padding(.horizontal, 15)
                        Spacer()
                    }.frame(alignment: .top)
                    VStack {
                        FeatureButtons()
                        Spacer()
                    }.frame(alignment: .top).padding(.top, 200)
                    VStack {
                        HomeSubmissionView()
                        Spacer()
                    }.frame(alignment: .top).padding(.top, 320)
                }
            }
        }
        }.frame(height: 600)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AttendanceCardViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
