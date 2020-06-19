//
//  APIServices.swift
//  tbc-branches
//
//  Created by Admin on 6/19/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation

class APIService {
    func fetchObjects(completion: @escaping ([ATMBranch]) -> ()){
        guard let url = URL(string: "https://run.mocky.io/v3/96016c7a-9b7a-4b7a-997e-3ebc860516a5") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                var objects = [ATMBranch]()
                if let object = json as? Dictionary<String, AnyObject> {
                    
                    if let categoryList = object["objects"] {
                        for item in categoryList as! [Dictionary<String, String>] {
                            objects.append(ATMBranch(nameGe: item["name_ge"]!, nameEn: item["name_en"]!, addressGe: item["address_ge"]!, addressEn: item["address_en"]!, lat: item["latitude"]!, lng: item["longtitude"]!, type: item["object_type_id"]!))
                        }
                    }
                }
                completion(objects)
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
}
