//
//  AuthorizationField.swift
//  AuthorizationAppExample
//
//  Created by Jędrzej Chołuj on 28/12/2021.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

class AuthorizationField: UIView {
    
    private let textField: UITextField = UITextField()
    private let underline: UIView = UIView()
    private let visibilityButton: UIButton = UIButton()
    private let verificationLabel: UILabel = UILabel()
    private let verificationIcon: UIImageView = UIImageView()
    
    private let disposeBag = DisposeBag()
    private let fieldType: AuthorizationFieldType
    
    private let validationSubject = BehaviorSubject<Bool>(value: false)
    private let textSubject = BehaviorRelay<String?>(value: "")
    
    private var isVisible = false {
        didSet {
            visibilityButton.setImage(isVisible ? Icons.eyeVisible : Icons.eyeInvisible, for: .normal)
            textField.isSecureTextEntry = !isVisible
        }
    }
    
    var isValid: Observable<Bool> { validationSubject.asObservable() }
    var authorizationUnderline: UIView { underline }
    var authorizationTextField: UITextField { textField }
    var value: String? { textField.text }
    
    init(_ authorizationFieldType: AuthorizationFieldType) {
        fieldType = authorizationFieldType
        super.init(frame: .zero)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupAuthorizationField(for: authorizationFieldType)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAuthorizationField(for authorizationFieldType: AuthorizationFieldType) {
        textField.placeholder = authorizationFieldType.placeholder
        textField.isSecureTextEntry = authorizationFieldType == .password
        textField.keyboardType = authorizationFieldType == .email ? .emailAddress : .default
    }
}

extension AuthorizationField {
    
    func setupHierarchy() {
        addSubviews(textField, underline, verificationIcon, verificationLabel)
        guard fieldType == .password else { return }
        addSubview(visibilityButton)
    }
    
    func setupLayout() {
        textField.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        underline.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(-15)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        verificationLabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.top.equalTo(underline.snp.bottom).offset(5)
        }
        
        verificationIcon.snp.makeConstraints {
            $0.height.width.equalTo(15)
            $0.leading.bottom.equalToSuperview()
            $0.centerY.equalTo(verificationLabel.snp.centerY)
            $0.trailing.equalTo(verificationLabel.snp.leading).offset(-5)
        }
        
        guard fieldType == .password else {
            textField.snp.makeConstraints {
                $0.trailing.equalToSuperview()
            }
            return
        }
        
        visibilityButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(textField.snp.trailing)
            $0.centerY.equalTo(textField.snp.centerY)
            $0.width.height.equalTo(30)
        }
    }
    
    func setupProperties() {
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        underline.backgroundColor = .systemGray2
        
        verificationLabel.numberOfLines = 0
        
        visibilityButton.setImage(Icons.eyeInvisible, for: .normal)
    }
    
    func setInvalidColor() {
        textField.textColor = .invalidRed
        underline.backgroundColor = .invalidRed
    }
    
    private func setVerificationInfo(with validationResult: (result: Bool, message: String)) {
        let isValid = validationResult.result
        let message = validationResult.message
        let color: UIColor = isValid ? .validGreen : .invalidRed
        
        UIView.transition(with: verificationIcon, duration: 0.4, options: .transitionCrossDissolve) { [unowned self] in
            self.verificationIcon.image = isValid ? Icons.correctImage : Icons.wrongImage
        }
        
        UIView.transition(with: verificationLabel, duration: 0.4, options: .transitionCrossDissolve) { [unowned self] in
            self.verificationLabel.configureWith(message, color: color, alignment: .left, size: 12)
        }
    }
    
    private func setupVerificationVisibility(isHidden: Bool) {
        verificationIcon.isHidden = isHidden
        verificationLabel.isHidden = isHidden
    }
}

extension AuthorizationField {
    
    func bind() {
        bindVisibilityButtonTapped()
        bindValidationOfTextField()
    }
    
    private func bindVisibilityButtonTapped() {
        visibilityButton.rx.controlEvent(.touchUpInside)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.isVisible.toggle()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindValidationOfTextField() {
        textField.rx.text
            .bind(to: textSubject)
            .disposed(by: disposeBag)
        
        textSubject
            .map { [unowned self] text in self.fieldType == .email ? text!.validateEmail() : text!.validatePassword() }
            .bind { [unowned self] validationResult in
                let isValid = validationResult.result
                self.validationSubject.onNext(isValid)
                if self.textSubject.value!.count == 0 {
                    self.textField.textColor = .systemGray3
                    self.underline.backgroundColor = .systemGray3
                    self.setupVerificationVisibility(isHidden: true)
                } else {
                    self.textField.textColor = isValid ? .validGreen : .invalidRed
                    self.underline.backgroundColor = isValid ? .validGreen : .invalidRed
                    self.setVerificationInfo(with: validationResult)
                    self.setupVerificationVisibility(isHidden: false)
                }
            }
            .disposed(by: disposeBag)
    }
}
