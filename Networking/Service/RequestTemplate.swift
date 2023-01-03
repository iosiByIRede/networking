//
//  RequestTemplate.swift
//  IOSI
//
//  Created by Pedro Sousa on 10/11/22.
//

import Foundation

protocol RequestTemplate {
    associatedtype Response

    var url: URL? { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryItems: [String: String] { get }
    var data: Data? { get }

    func decode(_ data: Data) throws -> Response
}

extension RequestTemplate {
    var headers: [String: String] { [:] }
    var queryItems: [String: String] { [:] }
    var data: Data? { nil }
}

extension RequestTemplate where Self: Encodable {
    var data: Data? { try? JSONEncoder().encode(self) }
}

extension RequestTemplate where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
