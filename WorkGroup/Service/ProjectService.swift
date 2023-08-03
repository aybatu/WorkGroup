//
//  ProjectService.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 01/08/2023.
//

import Foundation

struct ProjectService {
    func sendProjectCreationRequest(registrationNumber: String, projectRequest: Project, completion: @escaping(Bool, String) -> Void) {
        var errorMsg = ""
        var isProjectCreated = false
        // URL for your backend endpoint
        let urlString = "http://localhost:8080/\(registrationNumber)/projects"
        guard let url = URL(string: urlString) else {
            isProjectCreated = false
            errorMsg = "Invalid URL"
            print("invalid url")
            completion(isProjectCreated, errorMsg)
            return
        }
        
        // Create a URLRequest with the POST method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the request body with JSON data
        do {
            let jsonData = try JSONEncoder().encode(projectRequest)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            isProjectCreated = false
            errorMsg = " Error encoding JSON data"
            print("Error encoding JSON data: \(error)")
            completion(isProjectCreated, errorMsg)
        }
        // Create a URLSession data task to send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle the response or error here
            if let error = error {
                print("Error: \(error)")
                isProjectCreated = false
                errorMsg = "Server response error. Please try again."
                completion(isProjectCreated, errorMsg)
            }
            
            // Inside the URLSession data task completion handler
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // Request was successful
                    isProjectCreated = true
                    errorMsg = ""
                    // Handle the response data if needed (contained in 'data' variable)
                    completion(isProjectCreated, errorMsg)
                } else {
                    if let responseData = data {
                        if let errorMessage = String(data: responseData, encoding: .utf8) {
                            // Use the error message directly from the response data
                            errorMsg = errorMessage
                        } else {
                            isProjectCreated = false
                            // Failed to convert response data to a string
                            errorMsg = "Unknown error occurred"
                            completion(isProjectCreated, errorMsg)
                        }
                    } else {
                        isProjectCreated = false
                        // Failed to convert response data to a string
                        errorMsg = "Unknown error occurred"
                        completion(isProjectCreated, errorMsg)
                    }
                    // Return the error message
                    completion(isProjectCreated, errorMsg)
                }
            }

        }
        
        // Start the data task
        task.resume()
    }
    
    func updateProject(registrationNumber: String, updatedProjectRequest: UpdateProjectRequest, completion: @escaping (Bool, String?) -> Void) {
        // Prepare the URL for the PUT request
        let urlString = "http://localhost:8080/\(registrationNumber)/updateProject"
        guard let url = URL(string: urlString) else {
            completion(false, "Invalid URL")
            return
        }

        // Create a URLRequest with the PUT method
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        // Set the request body with JSON data
        do {
            let jsonData = try JSONEncoder().encode(updatedProjectRequest)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(false, "Error encoding JSON data")
            return
        }

        // Create a URLSession data task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error here
            if let error = error {
                print("Error: \(error)")
                completion(false, "Server response error. Please try again.")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // Request was successful
                    completion(true, nil)
                } else {
                    // Request failed with an error message
                    if let responseData = data {
                        do {
                            // Try to decode the response data as a JSON dictionary
                            if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                               let errorMessage = json["error"] as? String {
                                completion(false, errorMessage)
                                return
                            }
                        } catch {
                            // Failed to parse the response data as JSON
                            print("Error parsing error response data: \(error)")
                        }
                    }
                    completion(false, "Unknown error occurred. Please try again.")
                }
            }
        }

        // Start the data task
        task.resume()
    }
}
