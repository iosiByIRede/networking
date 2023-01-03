import Foundation

// End-Point example
struct Auth {
    struct Request: Encodable {
        let username, password: String
    }

    struct Response: Decodable {
        let token: String
    }
}

extension Auth.Request: RequestTemplate {
    typealias Response = Auth.Response

    var url: URL? {
        var components = Server.v1
        components.path += self.path
        return components.url
    }

    var method: HTTPMethod { .post }

    var path: String { "/login" }

    var headers: [String: String] { ["Content-Type": "application/json"] }
}
