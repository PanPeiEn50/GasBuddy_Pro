//
//  PriceInStatesView.swift
//  GasBuddyPro
//
//  Created by David on 11/21/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct PriceInStatesView: View {
    @Environment(\.managedObjectContext) var moc
    @State var selectedState: States = .AZ
    @ObservedObject var webVM: jsonWebVM
    
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                HStack {
                    Text("Select State: ").font(.title2)
                    Picker("States", selection: $selectedState) {
                        ForEach(States.allCases, id: \.self) { state in
                            Text(state.rawValue)
                        }
                    }.pickerStyle(.menu)
                }.padding()
                
                Button{
                    webVM.getJsonData()
                }label: {
                    Text("Search Gas Price")
                }.buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .padding()
                    ForEach(0..<webVM.stateName.count, id: \.self) {
                        index in
                        VStack {
                            if(selectedState.rawValue == webVM.stateName[index]) {
                                Text("Regular: \(webVM.regularPrice[index])").foregroundColor(.black)
                                Text("MidGrade: \(webVM.midGradePrice[index])").foregroundColor(.black)
                                Text("Premium: \(webVM.premiumPrice[index])").foregroundColor(.black)
                                Text("Diesel: \(webVM.dieselPrice[index])").foregroundColor(.black)
                            }
                        }
                    }
                Spacer()
                Button {
                    let newPrice = Price(context: moc)
                    for index in 0..<webVM.stateName.count {
                        if(selectedState.rawValue == webVM.stateName[index]) {
                            newPrice.state = selectedState.rawValue
                            newPrice.regular = webVM.regularPrice[index]
                            newPrice.midgrade = webVM.midGradePrice[index]
                            newPrice.premium = webVM.premiumPrice[index]
                            newPrice.diesel = webVM.dieselPrice[index]
                            
                            try? moc.save()
                        }
                    } 
                }label: {
                    Text("Add To Favorite List")
                }.buttonStyle(.borderedProminent)
                    .tint(.red)
                NavigationLink(destination: FavoriteView(selectedState: $selectedState, webVM: jsonWebVM())) {
                    Text("Favorite List")
                }
            }
        }
    }
}

#Preview {
    PriceInStatesView(webVM: jsonWebVM())
}
