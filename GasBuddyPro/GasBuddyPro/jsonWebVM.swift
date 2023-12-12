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
    let result: [result]
}

struct result: Decodable
{
    let name: String?
    let regular: String?
    let midGrade: String?
    let premium: String?
    let diesel: String?
}

class jsonWebVM : ObservableObject
{
    @Published var stateName:[String] = []
    @Published var regularPrice:[String] = []
    @Published var midGradePrice:[String] = []
    @Published var premiumPrice:[String] = []
    @Published var dieselPrice:[String] = []
    
    init() {
        stateName = []
        regularPrice = []
        midGradePrice = []
        premiumPrice = []
        dieselPrice = []
    }
    
    func getJsonData() {
        let headers = [
          "content-type": "application/json",
          "authorization": "apikey 2hWpAnmiX429JRA8Q39VMS:59mOhoQG5eHXLWs5Hgz88W"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/gasPrice/allUsaPrice")! as URL,
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
                    self.stateName.removeAll()
                    self.regularPrice.removeAll()
                    self.midGradePrice.removeAll()
                    self.premiumPrice.removeAll()
                    self.dieselPrice.removeAll()
                    let numberOfCitiesToStore = decodedData.result.count
                        
                    for index in 0..<numberOfCitiesToStore {
                        self.stateName.append(decodedData.result[index].name ?? "No Data Currently :(")
                        self.regularPrice.append(decodedData.result[index].regular ?? "No Data Currently :(")
                        self.midGradePrice.append(decodedData.result[index].midGrade ?? "No Data Currently :(")
                        self.premiumPrice.append(decodedData.result[index].premium ?? "No Data Currently :(")
                        self.dieselPrice.append(decodedData.result[index].diesel ?? "No Data Currently :(")
                    }
                }
            } catch {
                print("error: \(error)")
            }
        })

        dataTask.resume()
        }
}
