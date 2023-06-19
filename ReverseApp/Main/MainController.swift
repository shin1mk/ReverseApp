//
//  MainController.swift
//  ReverseApp
//
//  Created by SHIN MIKHAIL on 24.05.2023.

import SnapKit
import UIKit

final class MainController: UIViewController {
    //MARK: - Private UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reverse words"
        label.font = UIFont.customFontBold(ofSize: 34)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    private let subtitleLabel: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "This application will reverse your words.\nPlease type text below"
        subtitle.textColor = Colors.gray
        subtitle.textAlignment = .center
        subtitle.font = UIFont.customFontRegular(ofSize: 17)
        subtitle.numberOfLines = 3
        return subtitle
    }()
    private let inputTextField: UITextField = {
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
    private let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = Colors.lightGray
        return line
    }()
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Default", "Custom"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.black], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.black], for: .normal)
        segmentedControl.selectedSegmentTintColor = Colors.systemBlue
        segmentedControl.backgroundColor = Colors.lightSystemBlue
        return segmentedControl
    }()
    private let defaultInputTextField: UITextField = {
        let input = UITextField()
        input.borderStyle = .none
        input.font = UIFont.customFontRegular(ofSize: 17)
        input.textColor = Colors.gray
        let placeholderFont = UIFont.customFontRegular(ofSize: 17)
        let placeholderText = "All characters except alphabetic symbols"
        let attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: placeholderFont as Any,
                NSAttributedString.Key.paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    return style
                }()
            ]
        )
        input.attributedPlaceholder = attributedPlaceholder
        input.isEnabled = false
        return input
    }()
    private let customInputTextField: UITextField = {
        let input = UITextField()
        input.borderStyle = .none
        input.font = UIFont.customFontRegular(ofSize: 17)
        input.textColor = Colors.gray
        let placeholderFont = UIFont.customFontRegular(ofSize: 17)
        let placeholderText = "Text to ignore"
        let attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: placeholderFont as Any
            ]
        )
        input.attributedPlaceholder = attributedPlaceholder
        input.isHidden = true
        input.isEnabled = true
        return input
    }()
    private let resultLabel: UILabel = {
        let result = UILabel()
        result.textColor = Colors.systemBlue
        result.textAlignment = .left
        result.font = UIFont.customFontRegular(ofSize: 24)
        result.numberOfLines = 0
        return result
    }()
    private let reverseButton: UIButton = {
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
    private let reverseManager: ReverseManager? = ReverseManager()
    private var buttonBottomConstraint: Constraint?
    private var appState: AppState = .empty {
        didSet {
            updateUI(for: appState, and: segmentedControlState)
        }
    }
    private var segmentedControlState: SegmentedControlState = .first {
        didSet {
            updateUI(for: appState, and: segmentedControlState)
        }
    }
    
    enum AppState {
        case empty
        case input(text: String)
        case reversed(result: String)
    }
    enum SegmentedControlState {
        case first
        case second(text: String)
        init?(index: Int, text: String?) {
            if index == 0 {
                self = .first
            } else if index == 1, let text = text {
                self = .second(text: text)
            } else {
                return nil
            }
        }
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFieldDelegate()
        setupKeyboardDismiss()
        addKeyboardObserver()
        setupResultLabelGesture()
        segmentedControlTarget()
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
        // input main
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
        // segmented control
        self.view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(Constants.Segmented.topOffset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(Constants.Segmented.height)
        }
        // default input
        self.view.addSubview(defaultInputTextField)
        defaultInputTextField.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(Constants.InputDefaultCustom.topOffset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(Constants.InputDefaultCustom.height)
        }
        // custom input
        self.view.addSubview(customInputTextField)
        customInputTextField.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(Constants.InputDefaultCustom.topOffset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(Constants.InputDefaultCustom.height)
        }
        // result
        self.view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(defaultInputTextField.snp.bottom).offset(Constants.ResultLabel.topOffset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
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
    
    func updateUI(for appState: AppState, and segmentedControlState: SegmentedControlState) {
        func applyEmptyState() {
            reverseButton.setTitle("Reverse", for: .normal)
            reverseButton.isEnabled = false
            reverseButton.backgroundColor = Colors.lightSystemBlue
            inputTextField.text = ""
            resultLabel.text = ""
            customInputTextField.text = ""
            segmentedControl.selectedSegmentIndex = 0
            defaultInputTextField.isHidden = false
            customInputTextField.isHidden = true
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
        
        switch segmentedControlState {
        case .first:
            defaultInputTextField.isHidden = false
            customInputTextField.isHidden = true
        case .second(let text):
            defaultInputTextField.isHidden = true
            customInputTextField.isHidden = false
            customInputTextField.text = text
        }
    }
    
    // Button
    private func setupButtonTarget() {
        reverseButton.addTarget(self, action: #selector(reverseButtonTapped), for: .touchUpInside)
    }
    
    @objc func reverseButtonTapped(_ sender: UIButton) {
        switch appState {
        case .empty:
            break
        case .input(let text):
            let reversedText: String
            if segmentedControl.selectedSegmentIndex == 1 {
                let customTextToIgnore = customInputTextField.text ?? ""
                reversedText = reverseManager?.reverseTextIgnoring(text, ignoring: customTextToIgnore) ?? ""
            } else {
                reversedText = reverseManager?.reverseText(text) ?? ""
            }
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
    // Segmented control
    private func segmentedControlTarget() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if let state = SegmentedControlState(index: sender.selectedSegmentIndex, text: customInputTextField.text) {
            segmentedControlState = state
        }
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

