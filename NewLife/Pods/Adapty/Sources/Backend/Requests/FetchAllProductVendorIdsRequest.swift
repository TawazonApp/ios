//
//  FetchAllProductVendorIdsRequest.swift
//  Adapty
//
//  Created by Aleksei Valiano on 23.09.2022.
//

import Foundation

struct FetchAllProductVendorIdsRequest: HTTPRequestWithDecodableResponse {
    typealias ResponseBody = Backend.Response.Body<[String]?>
    let endpoint = HTTPEndpoint(
        method: .get,
        path: "/sdk/in-apps/products-ids/"
    )
    let headers: Headers

    func getDecoder(_ jsonDecoder: JSONDecoder) -> ((HTTPDataResponse) -> HTTPResponse<ResponseBody>.Result) {
        { response in
            let result: Result<[String]?, Error>

            if headers.hasSameBackendResponseHash(response.headers) {
                result = .success(nil)
            } else {
                result = jsonDecoder.decode(Backend.Response.ValueOfData<[String]>.self, response.body).map { $0.value }
            }
            return result.map { response.replaceBody(Backend.Response.Body($0)) }
                .mapError { .decoding(response, error: $0) }
        }
    }

    init(profileId: String, responseHash: String?) {
        headers = Headers()
            .setBackendProfileId(profileId)
            .setBackendResponseHash(responseHash)
    }
}

extension HTTPSession {
    func performFetchAllProductVendorIdsRequest(profileId: String,
                                                responseHash: String?,
                                                _ completion: @escaping AdaptyResultCompletion<VH<[String]?>>) {
        let request = FetchAllProductVendorIdsRequest(profileId: profileId,
                                                      responseHash: responseHash)

        perform(request) { (result: FetchAllProductVendorIdsRequest.Result) in
            switch result {
            case let .failure(error):
                completion(.failure(error.asAdaptyError))
            case let .success(response):
                completion(.success(VH(response.body.value, hash: response.headers.getBackendResponseHash())))
            }
        }
    }
}
