import Foundation
import SwiftyJSCore

public actor Readability {
    private let interpreter: JSInterpreter

    public init() async throws {
        interpreter = try await JSInterpreter()
        guard let url = Bundle.module.url(forResource: "readability", withExtension: "js", subdirectory: "Resources") else {
            throw ReadabilityError.missingResource
        }
        try await interpreter.evaluateFile(url: url)
    }

    public func parse(html: String, url: String? = nil) async throws -> ReadabilityArticle? {
        try await interpreter.setObject(html, forKey: "_vin_html")
        try await interpreter.setObject(url, forKey: "_vin_url")
        return try await interpreter.eval(
            "parseReadability(_vin_html, _vin_url)"
        )
    }

    public func isProbablyReaderable(html: String) async throws -> Bool {
        try await interpreter.setObject(html, forKey: "_vin_html")
        return try await interpreter.eval(
            "isProbablyReaderable(_vin_html)"
        )
    }
}

public enum ReadabilityError: Error {
    case missingResource
}
