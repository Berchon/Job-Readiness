//
//  APIError.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 15/09/22.
//

import Foundation

enum APIError: String, Error {
    case NetworkBadRequest = "Resource not Found"
    case NetworkResponseError = "Error validating grant. Your authorization code or refresh token may be expired or it was already used"
    case NetworkInvalidData = "Invalid data"
    case NetworkTokenNotFound = "Token not found"
    case NetworkInvalidUrl = "Invalid URL"
    case InternalError
    case ServiceUnavailable
}
