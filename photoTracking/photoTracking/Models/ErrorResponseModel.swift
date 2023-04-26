//
//  ErrorResponseModel.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

import Foundation

struct ErrorResponseModel: Codable {
    let stat: String
    let code: Int
    let message: String
}
