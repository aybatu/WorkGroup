//
//  RegistrationService.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 13/07/2023.
//
import Foundation

struct RegistrationService {
    func register(company: Company, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "http://localhost:8080/registercompany") else {
            completion(false, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let companyData = try encoder.encode(company)
            request.httpBody = companyData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(false, nil)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        do {
                            if let responseData = data,
                               let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                               let registrationNumber = json["registrationNumber"] as? String {
                                completion(true, registrationNumber)
                            } else {
                                completion(true, nil) // Registration number not found
                            }
                        } catch {
                            completion(false, nil)
                        }
                    } else {
                        completion(false, nil)
                    }
                }
            }
            
            task.resume()
        } catch {
            completion(false, nil)
        }
    }
}