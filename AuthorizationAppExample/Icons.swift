//
//  Icons.swift
//  AuthorizationAppExample
//
//  Created by Jędrzej Chołuj on 29/12/2021.
//

import UIKit

struct Icons {
    static let correctImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(
        .validGreen,
        renderingMode: .alwaysOriginal
    )
    
    static let wrongImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(
        .invalidRed,
        renderingMode: .alwaysOriginal
    )
    
    static let closeImage = UIImage(systemName: "xmark")?.withTintColor(
        .systemIndigo,
        renderingMode: .alwaysOriginal
    )
    
    static let eyeVisible = UIImage(systemName: "eye.fill")?.withTintColor(
        .systemGray2,
        renderingMode: .alwaysOriginal
    )
    
    static let eyeInvisible = UIImage(systemName: "eye.slash.fill")?.withTintColor(
        .systemGray2,
        renderingMode: .alwaysOriginal
    )
}
