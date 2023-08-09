//
//  MeetingService.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 04/08/2023.
//

import Foundation

struct MeetingService {
    func scheduleMeeting(companyRegistrationNo: String, meetingRequest: ScheduleMeetingRequest, completion: @escaping(Bool, String?) -> Void) {
        var errorMsg: String? = nil
        var isMeetingCreated = false
        
        let urlString = "http://3.72.4.71:8080/\(companyRegistrationNo)/createMeeting"
        
        guard let url = URL(string:  urlString) else {
            isMeetingCreated = false
            errorMsg = "Invalid URL"
            completion(isMeetingCreated, errorMsg)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(meetingRequest)
            request.httpBody = jsonData
            request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        } catch {
            isMeetingCreated = false
            errorMsg = "Error encoding JSON data"
            completion(isMeetingCreated, errorMsg)
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let errorSafe = error {
                isMeetingCreated = false
                errorMsg = "Server response error \(errorSafe)"
                completion(isMeetingCreated, errorMsg)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    isMeetingCreated = true
                    errorMsg = nil
                    
                    completion(isMeetingCreated, errorMsg)
                } else {
                    if let responseData = data {
                       
                        if let errorMessage = String(data: responseData, encoding: .utf8) {
                            errorMsg = errorMessage
                    
                        } else {
                            isMeetingCreated = false
                            errorMsg = "Unknown error"
                            completion(isMeetingCreated, errorMsg)
                        }
                    } else {
                        isMeetingCreated = false
                        errorMsg = "Unknown error"
                        completion(isMeetingCreated, errorMsg)
                    }
                    completion(isMeetingCreated, errorMsg)
                }
            }
            
        }
        task.resume()
    }
    
    func updateMeeting(registrationNumber: String, request: UpdateMeetingRequest, completion: @escaping (Bool, String?) -> Void) {
        var isMeetingScheduled = false
        var errorMsg: String? = nil
        guard let url = URL(string: "http://3.72.4.71:8080/\(registrationNumber)/updateMeeting") else {
            isMeetingScheduled = false
            errorMsg = "Invalid URL"
            completion(isMeetingScheduled, errorMsg)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    isMeetingScheduled = false
                    errorMsg = error.localizedDescription
                    completion(isMeetingScheduled, errorMsg)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // Request was successful
                        if let data = data {
                            let responseString = String(data: data, encoding: .utf8)
                            completion(true, responseString)
                        } else {
                            completion(true, nil)
                        }
                    } else {
                        // Request failed with an error message
                        if let data = data {
                            let responseString = String(data: data, encoding: .utf8)
                            completion(false, responseString)
                        } else {
                            completion(false, "Unknown error occurred. Please try again.")
                        }
                    }
                } else {
                    completion(false, "Invalid response from the server.")
                }
            }
            task.resume()
        } catch {
            completion(false, error.localizedDescription)
        }
    }
}
