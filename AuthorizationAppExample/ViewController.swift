//
//  ViewController.swift
//  AuthorizationAppExample
//
//  Created by Jędrzej Chołuj on 28/12/2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let emailEntryField = AuthorizationField(.email)
    private let passwordEntryField = AuthorizationField(.password)
    private let signInButton = UIButton()
    private let signInImageView = UIImageView()
    private let signInTitle = UILabel()
    private let signInDescription = UILabel()
    private let authorizationStackView = UIStackView()
    private let authorizationContentView = UIView()
    private let passwordPolicyButton = UIButton()
    private var passwordPolicyView: PasswordPolicyView?
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        bind()
    }

    private func setupHierarchy() {
        view.addSubviews(passwordPolicyButton, authorizationContentView, signInImageView, signInTitle, signInDescription)
        authorizationContentView.addSubview(authorizationStackView)
        authorizationStackView.addArrangedSubviews(emailEntryField, passwordEntryField, signInButton)
    }
    
    private func setupLayout() {
        passwordPolicyButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.bottom.equalToSuperview().inset(32)
        }
        
        authorizationContentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(passwordPolicyButton.snp.top).offset(-16)
        }
        
        signInImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(signInTitle.snp.top).offset(-16)
            $0.height.width.equalTo(280)
        }
        
        signInTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(signInDescription.snp.top).offset(-16)
        }
        
        signInDescription.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(authorizationContentView.snp.top).offset(-40)
        }
        
        authorizationStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        signInButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        emailEntryField.snp.makeConstraints {
            $0.height.equalTo(66)
        }
        
        passwordEntryField.snp.makeConstraints {
            $0.height.equalTo(66)
        }
    }
    
    private func setupProperties() {
        authorizationStackView.spacing = 16
        authorizationStackView.axis = .vertical
        authorizationContentView.addShadow()
        authorizationContentView.backgroundColor = .white.withAlphaComponent(0.95)
        authorizationContentView.layer.cornerRadius = 40
        view.backgroundColor = .systemIndigo
        
        signInButton.configureWith("Sign Up", size: 18, color: .black)
        signInButton.backgroundColor = .systemGray3
        signInButton.isEnabled = false
        signInButton.layer.cornerRadius = 15
        
        signInImageView.image = UIImage(named: "signIn")
        signInImageView.contentMode = .scaleAspectFit
        
        signInTitle.configureWith("Create an account", color: .systemYellow, alignment: .center, size: 28, weight: .semibold)
        signInDescription.numberOfLines = 0
        signInDescription.configureWith("Register and discover local restaurants near you!", color: .white, alignment: .center, size: 20, weight: .light)
        
        passwordPolicyButton.configureWith("Check with Password Policy", size: 16, color: .systemYellow, weight: .semibold)
        passwordPolicyButton.backgroundColor = .clear
    }
    
    private func showPasswordPolicy() {
        let rules = PasswordValidationService.validateRules(for: passwordEntryField.authorizationTextField.text ?? "")
        passwordPolicyView = PasswordPolicyView(rules: rules)
        guard let policyView = passwordPolicyView else { return }
        policyView.frame = self.view.bounds
        
        policyView.onClose
            .bind { [unowned self] in
                UIView.animate(withDuration: 0.4) { [unowned self] in
                    self.passwordPolicyView?.alpha = 0.0
                } completion: { [unowned self] _ in
                    self.passwordPolicyView?.removeFromSuperview()
                }
            }
            .disposed(by: disposeBag)
        
        policyView.alpha = 0.0
        view.addSubview(policyView)
        view.bringSubviewToFront(policyView)
        UIView.animate(withDuration: 0.4) {
            policyView.alpha = 1.0
        }
    }
    
    private func bind() {
        passwordPolicyButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.passwordPolicyButton.animateClick {
                    self.showPasswordPolicy()
                }
            }
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .bind { [weak self] in
                self?.signInButton.animateClick { }
            }
            .disposed(by: disposeBag)
        
        let isButtonEnabled = Observable.combineLatest(emailEntryField.isValid,
                                 passwordEntryField.isValid)
        { (isEmailValid, isPasswordValid) in
            return isEmailValid && isPasswordValid
        }
        
        isButtonEnabled
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isButtonEnabled
            .distinctUntilChanged()
            .bind { [unowned self] value in
                UIView.transition(with: self.signInButton, duration: 0.4, options: .transitionCrossDissolve) { [unowned self] in
                    self.signInButton.backgroundColor = value ? .systemYellow : .systemGray3
                    self.signInButton.setTitleColor(value ? .black : .white, for: .normal)
                }
            }
            .disposed(by: disposeBag)
    }
}

