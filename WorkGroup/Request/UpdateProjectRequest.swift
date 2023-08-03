//
//  UpdateProjectRequest.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 03/08/2023.
//

import Foundation

struct UpdateProjectRequest: Codable {
    let originalProjectTitle: String
    let updatedProject: Project
}
