//
//  StatusCode.swift
//  CoreNetworkInterface
//
//  Created by 정지훈 on 12/29/25.
//

import Foundation

enum HTTPStatusCode {
    static let success = 200...299
    static let badRequest = 400
    static let unauthorized = 401
    static let serverError = 500...599
}
