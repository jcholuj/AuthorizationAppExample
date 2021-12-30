//
//  PasswordValidationService.swift
//  AuthorizationAppExample
//
//  Created by Jędrzej Chołuj on 29/12/2021.
//

import Foundation

struct PasswordValidationService {
    static func validateRules(for password: String) -> [(result: Bool, message: String)] {
        PasswordRule.allCases.map { rule in
            return validatePasswordRule(rule, with: password)
        }
    }
    
    static func validatePasswordRule(_ rule: PasswordRule,
                              with input: String,
                              shouldReturnShortMessage: Bool = false) -> (result: Bool, message: String) {
        var result = true
        switch rule {
        case .lengthRule:
            result = containsAtLeastSixCharacters(input)
        case .capitalLetterRule:
            result = containsCapitalLetter(input)
        case .specialCharacterRule:
            result = containsSpecialCharacter(input)
        case .numberRule:
            result = containsNumber(input)
        }
        let unfulfilledMessage = shouldReturnShortMessage ? rule.shortUnfulfilled : rule.unfulfilled
        let fulfilledMessage = shouldReturnShortMessage ? rule.shortFulfilled : rule.fulfilled
        let message = result ? fulfilledMessage : unfulfilledMessage
        return (result, message)
    }
    
    private static func containsAtLeastSixCharacters(_ input: String) -> Bool {
        return input.count > 5
    }
    
    private static func containsCapitalLetter(_ input: String) -> Bool {
        let capitalLetterRegex  = ".*[A-Z]+.*"
        let capitalLetterPredicate = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegex)
        return capitalLetterPredicate.evaluate(with: input)
    }
    
    private static func containsNumber(_ input: String) -> Bool {
        let numberRegex = ".*[0-9]+.*"
        let numberPredicate = NSPredicate(format:"SELF MATCHES %@", numberRegex)
        return numberPredicate.evaluate(with: input)
    }
    
    private static func containsSpecialCharacter(_ input: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: ".*[^A-Za-z0-9].*",
                                                   options: NSRegularExpression.Options()) else { return false }
        let result = regex.firstMatch(
            in: input,
            options: NSRegularExpression.MatchingOptions(),
            range: NSMakeRange(0, input.count)
        )
        return result != nil
    }
}
