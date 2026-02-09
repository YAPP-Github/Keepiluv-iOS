//
//  MockTokenManager.swift
//  DomainAuthTesting
//
//  Created by Jiyong on 2/9/26.
//

import DomainAuthInterface
import Foundation

public actor MockTokenManager {
    public var mockAccessToken: String?
    public var mockRefreshToken: String?

    public init(
        accessToken: String? = nil,
        refreshToken: String? = nil
    ) {
        self.mockAccessToken = accessToken
        self.mockRefreshToken = refreshToken
    }

    public var accessToken: String? {
        mockAccessToken
    }

    public var refreshToken: String? {
        mockRefreshToken
    }

    public func setAccessToken(_ token: String?) {
        mockAccessToken = token
    }

    public func setRefreshToken(_ token: String?) {
        mockRefreshToken = token
    }
}
