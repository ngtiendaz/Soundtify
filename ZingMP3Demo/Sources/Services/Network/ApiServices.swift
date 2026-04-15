//
//  ApiServices.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import Foundation

enum HttpMethod: String
{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


class ApiServices {
    static let shared = ApiServices()
    private init() {}
    
    func request<T: Codable> (url: String, method: HttpMethod = .get , body: Data? = nil ) async -> T?{
        guard let url = URL(string: url) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("aplication/josn", forHTTPHeaderField: "Content-Type")
        request.setValue("aplication/josn", forHTTPHeaderField: "Accept")
        
        if let body = body{
            request.httpBody = body
        }
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode)
            {
                print("Server trả về lỗi: \(httpResponse.statusCode)")
                return nil
            }
//            let jsonString = String(data: data, encoding: .utf8)
//            print("JSON thô: \(jsonString ?? "")")
            
//            print(String(data: data, encoding: .utf8) ?? "")
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        }catch{
            print("Lỗi trong quá trình lấy dữ liệu: \(error)")
            return nil
        }
        
    }
}
