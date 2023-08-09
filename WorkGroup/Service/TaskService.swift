//
//  TaskService.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 08/08/2023.
//

import Foundation

class TaskService {
    func sendCompleteTaskRequest(registrationNumber: String, taskCompleteRequest: TaskCompletionRequest, completion: @escaping (Bool, String?) -> Void) {
        let urlString = "http://3.72.4.71:8080/\(registrationNumber)/sendCompleteTaskRequest"
        
        var isRequestSent = false
        var errorMsg: String? = nil
        
        guard let url = URL(string: urlString) else {
            isRequestSent = false
            errorMsg = "Invalid URL"
            completion(isRequestSent, errorMsg)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        do {
            let jsonData = try JSONEncoder().encode(taskCompleteRequest)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            isRequestSent = false
            errorMsg = "Error encoding JSON data"
            completion(isRequestSent, errorMsg)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                isRequestSent = false
                errorMsg = "Error: \(error)"
                completion(isRequestSent, errorMsg)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    isRequestSent = true
                    errorMsg = nil
                    completion(isRequestSent, errorMsg)
                } else {
                    if let responseData = data, let errorMessage = String(data: responseData, encoding: .utf8) {
                        isRequestSent = false
                        errorMsg = errorMessage
                        completion(isRequestSent, errorMsg)
                    } else {
                        isRequestSent = false
                        errorMsg = "Unknown error occurred. Please try again."
                        completion(isRequestSent, errorMsg)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func rejectTaskCompletionRequest(registrationNumber: String, rejectTaskRequest: CompleteProjectTaskRequest, completion: @escaping (Bool, String?) -> Void) {
        let urlString = "http://3.72.4.71:8080/\(registrationNumber)/rejectTaskCompletion"
        
        guard let url = URL(string: urlString) else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        do {
            let jsonData = try JSONEncoder().encode(rejectTaskRequest)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(false, "Error encoding JSON data")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, nil) // Task rejection request sent successfully
                } else {
                    if let responseData = data, let errorMessage = String(data: responseData, encoding: .utf8) {
                        completion(false, errorMessage)
                    } else {
                        completion(false, "Unknown error occurred. Please try again.")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func acceptTaskCompletionRequest(registrationNumber: String, completeTaskRequest: CompleteProjectTaskRequest, completion: @escaping (Bool, String?) -> Void) {
        let urlString = "http://3.72.4.71:8080/\(registrationNumber)/acceptTaskCompletion"
        
        guard let url = URL(string: urlString) else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        do {
            let jsonData = try JSONEncoder().encode(completeTaskRequest)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(false, "Error encoding JSON data")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, nil) // Task completion request accepted successfully
                } else {
                    if let responseData = data, let errorMessage = String(data: responseData, encoding: .utf8) {
                        completion(false, errorMessage)
                    } else {
                        completion(false, "Unknown error occurred. Please try again.")
                    }
                }
            }
        }
        
        task.resume()
    }
}
