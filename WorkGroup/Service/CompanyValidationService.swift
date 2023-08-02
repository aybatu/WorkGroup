//
//  CompanyValidationService.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/07/2023.
//

import Foundation

struct CompanyValidationService {
    
    func validateCompanyRegistrationNumber(registrationNumber: String, completion: @escaping (Bool, Bool, Company?) -> Void) {
           let urlString = "http://localhost:8080/company/\(registrationNumber)"
      
           guard let url = URL(string: urlString) else {
               completion(false, false, nil)
               return
           }
       
           URLSession.shared.dataTask(with: url) { (data, response, error) in
               guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                   completion(false, false, nil)
                   return
               }
               if httpResponse.statusCode == 200 {
  
                   do {
                       // Parse the response data into a Company object
                       let decoder = JSONDecoder()
                       let company = try decoder.decode(Company.self, from: data)
                       
                       // Check if the retrieved company's registration number matches the expected registration number

                       if company.registrationNumber == registrationNumber {
                           completion(true, true, company)
               
                       } else {
                           completion(true, false, nil)
                       }
                   } catch {
                    
                       completion(true, false, nil)
                   }
               } else if httpResponse.statusCode == 404 {
                   // Company not found
  
                   completion(true, false, nil)
               } else {
         
                   completion(true, false, nil)
               }
           }.resume()
       }
    
}
