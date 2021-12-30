//
//  PasswordPolicyViewController.swift
//  AuthorizationAppExample
//
//  Created by Jędrzej Chołuj on 29/12/2021.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class PasswordPolicyView: UIView {

    var onClose: Observable<Void> { onCloseSubject.asObservable() }
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let contentStackView = UIStackView()
    private let rulesStackView = UIStackView()
    private let containerView = UIView()
    private let closeButton = UIButton()
    private let rules: [(result: Bool, message: String)]
    
    private let onCloseSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init(rules: [(result: Bool, message: String)]) {
        self.rules = rules
        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
        setupProperties()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubviews(closeButton, contentStackView)
        contentStackView.addArrangedSubviews(titleLabel, descriptionLabel, rulesStackView)
        createRulesViews().forEach { rulesStackView.addArrangedSubview($0) }
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(40)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(-4)
            $0.leading.bottom.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupProperties() {
        backgroundColor = .black.withAlphaComponent(0.5)
        
        containerView.backgroundColor = .white.withAlphaComponent(0.9)
        containerView.layer.cornerRadius = 30
        containerView.addShadow()
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        
        rulesStackView.axis = .vertical
        rulesStackView.spacing = 16
        
        closeButton.setImage(Icons.closeImage, for: .normal)
        
        titleLabel.configureWith("Password Policy", color: .systemIndigo, alignment: .center, size: 22, weight: .semibold)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.configureWith("Below you can check which of password rules are still not fulfilled by your password.",
                                       color: .systemIndigo,
                                       alignment: .center,
                                       size: 14,
                                       weight: .regular)
    }
    
    private func createRulesViews() -> [UIView] {
        return rules.map { self.createView(for: $0) }
    }
    
    private func createView(for rule: (result: Bool, message: String)) -> UIView {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = rule.result ? Icons.correctImage : Icons.wrongImage
        
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.configureWith(rule.message, color: rule.result ? .validGreen : .invalidRed, alignment: .left, size: 12)
        
        view.addSubviews(imageView, textLabel)
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(20)
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(textLabel.snp.centerY)
        }
        
        textLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        return view
    }
    
    private func bind() {
        closeButton.rx.tap
            .bind { [unowned self] in
                self.closeButton.animateClick { [unowned self] in
                    self.onCloseSubject.onNext(())
                }
            }
            .disposed(by: disposeBag)
    }
}
