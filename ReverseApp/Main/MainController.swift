//
//  MainController.swift
//  ReverseApp
//
//  Created by SHIN MIKHAIL on 24.05.2023.

import SnapKit
import UIKit

final class MainController: UIViewController {
    //MARK: - Private UI Elements - deleted all PRIVATE
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reverse words"
        label.font = UIFont.customFontBold(ofSize: 34)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    let subtitleLabel: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "This application will reverse your words.\nPlease type text below"
        subtitle.textColor = Colors.gray
        subtitle.textAlignment = .center
        subtitle.font = UIFont.customFontRegular(ofSize: 17)
        subtitle.numberOfLines = 3
        return subtitle
    }()
    let inputTextField: UITextField = {
        let input = UITextField()
        input.borderStyle = .none
        input.font = UIFont.customFontRegular(ofSize: 17)
        input.textColor = Colors.gray
        let placeholderFont = UIFont.customFontRegular(ofSize: 17)
        let placeholderText = "Text to reverse"
        let attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: placeholderFont as Any
            ]
        )
        input.attributedPlaceholder = attributedPlaceholder
        return input
    }()
    let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = Colors.lightGray
        return line
    }()
    let resultLabel: UILabel = {
        let result = UILabel()
        result.textColor = Colors.systemBlue
        result.textAlignment = .left
        result.font = UIFont.customFontRegular(ofSize: 24)
        result.numberOfLines = 0
        result.accessibilityIdentifier = "resultLabel" // add id
        return result
    }()
    let reverseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reverse", for: .normal)
        button.setTitleColor(Colors.white, for: .normal)
        button.backgroundColor = Colors.systemBlue
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.backgroundColor = Colors.lightSystemBlue
        button.accessibilityIdentifier = "ReverseButton"

        return button
    }()
    let reverseManager: ReverseManager? = ReverseManager()
    var buttonBottomConstraint: Constraint?
    var appState: AppState = .empty {
        didSet {
            updateUI(for: appState)
        }
    }
    
    enum AppState {
        case empty
        case input(text: String)
        case reversed(result: String)
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFieldDelegate()
        setupKeyboardDismiss()
        addKeyboardObserver()
        setupResultLabelGesture()
        setupButtonTarget()
        setupConstraints()
    }
    private func setupUI() {
        self.view.backgroundColor = Colors.white
    }
    
    private func setupConstraints() {
        // title
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.topOffset)
        }
        // subtitle
        self.view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
        }
        // input
        self.view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.InputTextField.topOffset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(Constants.InputTextField.height)
        }
        // underline
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(Constants.Underline.topOffset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(Constants.Underline.height)
        }
        // result
        self.view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalTo(inputTextField.snp.bottom).offset(Constants.ResultLabel.topOffset)
        }
        // button
        self.view.addSubview(reverseButton)
        reverseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            self.buttonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(Constants.ReverseButton.bottomOffset).constraint
            make.horizontalEdges.equalToSuperview().inset(Constants.ReverseButton.horizontalInset)
            make.height.equalTo(Constants.ReverseButton.height)
        }
    }
    
    func updateUI(for appState: AppState) {
        func applyEmptyState() {
            reverseButton.setTitle("Reverse", for: .normal)
            reverseButton.isEnabled = false
            reverseButton.backgroundColor = Colors.lightSystemBlue
            inputTextField.text = ""
            resultLabel.text = ""
        }
        
        func applyInputState(hasEnteredText: Bool) {
            if hasEnteredText {
                reverseButton.isEnabled = true
                reverseButton.backgroundColor = Colors.systemBlue
                reverseButton.setTitle("Reverse", for: .normal)
            } else {
                applyEmptyState()
            }
        }
        
        func applyReversedState(result: String) {
            reverseButton.setTitle("Clear", for: .normal)
            resultLabel.text = result
        }
        
        switch appState {
        case .empty:
            applyEmptyState()
        case .input(let text):
            applyInputState(hasEnteredText: !text.isEmpty)
        case .reversed(let result):
            applyReversedState(result: result)
        }
    }
    
    private func setupButtonTarget() {
        reverseButton.addTarget(self, action: #selector(reverseButtonTapped), for: .touchUpInside)
    }
    
    @objc func reverseButtonTapped(_ sender: UIButton) {
        switch appState {
        case .empty:
            break
        case .input(let text):
            let reversedText = reverseManager?.reverseText(text) ?? ""
            appState = .reversed(result: reversedText)
        case .reversed:
            appState = .empty
        }
    }
    
    // Result
    private func setupResultLabelGesture() {
        let resultLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(copyResultLabel))
        resultLabel.isUserInteractionEnabled = true
        resultLabel.addGestureRecognizer(resultLabelTapGesture)
    }
    
    @objc func copyResultLabel() {
        guard let resultText = resultLabel.text else { return }
        UIPasteboard.general.string = resultText
        let alert = UIAlertController(title: "", message: "Скопировано", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OKAY 🥵", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    // Delegate
    func setupTextFieldDelegate() {
        inputTextField.delegate = self
    }
}

//MARK: - Keyboard
extension MainController {
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let spacing: CGFloat = -10
            let buttonBottomOffset = keyboardHeight - spacing - self.view.safeAreaInsets.bottom
            self.buttonBottomConstraint?.update(offset: -buttonBottomOffset)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.buttonBottomConstraint?.update(offset: -20)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
//MARK: - TextField
extension MainController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lineView.backgroundColor = Colors.systemBlue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        lineView.backgroundColor = Colors.gray
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            appState = .input(text: updatedText)
        }
        return true
    }
}
//MARK: - Constants and Colors
extension MainController {
    enum Constants {
        static let topOffset = 100
        static let spacing = 16
        static let horizontalInset = 16
        enum InputTextField {
            static let topOffset = 40
            static let height = 40
        }
        enum Underline {
            static let topOffset = 10
            static let height = 1
        }
        enum ResultLabel {
            static let topOffset = 25
        }
        enum ReverseButton {
            static let bottomOffset = -5
            static let horizontalInset = 13
            static let height = 66
        }
    }
    enum Colors {
        static let white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        static let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        static let gray = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 1.0)
        static let lightGray = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
        static let systemBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        static let lightSystemBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.6)
    }
}


extension MainController.AppState: Equatable {
    static func ==(lhs: MainController.AppState, rhs: MainController.AppState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case let (.input(text1), .input(text2)):
            return text1 == text2
        case let (.reversed(result1), .reversed(result2)):
            return result1 == result2
        default:
            return false
        }
    }
}
