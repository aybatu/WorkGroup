//
//  CompleteProjectTaskRequest.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 08/08/2023.
//

import Foundation

struct CompleteProjectTaskRequest: Codable {
    var project: Project
    var task: Task
}
