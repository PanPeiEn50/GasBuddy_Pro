//
//  jsonWebVM.swift
//  GasBuddyPro
//
//  Created by David on 11/22/23.
//

import Foundation

struct gasPriceData : Decodable
{
    let success: Bool
    let result: result
}

struct result: Decodable
{
    let state: state
    let cities: [city]
}

struct state: Decodable
{
    let name: String
    let regular: String?
    let midGrade: String
    let premium: String
    let diesel: String
    
    /*enum CodingKeys: String, CodingKey {
            case name
            case regular
            case midGrade = "midGrade"
            case premium
            case diesel
    }*/
}

struct city: Decodable
{
    let regular: String?
    let midGrade: String
    let premium: String
    let diesel: String
    let name: String
}

class jsonWebVM : ObservableObject
{
    @Published var cityName:[String] = []
    @Published var regularPrice:[String] = []
    @Published var midGradePrice:[String] = []
    @Published var premiumPrice:[String] = []
    @Published var dieselPrice:[String] = []
    
    init() {
        cityName = []
        regularPrice = []
        midGradePrice = []
        premiumPrice = []
        dieselPrice = []
    }
    
    func getJsonData(state:String) {
        let headers = [
          "content-type": "application/json",
          "authorization": "apikey 2hWpAnmiX429JRA8Q39VMS:59mOhoQG5eHXLWs5Hgz88W"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/gasPrice/stateUsaPrice?state=\(state)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
              }
                
            do {
                let httpResponse = response as? HTTPURLResponse
                //print(httpResponse)
                let decodedData = try JSONDecoder().decode(gasPriceData.self, from: data!)
                    
                DispatchQueue.main.async {
                    self.cityName.removeAll()
                    self.regularPrice.removeAll()
                    self.midGradePrice.removeAll()
                    self.premiumPrice.removeAll()
                    self.dieselPrice.removeAll()
                    let numberOfCitiesToStore = decodedData.result.cities.count
                        
                    for index in 0..<numberOfCitiesToStore {
                        self.cityName.append(decodedData.result.cities[index].name)
                        self.regularPrice.append(decodedData.result.cities[index].regular ?? "No Data Currently :(")
                        self.midGradePrice.append(decodedData.result.cities[index].midGrade)
                        self.premiumPrice.append(decodedData.result.cities[index].premium)
                        self.dieselPrice.append(decodedData.result.cities[index].diesel)
                    }
                }
            } catch {
                print("error: \(error)")
            }
        })

        dataTask.resume()
        }
}
