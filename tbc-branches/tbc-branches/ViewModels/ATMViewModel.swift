//
//  ATMViewModel.swift
//  tbc-branches
//
//  Created by Admin on 6/19/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation

class ATMViewModel {
    
    public var getObjects = { (completion: @escaping ([ATMBranch]) -> ()) in
        var objects = [ATMBranch]()
        let service = APIService()
        
        service.fetchObjects { (c) in
            objects.append(contentsOf: c.filter({ $0.type == "1" }))
            completion(objects)
        }
        
    }
}
