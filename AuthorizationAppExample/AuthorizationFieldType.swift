//
//  AuthorizationFieldType.swift
//  AuthorizationAppExample
//
//  Created by Jędrzej Chołuj on 28/12/2021.
//

import Foundation

enum AuthorizationFieldType {
    case email
    case password
    
    var placeholder: String {
        switch self {
        case .email:
            return "Enter an email address.."
        case .password:
            return "Enter a password.."
        }
    }
}
