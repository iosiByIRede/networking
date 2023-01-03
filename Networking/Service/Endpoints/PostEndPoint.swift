//
//  PostEndPoint.swift
//  Networking
//
//  Created by Pedro on 03/01/23.
//

import Foundation

struct Post: Codable {
    struct Request {
        let postID: Int
    }

    struct Response: Decodable {
        let userId: Int
        let identifier: Int
        let title: String
        let body: String

        enum CodingKeys: String, CodingKey {
            case userId
            case identifier = "id"
            case title
            case body
        }
    }
}

extension Post.Request: RequestTemplate {
    typealias Response = Post.Response

    var url: URL? {
        var components = Server.v1
        components.path += self.path
        return components.url
    }
    
    var method: HTTPMethod { .get }
    
    var path: String { "/\(self.postID)" }
}
