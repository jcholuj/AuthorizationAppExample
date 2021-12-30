//
//  PasswordRule.swift
//  AuthorizationAppExample
//
//  Created by Jędrzej Chołuj on 28/12/2021.
//

import Foundation

enum PasswordRule: CaseIterable {
    case lengthRule
    case capitalLetterRule
    case specialCharacterRule
    case numberRule
    
    var fulfilled: String {
        switch self {
        case .lengthRule:
            return "Your password is longer than 5 characters."
        case .capitalLetterRule:
            return "Your password contains a capital letter."
        case .specialCharacterRule:
            return "Your password contains a special character."
        case .numberRule:
            return "Your password contains a number."
        }
    }
    
    var unfulfilled: String {
        switch self {
        case .lengthRule:
            return "Unfortunately, your password is too short. Please provide a password with at least 6 characters and try again."
        case .capitalLetterRule:
            return "Unfortunately, your password doesn't contain a capital letter. Please correct it and try again."
        case .specialCharacterRule:
            return "Unfortunately, your password doesn't contain a special character. Please correct it and try again."
        case .numberRule:
            return "Unfortunately, your password doesn't contain a number. Please correct it and try again."
        }
    }
    
    var shortUnfulfilled: String {
        switch self {
        case .lengthRule:
            return "Your password is too short."
        case .capitalLetterRule:
            return "Doesn't contain a capital letter."
        case .specialCharacterRule:
            return "Doesn't contain a special character."
        case .numberRule:
            return "Doesn't contain a number."
        }
    }
    
    var shortFulfilled: String {
        "Your password looks correct!"
    }
}
