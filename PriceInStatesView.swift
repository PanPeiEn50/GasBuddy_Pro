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
    @State var selectedState: States = .AZ
    @State var selectedCity: String = ""
    @ObservedObject var webVM: jsonWebVM
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Text("Select State: ")
                    Picker("States", selection: $selectedState) {
                        ForEach(States.allCases, id: \.self) { state in
                            Text(state.rawValue)
                        }
                    }.pickerStyle(.menu)
                }.padding()
                
                Spacer()
                HStack {
                    Text("Select City: ")
                    TextField("City Name", text: $selectedCity)
                }.frame(maxWidth: .infinity)
                    .padding()
                
                Spacer()
                
                Button{
                    webVM.getJsonData(state: selectedState.rawValue)
                }label: {
                    Text("Search Gas Price")
                }.buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .padding()
                
                Spacer()
                
                List {
                    ForEach(0..<webVM.cityName.count, id: \.self) {
                        index in
                        VStack(alignment: .leading) {
                            if(selectedCity == webVM.cityName[index]) {
                                Text("Regular: \(webVM.regularPrice[index])").foregroundColor(.black)
                                Text("MidGrade: \(webVM.midGradePrice[index])").foregroundColor(.black)
                                Text("Premium: \(webVM.premiumPrice[index])").foregroundColor(.black)
                                Text("Diesel: \(webVM.dieselPrice[index])").foregroundColor(.black)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PriceInStatesView(webVM: jsonWebVM())
}
