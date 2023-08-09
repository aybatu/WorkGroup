//
//  UpdateAccountService.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 29/07/2023.
//

import Foundation

class UpdateAccountService {
    
    func updateAccount(companyRegistrationNumber: String, request: UpdateUserAccountRequest, completion: @escaping (Bool, String?) -> Void) {
        let urlString = "http://3.72.4.71:8080/\(companyRegistrationNumber)/updateUserAccount" // Replace with your actual API endpoint
        
        guard let url = URL(string: urlString) else {
            completion(false, "Invalid URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Invalid response")
                    return
                }
               
                if httpResponse.statusCode == 200 {
                    // Account update successful
                    completion(true, nil)
                } else {
                    // Account update failed
                    let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Account update failed"
                    completion(false, errorMessage)
                }
            }.resume()
        } catch {
            completion(false, error.localizedDescription)
        }
    }
    
}
