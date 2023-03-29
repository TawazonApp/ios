//
//  HTTPRequest.DecodableResponse.swift
//  Adapty
//
//  Created by Aleksei Valiano on 15.09.2022.
//

import Foundation

protocol HTTPRequestWithDecodableResponse: HTTPRequest {
    associatedtype ResponseBody: Decodable
    typealias Result = HTTPResponse<ResponseBody>.Result
    func getDecoder(_: JSONDecoder) -> ((HTTPDataResponse) -> HTTPResponse<ResponseBody>.Result)
}

extension HTTPRequestWithDecodableResponse {
    func getDecoder(_ jsonDecoder: JSONDecoder) -> ((HTTPDataResponse) -> HTTPResponse<ResponseBody>.Result) {
        { response in
            jsonDecoder.decode(ResponseBody.self, response)
        }
    }
}

extension HTTPSession {
    @discardableResult
    final func perform<Request: HTTPRequestWithDecodableResponse>(
        _ request: Request,
        queue: DispatchQueue? = nil,
        _ completionHandler: @escaping (Request.Result) -> Void
    ) -> HTTPCancelable {
        let decoder = request.getDecoder(configuration.decoder)
        return perform(request,
                       queue: queue,
                       decoder: decoder,
                       completionHandler)
    }
}

extension JSONDecoder {
    func decode<T>(_ type: T.Type, _ data: Data?) -> Result<T, Error> where T: Decodable {
        guard let data = data, !data.isEmpty else {
            return .failure(DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data is nil or empty.")))
        }
        let result: T
        do {
            result = try decode(type, from: data)
        } catch let e {
            return .failure(e)
        }

        return .success(result)
    }

    func decode<T>(_ type: T.Type, _ response: HTTPDataResponse) -> HTTPResponse<T>.Result where T: Decodable {
        decode(type, response.body)
            .map { response.replaceBody($0) }
            .mapError { .decoding(response, error: $0) }
    }
}
