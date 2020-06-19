//
//  itemModel.swift
//  tbc-branches
//
//  Created by Admin on 6/19/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation

struct ATMBranch: Codable {
    var nameGe: String
    var nameEn: String
    var addressGe: String
    var addressEn: String
    var lat: String
    var lng: String
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case nameGe = "name_ge"
        case nameEn = "name_En"
        case addressGe = "address_ge"
        case addressEn = "address_en"
        case lat = "latitude"
        case lng = "longtitude"
        case type = "object_type_id"
    }
}
