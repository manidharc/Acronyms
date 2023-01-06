//
//  AcronymFeedModel.swift
//  Acronyms
//
//  Created by Manidhar Gupta Chittanuri on 1/6/23.
//

import Foundation

struct AcronymsSFFeed: Codable {
    var sf: String
    var lfs:[LfsObject]
}

struct LfsObject: Codable {
    var lf: String
    var freq: Int
    var since: Int
    var vars: [VarsObject]
}

struct VarsObject: Codable {
    var lf: String
    var freq: Int
    var since: Int
}
