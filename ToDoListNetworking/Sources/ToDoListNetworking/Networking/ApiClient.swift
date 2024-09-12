//
//  ApiClient.swift
//
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation

public protocol IApiClient {
    func asyncRequest<T: Decodable>(endpoint: IEndpointProvider, responseModel: T.Type) async throws -> T
    func asyncUpload<T: Decodable>(endpoint: IEndpointProvider, responseModel: T.Type) async throws -> T
    func asyncDownload(endpoint: IEndpointProvider) async throws -> URL
    func asyncDownload(fileURL: URL) async throws -> URL
}

final public class ApiClient: IApiClient {
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30 // seconds that a task will wait for data to arrive
        configuration.timeoutIntervalForResource = 60 // seconds for whole resource request to complete ,.
        return URLSession(configuration: configuration)
    }
    
    public init() {}

    public func asyncRequest<T: Decodable>(endpoint: IEndpointProvider, responseModel: T.Type) async throws -> T {
        do {
            let urlRequest = try endpoint.asURLRequest()
#if DEBUG
            urlRequest.log()
#endif
            let (data, response) = try await session.data(for: urlRequest)
#if DEBUG
            (response as? HTTPURLResponse)?.log(data: data, error: nil)
#endif
            return try self.manageResponse(data: data, response: response)
        } catch let error as ApiError { // 3
            throw error
        } catch {
            throw ApiError(message: "Unknown API error \(error.localizedDescription)")
        }
    }

    public func asyncUpload<T: Decodable>(endpoint: IEndpointProvider, responseModel: T.Type) async throws -> T {
        guard let uploadData = endpoint.uploadData else {
            throw ApiError(message: "Failed to upload data")
        }
        do {
            let (data, response) = try await session.upload(for: endpoint.asURLRequest(), from: uploadData)
            return try self.manageResponse(data: data, response: response)
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError(message: "Unknown API error \(error.localizedDescription)")
        }
    }

    public func asyncDownload(endpoint: IEndpointProvider) async throws -> URL {
        do {
            let response = try await session.download(for: endpoint.asURLRequest())
            return response.0
        } catch {
            throw ApiError(message: "Failed to download")
        }
    }

    public func asyncDownload(fileURL: URL) async throws -> URL {
        do {
            let response = try await session.download(from: fileURL)
            return response.0
        } catch {
            throw ApiError(message: "Failed to download")
        }
    }
}

private extension ApiClient {
    func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw ApiError(message: "Invalid HTTP response")
        }
        switch response.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw ApiError(message: "Error decoding data: \(error.localizedDescription)")
            }
        case 401:
            //NotificationCenter.default.post(name: .terminateSession, object: nil)
            throw ApiError(statusCode: response.statusCode, message: "Unauthorized")
        default:
            guard let decodedError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                throw ApiError(statusCode: response.statusCode, message: "Unknown API error")
            }
            // MARK: - Handle expired token case later
            throw ApiError(statusCode: response.statusCode, message: decodedError.message)
        }
    }
}
