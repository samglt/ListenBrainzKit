// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

struct RadioTagsRequest: APIRequest {
    typealias Result = [LBRadioTag]

    let data: APIRequestData<NoBody>

    init(tags: [String], operation: LBOperator?, minPop: Int, maxPop: Int, count: Int?) {
        var query = [String: [String]]()
        query["tag"] = tags
        query.setQueryItem("operator", value: operation?.rawValue)
        query.setQueryItem("pop_begin", value: max(min(minPop, 100), 0))
        query.setQueryItem("pop_end", value: max(min(maxPop, 100), 0))
        query.setQueryItem("count", value: count)

        self.data = .init(path: "/1/lb-radio/tags",
                          method: .get,
                          queryItems: query,
                          statusErrors: [400: .invalidParam])
    }
}
