// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

protocol APIRequest {
    associatedtype Body: Encodable
    associatedtype Result: Decodable

    var data: APIRequestData<Body> { get }
}

class NoBody: Encodable {}
class NoResult: Decodable {}

enum Method: String {
    case get = "GET"
    case post = "POST"
}

struct APIRequestData<Body: Encodable> {
    let path: String
    let method: Method
    let queryItems: [String: [String]]
    let headers: [String: String]
    let body: Body?
    let statusErrors: [Int: LBError]

    init(path: String,
         method: Method,
         queryItems: [String: [String]] = [:],
         headers: [String: String] = [:],
         body: Body? = nil,
         statusErrors: [Int: LBError] = [:]) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.statusErrors = statusErrors
    }
}
