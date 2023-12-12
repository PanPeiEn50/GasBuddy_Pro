//
//  ContentView.swift
//  GasBuddyPro
//
//  Created by David on 11/20/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var prices: FetchedResults<Price>
    @State private static var defaultLocation = CLLocationCoordinate2D(
        latitude: 33.4255,
        longitude: -111.9400
    )
    @State private var region = MKCoordinateRegion(
        center: defaultLocation,
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    @State private var markers = [
        Location(name: "Tempe", coordinate: defaultLocation)
    ]
    
    @State private var searchText = ""
    @State private var gasStation = "Gas Station"
    @State var isShowingSheet = false
    @State var selectedGasStation: GasStationType = .arco
    @StateObject var webVM: jsonWebVM
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.follow),
                    annotationItems: markers
                ){ location in
                        MapMarker(coordinate: location.coordinate)
                }.frame(width: 400, height: 300)
                
                Spacer()
                
                Text("Enter Address: ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 24))
                
                HStack {
                    Button {
                        let searchRequest = MKLocalSearch.Request()
                        searchRequest.naturalLanguageQuery = searchText
                        searchRequest.region = region
                        
                        MKLocalSearch(request: searchRequest).start { response, error in
                            guard let response = response else {
                                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                                return
                            }
                            region = response.boundingRegion
                            markers = response.mapItems.map { item in
                                Location(
                                    name: item.name ?? "",
                                    coordinate: item.placemark.coordinate
                                )
                            }
                        }
                    } label: {
                        Image(systemName: "location.magnifyingglass")
                            .resizable()
                            .foregroundColor(.accentColor)
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 12)
                    }
                    TextField("Address", text: $searchText)
                        .foregroundColor(.white)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button {
                    let searchRequest = MKLocalSearch.Request()
                    searchRequest.naturalLanguageQuery = gasStation
                    searchRequest.region = region
                    
                    MKLocalSearch(request: searchRequest).start { response, error in
                        guard let response = response else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error").")
                            return
                        }
                        region = response.boundingRegion
                        markers = response.mapItems.map { item in
                            Location(
                                name: item.name ?? "",
                                coordinate: item.placemark.coordinate
                            )
                        }
                    }
                }label: {
                    Text("Find Gas Station Nearby")
                }.buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.blue)
                
                Button {
                    isShowingSheet.toggle()
                } label: {
                    Text("Filter")
                }.buttonStyle(.borderedProminent)
                    .tint(.pink)
                    .sheet(isPresented: $isShowingSheet) {
                        VStack {
                            HStack{
                                Text("Brand: ").font(.title2)
                                Picker("Gas Station", selection: $selectedGasStation) {
                                    ForEach(GasStationType.allCases, id: \.self) { gasStation in
                                        Text(gasStation.rawValue)
                                    }
                                }.pickerStyle(.menu)
                            }
                            Button {
                                gasStation = selectedGasStation.rawValue
                                isShowingSheet.toggle()
                            } label: {
                                Text("Save").bold()
                            }.buttonStyle(.borderedProminent)
                                .tint(.red)
                        }.presentationDetents([.medium, .medium])
                    }
                
                Spacer()
                
                NavigationLink(destination: PriceInStatesView(webVM: jsonWebVM())) {
                    Text("Gas Prices in Other States")
                }
            }
        }
    }
}

#Preview {
    ContentView(webVM: jsonWebVM())
}
