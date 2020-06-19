//
//  APIServices.swift
//  real-estate
//
//  Created by Admin on 6/12/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation

struct properties: Codable {
  let properties : [villaInfo]
}
struct villaInfo: Codable {
  let prop_status  :String
  let price     :Int
  let baths     :Int?
  let beds     :Int?
  let agents    :[agents]
  let building_size :buildingSize?
  let address :Address?
  let thumbnail   :String?
}
struct buildingSize: Codable {
  let size : Int
}

struct Address: Codable {
    let city: String?
}
struct agents :Codable {
  let name: String
}
struct APIResponse {
  func getBands(completion: @escaping (properties)->()){
      guard let url = URL(string: "https://run.mocky.io/v3/12f8dc9f-0ef0-42ca-9b21-b50a7ef57d1b") else{return}
      URLSession.shared.dataTask(with: url){(data,res,err) in
      guard let data = data else{return}
      do{
        let decoder = JSONDecoder()
        let response = try decoder.decode(properties.self, from: data)
        completion(response)
      }catch{print(error.localizedDescription)}
      }.resume()
    }
}

