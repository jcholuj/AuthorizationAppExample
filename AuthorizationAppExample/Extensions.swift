//
//  Extensions.swift
//  AuthorizationAppExample
//
//  Created by Jędrzej Chołuj on 28/12/2021.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension UIColor {
    static let validGreen = UIColor(red: 80 / 255, green: 114 / 255, blue: 85 / 255, alpha: 1.0)
    static let invalidRed = UIColor(red: 157 / 255, green: 2 / 255, blue: 8 / 255, alpha: 1.0)
}

extension UIButton {
    func configureWith(_ title: String, size: CGFloat, color: UIColor, weight: UIFont.Weight = .semibold) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: size, weight: weight)
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func animateClick(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform.identity
            } completion: { _ in completion() }
        }
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 7
    }
}

extension String {
    func validateEmail() -> (result: Bool, message: String) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let result = predicate.evaluate(with: self)
        let message = result ? "The email looks correct!" : "The email format is wrong!"
        return (result, message)
    }
    
    func validatePassword() -> (result: Bool, message: String) {
        PasswordRule.allCases.map { rule in
            PasswordValidationService.validatePasswordRule(rule, with: self, shouldReturnShortMessage: true)
        }.first { !$0.result } ?? (result: true, message: "Your password looks correct!")
    }
}

extension UILabel {
    func configureWith(_ text: String,
                            color: UIColor,
                            alignment: NSTextAlignment,
                            size: CGFloat,
                            weight: UIFont.Weight = .regular) {
        self.font = .systemFont(ofSize: size, weight: weight)
        self.text = text
        self.textColor = color
        self.textAlignment = alignment
    }
}
