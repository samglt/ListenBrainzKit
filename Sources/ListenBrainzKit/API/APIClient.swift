// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

protocol APIClient: Sendable {
    func execute<Request: APIRequest>(_ request: Request) async throws -> Request.Result
}

struct ListenBrainzAPIClient: APIClient {
    let token: String
    let root: URL

    init(token: String, root: URL?) {
        self.token = token
        self.root = root ?? URL(string: "https://api.listenbrainz.org")!
    }

    func execute<Request: APIRequest>(_ request: Request) async throws -> Request.Result {
        let url = root
            .appending(component: request.data.path)
            .appending(queryItems: request.data.queryItems.flatMap { entry in
                entry.value.map { URLQueryItem(name: entry.key, value: $0) }
            })

        var req = URLRequest(url: url)
        req.httpMethod = request.data.method.rawValue
        req.addValue("Token \(token)", forHTTPHeaderField: "Authorization")

        for (header, value) in request.data.headers {
            req.addValue(value, forHTTPHeaderField: header)
        }

        if let body = request.data.body {
            let bodyData = try JSONEncoder.ListenBrainz.encode(body)
            req.httpBody = bodyData
        }

        let httpClient = URLSession(configuration: URLSessionConfiguration.default)
        let (data, resp) = try await httpClient.data(for: req)

        if let httpResp = resp as? HTTPURLResponse,
           httpResp.statusCode != 200 {
            let code = httpResp.statusCode
            if code == 429 {
                let resetIn = Int(httpResp.allHeaderFields["x-ratelimit-reset-in"] as? String ?? "")
                throw LBError.rateLimited(resetIn: resetIn ?? 10)
            }
            throw request.data.statusErrors[httpResp.statusCode] ?? .unknownError
        }

        return try JSONDecoder.ListenBrainz.decode(Request.Result.self, from: data)
    }
}
