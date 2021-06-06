//
//  NumberModel.swift
//  uniqueNumberMVVM
//
//  Created by Neria Jerafi on 23/02/2021.
//

import Foundation

struct NumberModel: Decodable {
    let numbers: [Number]?
}


struct Number: Decodable {
    let number: Int?
}
