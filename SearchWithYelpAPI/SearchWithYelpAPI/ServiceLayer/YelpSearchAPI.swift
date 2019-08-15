//
//  YelpSearchAPI.swift
//  SearchWithYelpAPI
//
//  Created by Krishna  on 8/13/19.
//  Copyright © 2019 Krishna . All rights reserved.
//


import Foundation
import UIKit

enum HttpType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}


class YelpSearchAPI {
    private static let _defaultSession = URLSession(configuration: .default)
    
    private static var _dataTask: URLSessionDataTask?
    
    private static let Limit = 50 

}
extension YelpSearchAPI {
    
    private func requestHeader() -> [String : String] {
        let dic = [ServiceUtility.Authorization: ServiceUtility.AuthorizationCode]
        return dic
    }
    
    func getDataFromApi(location:String?, searchTerm: String?,offset:Int?, completion: @escaping((Result<YelpSearchModel>) -> Void)) {
        
        //Construct URL
        guard let location = location, let searchTerm = searchTerm, let offset = offset else {
            return
        }
        //Construct URL
        let finalUrl = "\(ServiceUtility.serviceURL)"+"term=\(searchTerm)"+"&location=\(location)&limit=\(ServiceUtility.limit)"+"&offset=\(String(describing: offset))"
        guard let searchURL = URL(string: finalUrl) else {
            return
        }
        
        // Configering request with the Url
        var request = URLRequest(url: searchURL)
        request.httpMethod = HttpType.get.rawValue
        request.allHTTPHeaderFields = self.requestHeader()
        
        //Start the data task
        YelpSearchAPI._dataTask = YelpSearchAPI._defaultSession.dataTask(with: request,
                                                                                     completionHandler: { (data,  response, error) in
                                                                                        //Decode the data and map to object
                                                                                        if let httpResponse = response as? HTTPURLResponse {
                                                                                            let statusCode = httpResponse.statusCode
                                                                                                let result = YelpSearchAPI.processApiRequest(data: data, error: error, statusCode: statusCode)
                                                                                                OperationQueue.main.addOperation {
                                                                                                    completion(result)
                                                                                                }
                                                                                            
                                                                                        }
                                                                                        
        })
        YelpSearchAPI._dataTask?.resume()
    }
    
    static func processApiRequest( data: Data?, error: Swift.Error?, statusCode: Int ) -> Result<YelpSearchModel> {
        if let error = error {
            return .failure(Error.requestFailed(reason: error.localizedDescription))
        }
        guard let data = data else {
            return .failure(Error.noData)
        }
        let decoder = JSONDecoder()
        do {
            if statusCode == 400 {
                let list = try decoder.decode(YelpErrorModel.self, from: data)
                return .failure(Error.requestFailed(reason: list.error.errorDescription))
            }else{
                let list = try decoder.decode(YelpSearchModel.self, from: data)
                return .success(list)
            }
        }
        catch {
            return .failure(Error.jsonSerializationFailed(reason: ErrorMessage.jsonParsingError))
        }
    }
    
    
}

extension YelpSearchAPI {
    enum Error: Swift.Error {
        case noData
        case jsonSerializationFailed(reason: String)
        case requestFailed(reason: String)
    }
}


extension YelpSearchAPI.Error: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data returned with response"
        case .jsonSerializationFailed(let reason):
            return reason
        case .requestFailed(let reason):
            return reason
        }
    }
}

