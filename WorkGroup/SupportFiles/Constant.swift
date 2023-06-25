//
//  Constant.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 18/06/2023.
//

import Foundation

struct Constant {
    struct Segue {
        struct RegisterCompany {
            static let createAccountToSuccess = "RegisterCompanyToSuccess"
            static let createAccountToFail = "RegisterCompanyToFail"
        }
        struct Login {
            static let loginToAdmin = "LoginToAdminMenu"
            static let loginToManager = "LoginViewToManager"
            static let loginToEmployee = "LoginViewToEmployee"
        }
        struct Employee {
            static let taskDetailToSuccess = "TaskDetailsViewToMarkCompleteSuccess"
            static let taskDetailToFail = "TaskDetailsViewToMarkCompleteFail"
            static let taskListToTaskDetails = "TaskListEmployeeToTaskDetails"
            static let meetingListToMeetingDetails = "EmployeeMeetingListViewToDetails"
            static let employeeDateListToPerformanceGraph = "DateToPerformanceGraphEmployee"
        }
        
        struct Admin {
            static let createAccountToFail = "CreateUserAccountToFail"
            static let createAccountToSuccess = "CreateUserAccountToSuccess"
            static let editUserAccountToFail = "EditUserAccountToFail"
            static let editUserAccountToSuccess = "EditUserAccountToSuccess"
            static let accountListToAccountEdit = "AccountListToAccountEdit"
            static let mainMenuToCreateAccount = "AdminMainMenuToCreateAccount"
            static let mainMenuToEditAccounts = "AdminMainMenuToEditAccounts"
           
        }
        struct Manager {
            static let addTaskToSuccess = "AddTaskManagerToSuccess"
            static let addTaskToFail = "AddTaskManagerToFail"
            static let createProjectToSuccess = "CreateProjectToSuccess"
            static let createProjectToFail = "CreateProjectToFail"
            static let projectListToProjectDetails = "ProjectListToEditProjectDetails"
            static let projectDetailSaveToFail = "ProjectDetailsChangeToFail"
            static let projectDetailSaveToSuccess = "ProjectDetailsChangeToSuccess"
            static let taskListToEditTaskDetails = "TaskListToEditTask"
            static let editTaskToFail = "EditTaskToFail"
            static let editTaskToSuccess = "EditTaskToSuccess"
            static let sendMeetingRequestToFail = "SendMeetingRequestToFail"
            static let sendMeetingRequestTotSuccess = "SendMeetingRequestToSuccess"
            static let editMeetingListToMeetingDetails = "MeetingListViewToEditMeetingManager"
            static let meetingEditSaveToFail = "MeetingSaveChangesToFail"
            static let meetingEditSaveToSuccess = "MeetingSaveChangesToSuccess"
            static let editInvitedEmployeeToFail = "MeetingEditInvitedEmployeeToFail"
            static let editInvitedEmployeeToSuccess = "MeetingEditInvitedEmployeeToSuccess"
            static let employeeListToPerformanceDate = "EmployeeListToPerformanceDateListManager"
            static let performanceDateToPerformanceGraph = "PerformanceDateToPerformanceGraph"
            
        }
    }
    struct TableCellIdentifier {
        struct Admin {
            static let editEmployeeAccountListCellIdentifier = "EditEmployeeAccountCell"
        }
        struct Employee {
            static let employeeTaskLisCellIdentifier = "EmployeeTaskListCell"
            static let employeeMeetingListCellIdentifier = "EmployeeMeetingListCell"
            static let employeePerformanceDateListCellIdentifier = "EmployeePerformanceDateListCell"
        }
        struct Manager {
            static let editProjectListCellIdentifier = "EditProjectCell"
            static let taskListCellIdentifier = "EditTaskCellManager"
            static let meetingEmployeListCellIdentifier = "AddEmployeeCell"
            static let editMeetingListCellIdentifier = "EditMeetingsMangerCell"
            static let editMeetingEmployeeListCellIdentifier = "EditMeetingEmployeeListCell"
            static let employeeListForPerformanceReportCellIdentifier = "EmployeePerformanceGraphListManagerCell"
            static let employeePerformanceDateCellIdentifier = "EmployeePerformanceDateCell"
        }
    }
    
    struct Warning {
        static let textFieldCannotBeEmpty = "You cannot leave this field empty."
        struct Password {
            static let passwordDoNotMatch = "Passwords do not match."
            static let passwordFormatInvalid = "Invalid password format."
            static let passwordRequirments = "Password does not match requirments. Password must be minimum 8 characters including at least one uppercase, one number and one special character."
        }
        struct Email {
            static let invalidEmailFormat = "Invalid email format."
            static let emailMatchFail = "Email addresses do not match."
        }
        struct Login {
            static let userNamePassInvalid = "Invalid username or password."
            static let companyRegisterNoInvalid = "Invalid company registration number."
        }
        struct CreateAccount {
            static let isAccountExist = "email address is already registered in the system. Please try another email address or check if it is correct."
        }
    }
}
