//
//
//  Created by Krishna on 1/02/23.
//  Copyright © 2023 Milan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewOTP: PinView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var config:PinConfig!     = PinConfig()
        config.otpLength          = .four
        config.dotColor           = .black
        config.lineColor          = #colorLiteral(red: 0.8265652657, green: 0.8502194881, blue: 0.9000532627, alpha: 1)
        config.spacing            = 20
        config.isSecureTextEntry  = true
        config.showPlaceHolder    = true
        config.borderLineThickness = 3
        viewOTP.config = config
        viewOTP.setUpView()
        viewOTP.textFields[0].becomeFirstResponder()
        
        viewOTP.didChangeCallback = { otp in
            print("otp==",otp)
        }
        
        viewOTP.didFinishCallback = { finalotp in
            print("finalotp==",finalotp)
            self.view.endEditing(true)
        }
    }


    @IBAction func submitButtonAction(_ sender: Any) {
        
        var otpCode:String = ""
        do {
            otpCode = try self.viewOTP.getOTP()
        } catch OTPError.inCompleteOTPEntry {
            print("Incomplete OTP Entry error")
        } catch let error {
            print(error.localizedDescription)
        }
        print(otpCode)
    }
}

