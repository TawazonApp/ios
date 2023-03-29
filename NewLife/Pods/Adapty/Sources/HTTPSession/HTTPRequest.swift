//
//  HTTPRequest.swift
//  Adapty
//
//  Created by Aleksei Valiano on 11.08.2022.
//

import Foundation

protocol HTTPRequest {
    typealias Headers = [String: String]

    var endpoint: HTTPEndpoint { get }
    var headers: Headers { get }
    var queryItems: QueryItems { get }
    var forceLogCurl: Bool { get }
}

protocol HTTPDataRequest: HTTPRequest {
    func getData(configuration: HTTPConfiguration) throws -> Data?
}

protocol HTTPRequestAdditionals: Sendable {
    var headers: HTTPRequest.Headers? { get }
    var queryItems: HTTPRequest.QueryItems? { get }
}

extension HTTPRequest {
    var path: HTTPEndpoint.Path { endpoint.path }
    var method: HTTPMethod { endpoint.method }
    var headers: Headers { [:] }
    var queryItems: QueryItems { [] }
    var forceLogCurl: Bool { false }
}

private enum HeaderKey {
    static let contentType: String = "Content-Type"
}

enum HTTPRequestError: Error {
    case wrongEncodingUrl
}

extension HTTPRequest {
    func tryConvertToURLRequest(configuration: HTTPCodableConfiguration, additionals: HTTPRequestAdditionals?) -> Result<URLRequest, HTTPError> {
        let preUrl = configuration.baseURL.appendingPathComponent(endpoint.path)

        guard var urlComponents = URLComponents(url: preUrl, resolvingAgainstBaseURL: false) else {
            return .failure(HTTPError.perform(endpoint, error: HTTPRequestError.wrongEncodingUrl))
        }

        var queryItems = self.queryItems
        if let additionalsQueryItems = additionals?.queryItems {
            queryItems.append(contentsOf: additionalsQueryItems)
        }

        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            return .failure(HTTPError.perform(endpoint, error: HTTPRequestError.wrongEncodingUrl))
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        var requestHeaders = headers

        additionals?.headers?.forEach { requestHeaders[$0] = $1 }

        if !requestHeaders.isEmpty {
            request.allHTTPHeaderFields = requestHeaders
        }

        if let params = self as? HTTPDataRequest {
            do {
                request.httpBody = try params.getData(configuration: configuration)
            } catch let error {
                return .failure(HTTPError.perform(endpoint, error: error))
            }
        }

        if request.httpBody != nil, request.value(forHTTPHeaderField: HeaderKey.contentType)?.isEmpty ?? true {
            request.setValue(configuration.defaultEncodedContentType, forHTTPHeaderField: HeaderKey.contentType)
        }

        return .success(request)
    }
}
