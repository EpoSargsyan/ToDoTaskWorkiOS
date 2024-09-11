//
//  ApiLogger.swift
//
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation

extension URLRequest {
    func log() {
        if CommandLine.arguments.contains("-disable-network-log") {
            return
        }

        let urlString = url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = httpMethod != nil ? "\(httpMethod ?? "")" : ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n>>================= REQUEST =================>>\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key, value) in allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = httpBody {
            requestLog += "\n\(body.prettyPrintedJSONString ?? "")\n"
        }

        requestLog += "\n>>===========================================>>\n";
        print(requestLog)
    }
}

extension HTTPURLResponse {
    func log(data: Data?, error: Error?) {
        if CommandLine.arguments.contains("-disable-network-log") {
            return
        }

        let urlString = url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<<================= RESPONSE =================<<\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        let statusColorSign = (statusCode >= 200 && statusCode < 300) ? "🟢" : "🔴"
        responseLog += "HTTP \(statusColorSign) \(statusCode) \(path)?\(query)\n"
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        for (key, value) in allHeaderFields {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data {
            responseLog += "\n>>=================DATA===================<<\n"
            responseLog += "\n\(body.prettyPrintedJSONString ?? "")\n"
        }
        if error != nil {
            responseLog += "\n 🔺 Error: \(error?.localizedDescription ?? "")\n"
        }

        responseLog += "<<===========================================<<\n";
        print(responseLog)
    }
}

//MARK: - This extension created for define the property prettyPrintedJSON String for print in the terminal information from data

public extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }

        return prettyPrintedString
    }
}
