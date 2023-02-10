//
//
//  Created by Krishna on 1/02/23.
//  Copyright © 2023 Milan. All rights reserved.
//

import UIKit

public enum OTPError: Error {
    case inCompleteOTPEntry
    
    public var localizedDescription: String {
        switch self {
        case .inCompleteOTPEntry:  return "Incomplete OTP Entry"
        }
    }
}

public enum OTPLength {
    case four
    case six
    case custom(Int)
    var value: Int {
        switch self {
        case .four: return 4
        case .six: return 6
        case .custom(let num): return num
        }
    }
    
    var lineLength: Int? {
        switch self {
        case .four: return 40
        case .six: return 30
        case .custom: return nil
        }
    }
}

class PinView: UIStackView, UITextFieldDelegate, OTPTextFieldDelegate {
    
    lazy public var config:PinConfig! = PinConfig()
    var textFields = [UITextField]()
    var viewotp = [UIView]()
    public var didFinishCallback: ((String)->())?
    public var didChangeCallback: ((String)->())?
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(config:PinConfig = PinConfig()) {
        self.init()
        self.config         = config
        self.spacing        = config.spacing!
        self.axis           = .horizontal
        self.alignment      = .fill
        self.distribution   = .fillProportionally
        // setUpView()
    }
    
    public func setUpView() {
        
        for _ in 0..<config.otpLength!.value {
            let view = UIView()
            view.backgroundColor = .clear
            addArrangedSubview(view)
        }
        
        self.layoutIfNeeded()
        
        for i in stride(from: 0, to: config.otpLength!.value, by:1) {
            let view = self.arrangedSubviews[i]
            let frameSize:CGSize = self.arrangedSubviews[i].frame.size
            let textField:PinTextField      = PinTextField()
            textField.delegateOTP           = self
            textField.tag                   = i+100
            textField.frame                 = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height - 1)
            textField.delegate              = self
            textField.isSecureTextEntry     = config.isSecureTextEntry!
//            textField.placeholder           = config.showPlaceHolder! ? config.placeHolderText : ""
            textField.attributedPlaceholder = NSAttributedString(
                string: config.showPlaceHolder! ? config.placeHolderText! : "",
                attributes: [NSAttributedString.Key.foregroundColor: config.placeHolderColor!]
            )
            textField.backgroundColor       = .white
            textField.textAlignment         = .center
            textField.borderStyle           = .none
            textField.keyboardType          = .numberPad
            textField.textColor             = config.dotColor
            textField.font                  = UIFont.boldSystemFont(ofSize: 25.0)
            textField.tintColor             = .black
            view.addSubview(textField)
            let viewLine                = UIView()
            viewLine.backgroundColor    = config.lineColor

            let viewLineFrame: CGRect
            if let lineWidth = config.otpLength!.lineLength {
                viewLineFrame           = CGRect(x: CGFloat(view.frame.width / 2) - CGFloat(lineWidth / 2), y: frameSize.height - 1, width: CGFloat(lineWidth), height: config.borderLineThickness ?? 1)
            } else {
                viewLineFrame           = CGRect(x: 0, y: frameSize.height - 1, width: frameSize.width, height: config.borderLineThickness ?? 1)
            }
            viewLine.frame = viewLineFrame
            view.addSubview(viewLine)
            self.textFields.append(textField)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for (ind, val) in textFields.enumerated() {
            if val.tag == textField.tag {
                if let lineview = self.subviews[ind].subviews.last {
                    lineview.backgroundColor = config.activeLineColor
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        for (ind, _) in textFields.enumerated() {
            if let lineview = self.subviews[ind].subviews.last {
                lineview.backgroundColor = config.lineColor
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            if textField.text?.count == 0 {
                if let previousTextField = self.viewWithTag(textField.tag-1) {
                    previousTextField.becomeFirstResponder()
                }
            }
        } else {
            if let currentTextField = self.viewWithTag(textField.tag+1) {
                if string == string.filter("0123456789".contains) {
                    currentTextField.becomeFirstResponder()
                }
            } else {
                if !textField.text!.isEmpty {
                    let otp = getPin()
                    didChangeCallback?(otp)
                    return false
                }
            }
        }
        if string == string.filter("0123456789".contains) {
            textField.text = string
        }
        let otp = getPin()
        if getPin().count >= 4 {
            didChangeCallback?(otp)
            didFinishCallback?(otp)
        } else {
            didChangeCallback?(otp)
        }
        return false
    }
    
    func getPin() -> String {
        var otpCode:String = ""
        for textField in textFields {
            if textField.text != "" {
                otpCode += textField.text!
            }
        }
        return otpCode
    }
    
    func getOTP() throws -> String {
        var otpCode:String = ""
        for textField in textFields {
            if textField.text == "" {
                throw OTPError.inCompleteOTPEntry
            }
            otpCode += textField.text!
        }
        return otpCode
    }
    
    func OTPTextFieldDidPressBackspace(textfield: PinTextField) {
        if let previousTextField: PinTextField = self.viewWithTag(textfield.tag-1) as? PinTextField {
            previousTextField.text = ""
            previousTextField.becomeFirstResponder()
            let otp = getPin()
            didChangeCallback?(otp)
        }
    }
}
