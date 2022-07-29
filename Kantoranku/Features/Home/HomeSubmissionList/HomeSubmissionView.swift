//
//  HomeSubmissionView.swift
//  Kantoranku
//
//  Created by Rizki Faris on 28/07/22.
//

import SwiftUI

struct HomeSubmissionView: View {
    @State var showingPopup = false // 1
    
    @State var selectedRow: Pengajuan?
    
    @State var isNavigationActive = false
    
    var arrayPopover = ["approved", "ongoing", "rejected"]

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pengajuan.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Pengajuan>
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    var body: some View {
        VStack {
            HStack {
                HStack() {
                    Text("Pengajuanku").font(Font.custom("Inter-Regular", size: 17))
                    Button(action: {
//                        showingPopup = true // 2
                        addItem()
                    } ) {
                        Image(systemName: "info.circle.fill").resizable().scaledToFit().frame(width: 17, height: 17, alignment: .top)
                            .foregroundColor(.black)
                    }
                }
                Spacer()
            }.padding(.horizontal, 20)
//            List {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    NavigationLink(isActive: $isNavigationActive, destination: {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    }, label: {
                        HStack(alignment: .center, spacing: 10) {
                            Button(action: {} ) {
                                Image(systemName: imageButtonClosures(item.status ?? "ongoing")).resizable().scaledToFit().frame(width: 25, height: 20, alignment: .top)
                                    .foregroundColor(.white)
                            }
                            .background(Circle().frame(width: 40, height: 40, alignment: .center))
                            .foregroundColor(iconButtonClosures(item.status ?? "ongoing"))
                            LazyVStack(alignment: .leading, spacing: 5) {
                                Text("Pengajuan \(item.type ?? "")").font(Font.custom("Inter-SemiBold", size: 20))
                                HStack(spacing: 10) {
                                    HStack(spacing: 2) {
                                        Text("Diajukan: ").font(Font.custom("Inter-Light", size: 14))
                                        Text(item.timestamp!, formatter: itemFormatter).font(Font.custom("Inter-Light", size: 14))
                                    }
                                    HStack(spacing: 2) {
                                        Text("Update: ").font(Font.custom("Inter-Light", size: 14))
                                        Text(item.timestamp!, formatter: itemFormatter).font(Font.custom("Inter-Light", size: 14))
                                    }
                                }
                            }.padding(.leading, 15)
                        }
                        .onTapGesture(perform: {
                            isNavigationActive = true
                            print("tapped")
                        })
                        .onLongPressGesture {
                            isNavigationActive = false
                            // set selectedRow to the task
                            selectedRow = item
                        }
                        .actionSheet(isPresented: Binding<Bool>(
                            // the get returns the Bool that is the comparison of selectedRow and task
                            // if they are equal, the .actionSheet() fires
                            get: { selectedRow == item },
                            // when done, .actionSheet() sets the Binding<Bool> to false, but we intercept that
                            // and use it to set the selectedRow back to nil
                            set: { if !$0 {
                                selectedRow = nil
                            }})) {
                            ActionSheet(
                                title: Text("Settings"),
                                // added task.title to prove the correct row is in the ActionSheet
                                message: Text("Press the button for delete \(selectedRow?.type ?? "")"),
                                buttons: [
                                    .cancel(),
                                    .destructive(Text("Delete"), action: {
                                        deleteItems(offsets: IndexSet(integer: index))
                                    }),
//                                    .default(Text("Edit"), action: {})
                                ]
                            )
                        }
                        .padding(.vertical, 8).padding(.leading, 10)
                    })
                }.onDelete(perform: deleteItems).padding(.horizontal, 20)
                
        }.sheet(isPresented: $showingPopup) {
            List {
                ForEach(arrayPopover, id: \.self) { item in
                    Button {
                        print("")
                    } label: {
                        HStack {
                            Button(action: {} ) {
                                Image(systemName: imageButtonClosures(item)).resizable().scaledToFit().frame(width: 25, height: 20, alignment: .top)
                                    .foregroundColor(.white)
                            }
                            .background(Circle().frame(width: 40, height: 40, alignment: .center))
                            .foregroundColor(iconButtonClosures(item))
                            LazyVStack {
                                Text("Status \(item)").font(Font.custom("Inter-SemiBold", size: 20)).foregroundColor(.black)
                            }
                        }
                    }.padding(.vertical, 25)

                }
            }
        }
    }
    
    func addItem() {
        withAnimation {
            let newItem = Pengajuan(context: viewContext)
            newItem.timestamp = Date()
            newItem.status = "rejected"
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
    return formatter
}()

var iconButtonClosures:(String)-> Color = {
    if $0 == "rejected" {
        return Color.red
    } else if $0 == "approved" {
        return Color.green
    } else {
        return Color.yellow
    }
}

var imageButtonClosures:(String)-> String = {
    if $0 == "rejected" {
        return "xmark"
    } else if $0 == "approved" {
        return "checkmark"
    } else {
        return "arrow.up.to.line"
    }
}

struct HomeSubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSubmissionView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
