//
//  NetworkError.swift
//  CoreNetworkInterfcae
//
//  Created by 정지훈 on 12/26/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURLError
    case invalidResponseError
    case authorizationError
    case badRequestError
    case serverError
    case decodingError
    case encodingError
    case unknownError
}

extension NetworkError {
    var errorMessage: String {
        switch self {
        case .invalidURLError:
            return "유효하지 않은 URL입니다."

        case .invalidResponseError:
            return "유효하지 않은 응답입니다."

        case .authorizationError:
            return "인증에 실패했습니다."

        case .badRequestError:
            return "요청이 올바르지 않습니다."

        case .serverError:
            return "서버 에러입니다."

        case .decodingError:
            return "디코딩 에러입니다."

        case .encodingError:
            return "인코딩 에러입니다."

        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
