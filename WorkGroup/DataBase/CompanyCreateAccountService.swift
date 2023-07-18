//
//  CreateAccount.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 17/07/2023.
//

import Foundation
class CompanyCreateAccountService {
    
    func createAccount(companyRegistrationNumber: String, accountType: String, request: UserAccountRequest, completion: @escaping (Bool, String?) -> Void) {
        let urlString = "http://localhost:8080/\(companyRegistrationNumber)/\(accountType)" // Replace with your actual API endpoint
        
        guard let url = URL(string: urlString) else {
            completion(false, "Invalid URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
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
                    // Account creation successful
                    completion(true, nil)
                } else {
                    // Account creation failed
                    let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Account creation failed"
                    completion(false, errorMessage)
                }
            }.resume()
        } catch {
            completion(false, error.localizedDescription)
        }
    }
    
    
}
