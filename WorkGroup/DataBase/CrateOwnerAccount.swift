//
//  CrateOwnerAccount.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 13/07/2023.
//

import Foundation

class CreateOwnerAccount {
   
    func register<T: UserAccount>(userAccount: T, company: Company, completion: @escaping (Bool, String?) -> Void) {
        
        guard let url = URL(string: "http://localhost:8080/registercompany") else {
            completion(false, nil)
            return
        }
  
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
        let encoder = JSONEncoder()
        do {
            let userAccountData = try encoder.encode(userAccount)
            let companyData = try encoder.encode(company)
         
            
            let combinedData: [String: Any] = [
                "userAccount": try JSONSerialization.jsonObject(with: userAccountData),
                "company": try JSONSerialization.jsonObject(with: companyData)
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: combinedData)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false, nil)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        do {
                            if let responseData = data {
                                let responseJson = try JSONSerialization.jsonObject(with: responseData, options: [])
                                if let responseDict = responseJson as? [String: Any],
                                   let registrationNumber = responseDict["registrationNumber"] as? String {
                                    completion(true, registrationNumber)
                                } else {
                                    completion(false, nil)
                                }
                            } else {
                                completion(false, nil)
                            }
                        } catch {
                            print("Error parsing response: \(error.localizedDescription)")
                            completion(false, nil)
                        }
                    } else {
                        completion(false, nil)
                    }
                }
            }

            task.resume()
        } catch {
            print("Error encoding data: \(error.localizedDescription)")
            completion(false, nil)
        }
    }
}
