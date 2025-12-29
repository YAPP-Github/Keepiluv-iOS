//
//  HTTPStatusCode.swift
//  CoreNetworkInterface
//
//  Created by 정지훈 on 12/29/25.
//

import Foundation

public enum HTTPStatusCode {
    public static let success = 200...299
    public static let badRequest = 400
    public static let unauthorized = 401
    public static let serverError = 500...599
}
