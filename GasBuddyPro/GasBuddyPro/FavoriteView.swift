//
//  FavoriteView.swift
//  GasBuddyPro
//
//  Created by David on 11/22/23.
//

import SwiftUI
import CoreData

struct FavoriteView: View {
    @Environment(\.managedObjectContext) var moc
    @Binding var selectedState: States
    @ObservedObject var webVM: jsonWebVM
    @FetchRequest(sortDescriptors: []) var prices: FetchedResults<Price>
    
    var body: some View {
        VStack {
            List(prices) { price in
                Text("State: \(price.state ?? "unknown")")
                Text("Regular: \(price.regular ?? "unknown")")
                Text("MidGrade: \(price.midgrade ?? "unknown")")
                Text("Preium: \(price.premium ?? "unknown")")
                Text("Diesel: \(price.diesel ?? "unknown")")
                Spacer()
            }
            Button {
                deleteData()
            }label: {
                Text("Delete Favorite List")
            }
        }
    }
    
    func deleteData() {
        for index in 0..<prices.count {
            moc.delete(prices[index])
        }
    }
}


/*#Preview {
    FavoriteView(selectedState: .AZ ,webVM: jsonWebVM())
}*/
