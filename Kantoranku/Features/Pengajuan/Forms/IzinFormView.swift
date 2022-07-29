//
//  IzinFormView.swift
//  Kantoranku
//
//  Created by Rizki Faris on 28/07/22.
//

import SwiftUI

struct IzinFormView: View {
    @StateObject var izinModel: IzinViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Tipe", selection: $izinModel.izinModel.type) {
                        ForEach(TypeIzin.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    DatePicker("Tanggal Izin/Sakit",
                               selection: $izinModel.izinModel.startedAt,
                               displayedComponents: [.date])
                    
                }
                Section {
                    TextEditor(text: $izinModel.izinModel.notes).lineLimit(7)
                } header: {
                    Text("Keterangan")
                } footer: {
                    Text("Bila sakit lebih dari 1 (satu) hari, ajukan langsung ke HR").textCase(.none)
                }
            }.frame(alignment: .top).background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)))
        }.navigationTitle("Pengajuan Izin/Sakit")
        .toolbar {
            Button("Save") {
                addItem()
                self.presentationMode.wrappedValue.dismiss()
//                homesub.addItem()
            }
        }
    }
    
    func addItem() {
        withAnimation {
            let newItem = Pengajuan(context: viewContext)
            newItem.timestamp = Date()
            newItem.updateAt = Date()
            newItem.createdAt = Date()
            newItem.status = "ongoing"
            newItem.type = izinModel.izinModel.type
            newItem.notes = izinModel.izinModel.notes
            newItem.startedAt = izinModel.izinModel.startedAt
            newItem.endedAt = izinModel.izinModel.startedAt
            print("new", newItem)
            do {
                try viewContext.save()
                izinModel.izinModel = IzinModel()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct IzinFormView_Previews: PreviewProvider {
    static var previews: some View {
        IzinFormView(izinModel: IzinViewModel()).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
