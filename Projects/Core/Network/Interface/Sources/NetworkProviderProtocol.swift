//
//  NetworkProviderProtocol.swift
//  CoreNetworkInterfcae
//
//  Created by 정지훈 on 12/26/25.
//

import Foundation

public protocol NetworkProviderProtocol {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}
