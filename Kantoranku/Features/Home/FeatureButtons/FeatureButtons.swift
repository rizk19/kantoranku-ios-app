//
//  FeatureButtons.swift
//  Kantoranku
//
//  Created by Rizki Faris on 28/07/22.
//

import SwiftUI

struct FeatureButtons: View {
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        HStack(alignment: .center, spacing: 35) {
            VStack(spacing: 15) {
                NavigationLink(destination: {
                    IzinFormView(izinModel: IzinViewModel()).environment(\.managedObjectContext, persistenceController.container.viewContext)
                } ) {
                    Image("stamp").resizable().scaledToFit().frame(width: 55, height: 60, alignment: .top)
                        .foregroundColor(.white)
                }
                .background(Circle().frame(width: 80, height: 80, alignment: .center))
                .foregroundColor(Color(UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)))
                Text("Pengajuan Izin").foregroundColor(.black).font(Font.custom("Inter-Light", size: 12))
            }
            VStack(spacing: 15) {
                Button(action: {} ) {
                    Image("holiday").resizable().scaledToFit().frame(width: 55, height: 60, alignment: .top)
                        .foregroundColor(.white)
                }
                .background(Circle().frame(width: 80, height: 80, alignment: .center))
                .foregroundColor(Color(UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)))
                Text("Pengajuan Cuti").foregroundColor(.black).font(Font.custom("Inter-Light", size: 12))
            }
            VStack(spacing: 15) {
                Button(action: {} ) {
                    Image("cash-back").resizable().scaledToFit().frame(width: 55, height: 60, alignment: .top)
                        .foregroundColor(.white)
                }
                .background(Circle().frame(width: 80, height: 80, alignment: .center))
                .foregroundColor(Color(UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)))
                Text("Reimbursement").foregroundColor(.black).font(Font.custom("Inter-Light", size: 12))
            }
        }
    }
}

struct FeatureButtons_Previews: PreviewProvider {
    static var previews: some View {
        FeatureButtons()
    }
}
