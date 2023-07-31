//
//  RegistrationService.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 13/07/2023.
//
import Foundation

struct RegistrationService {
    func register(company: Company, completion: @escaping (Bool, String?, String?) -> Void) {
        var isCompanyRegistered = false
        var companyRegistrationNumber: String?
        var errorMsg: String?
        guard let url = URL(string: "http://localhost:8080/registercompany") else {
            isCompanyRegistered = false
            errorMsg = "Please check you internet connection. Application could not resolve the URL."
            companyRegistrationNumber = nil
            completion(isCompanyRegistered, companyRegistrationNumber, errorMsg)
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
                    isCompanyRegistered = false
                    errorMsg = error.localizedDescription
                    companyRegistrationNumber = nil
                    completion(isCompanyRegistered, companyRegistrationNumber, errorMsg)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        do {
                            if let responseData = data,
                               let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                               let registrationNumber = json["registrationNumber"] as? String {
                                errorMsg = nil
                                isCompanyRegistered = true
                               companyRegistrationNumber = registrationNumber
                                completion(isCompanyRegistered, companyRegistrationNumber, errorMsg)
                            } else {
                                isCompanyRegistered = true
                                companyRegistrationNumber = nil
                                errorMsg = "There was an error while fetching registration number. Please try again."
                                completion(isCompanyRegistered, companyRegistrationNumber, companyRegistrationNumber) // Registration number not found
                            }
                        } catch {
                            isCompanyRegistered = false
                            companyRegistrationNumber = nil
                            errorMsg = error.localizedDescription
                            completion(isCompanyRegistered, companyRegistrationNumber, errorMsg)
                        }
                    } else {
                        guard let dataSafe = data else {return}
                        isCompanyRegistered = false
                        companyRegistrationNumber = nil
                        errorMsg = String(data: dataSafe, encoding: .utf8)
                        completion(isCompanyRegistered, companyRegistrationNumber, errorMsg)
                    
                    }
                }
            }
            
            task.resume()
        } catch {
            isCompanyRegistered = false
            companyRegistrationNumber = nil
            errorMsg = "Data could not resolved."
            completion(isCompanyRegistered, companyRegistrationNumber, errorMsg)
        }
    }
}
