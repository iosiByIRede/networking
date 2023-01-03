//
//  Server.swift
//  IOSI
//
//  Created by Pedro Sousa on 11/11/22.
//
// swiftlint:disable identifier_name

import Foundation

struct Server {
    static let v1: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = "/posts"
        return components
    }()
}
