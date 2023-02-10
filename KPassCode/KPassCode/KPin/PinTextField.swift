//
//
//  Created by Krishna on 1/02/23.
//  Copyright © 2023 Milan. All rights reserved.
//

import UIKit

protocol OTPTextFieldDelegate {
    func OTPTextFieldDidPressBackspace(textfield: PinTextField)   
}

class PinTextField: UITextField {

    var delegateOTP:OTPTextFieldDelegate!
    
    override func deleteBackward() {
        super.deleteBackward()
        
        if delegateOTP != nil {
            delegateOTP.OTPTextFieldDidPressBackspace(textfield: self)
        }
    }
    
}
