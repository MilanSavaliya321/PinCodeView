//
//
//  Created by Krishna on 1/02/23.
//  Copyright © 2023 Milan. All rights reserved.
//

import Foundation
import UIKit

public struct PinConfig {
    public var otpLength: OTPLength?
    public var dotColor: UIColor?
    
    public var lineColor: UIColor?
    public var activeLineColor: UIColor?
    public var borderLineThickness: CGFloat?
    
    public var viewMain: UIView?
    public var spacing: CGFloat?
    public var isSecureTextEntry: Bool?
    
    public var placeHolderText: String?
    public var showPlaceHolder: Bool?
    public var placeHolderColor: UIColor?
    
    init(otpLength:OTPLength = .four,
         dotColor:UIColor = UIColor.black,
         lineColor:UIColor = .lightGray.withAlphaComponent(0.5),
         activeLineColor :UIColor = .black,
         viewMain:UIView = UIView(),
         spacing:CGFloat = 8.0,
         secureTextEntry: Bool = true,
         placeHolderText: String = "*",
         showPlaceHolder: Bool = true,
         placeHolderColor: UIColor = .lightGray.withAlphaComponent(0.5),
         borderLineThickness: CGFloat = 2) {
        
        self.otpLength     = otpLength
        self.dotColor           = dotColor
        
        self.lineColor          = lineColor
        self.activeLineColor    = activeLineColor
        self.borderLineThickness = borderLineThickness
        
        self.viewMain           = viewMain
        self.spacing            = spacing
        self.isSecureTextEntry  = secureTextEntry
        
        self.placeHolderText    = placeHolderText
        self.showPlaceHolder    = showPlaceHolder
        self.placeHolderColor = placeHolderColor
    }
}
