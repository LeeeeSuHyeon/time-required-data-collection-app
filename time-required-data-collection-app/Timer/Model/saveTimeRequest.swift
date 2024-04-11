//
//  saveTimeResponse.swift
//  time-required-data-collection-app
//
//  Created by 이수현 on 4/4/24.
//

import Foundation

struct saveTimeRequest : Encodable {
    var node1 : String
    var node2 : String
    var birthYear : Int
    var gender : Int
    var height : Double
    var weight : Double
    var walkSpeed : Int
    var temperature : Double
    var precipitationProbability : Double
    var precipitation : Double
    var takeTime : Double
}
