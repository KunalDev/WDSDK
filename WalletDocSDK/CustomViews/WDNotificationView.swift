//
//  WDNotificationView.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 26/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import UIKit

let WDNotificationPressed = "WDNotificationPressed"
let WDNotificationCancelled = "WDNotificationCancelled"

enum WDInAppNotificationType : Int {
    case WDNotificationTypeGeneral
    case WDNotificationTypeReminder
    case WDNotificationTypeBill
    case WDNotificationTypeScheduled
    case WDNotificationTypePayment
    case WDNotificationTypeError
}

class WDNotificationView: UIView, UIGestureRecognizerDelegate {
    
    var message: String?
    var icon = UIImage()
    var userInfo: Any?
    var type = WDInAppNotificationType.WDNotificationTypeGeneral{
        didSet { //called when item changes
            self.setNotificationType()
        }
    }
    
    var dismissTimer: Timer?
    
    private var xButtonImage = UIImage()
    private var edgeMargin = CGPoint.zero
    private var textXMargin: CGFloat = 0.0
    private var textColor: UIColor?
    private var textAttributes: [AnyHashable : Any]?
    private var minHeight: CGFloat = 0.0
    private var imageOffsetY: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initializeView()
    }
    
    func setNotificationType(){
        switch type {
           case .WDNotificationTypeBill:
               icon = UIImage(named: "notification_bill") ?? UIImage()
           case .WDNotificationTypeError,.WDNotificationTypeGeneral:
               print("Error")
               //notificationView.icon = [UIImage imageNamed:@"notification_bill"];
           //break;
           case .WDNotificationTypeReminder:
               icon = UIImage(named: "notification_reminder") ?? UIImage()
           case .WDNotificationTypeScheduled:
               icon = UIImage(named: "notification_scheduled") ?? UIImage()
           case .WDNotificationTypePayment:
               icon = UIImage(named: "notification_payment") ?? UIImage()
           default:
               break
           }
           
           setViewBackgroundColor()
           setNeedsDisplay()
    }
    
//    func setType(_ type: WDInAppNotificationType) {
//        self.type = type
//
//        switch type {
//        case .WDNotificationTypeBill:
//            icon = UIImage(named: "notification_bill") ?? UIImage()
//        case .WDNotificationTypeError,.WDNotificationTypeGeneral:
//            print("Error")
//            //notificationView.icon = [UIImage imageNamed:@"notification_bill"];
//        //break;
//        case .WDNotificationTypeReminder:
//            icon = UIImage(named: "notification_reminder") ?? UIImage()
//        case .WDNotificationTypeScheduled:
//            icon = UIImage(named: "notification_scheduled") ?? UIImage()
//        case .WDNotificationTypePayment:
//            icon = UIImage(named: "notification_payment") ?? UIImage()
//        default:
//            break
//        }
//
//        setViewBackgroundColor()
//        setNeedsDisplay()
//    }
    
    
    func setViewBackgroundColor() {
        if type != .WDNotificationTypeError {
            backgroundColor = kMainThemeColor
        } else {
            backgroundColor = kOverdueColor
        }
    }
    
    func initializeView() {
        setViewBackgroundColor()
        
        xButtonImage = loadImage("notification_x") ?? UIImage()
        imageOffsetY = 1.0
        
        edgeMargin = CGPoint(x: 18.0, y: 12.0)
        textXMargin = 26.0
        let textFont = UIFont.systemFont(ofSize: 16.0)
        textColor = UIColor.white
      //  if let textFont = textFont {
            textAttributes = [
                NSAttributedString.Key.font: textFont,
                NSAttributedString.Key.foregroundColor: textColor as Any
            ]
        //}
        
        minHeight = 60.0
        
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        //self.layer.shadowColor = [UIColor colorWithRed:217.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0].CGColor;
        
        isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(notificationViewPressed(_:)))
        addGestureRecognizer(recognizer)
        recognizer.delegate = self
        recognizer.numberOfTouchesRequired = 1
        recognizer.numberOfTapsRequired = 1
    }
    
    
    
    @objc func notificationViewPressed(_ sender: UIGestureRecognizer?) {
        if sender?.state != .ended {
            return
        }
        let tapPoint = sender?.location(in: self) ?? CGPoint(x: 0, y: 0)
        
        var xButtonRect = CGRect(x: bounds.size.width - edgeMargin.x - xButtonImage.size.width, y: (bounds.size.height - xButtonImage.size.height) / 2.0, width: xButtonImage.size.width, height: xButtonImage.size.height)
        
        // size the cancel hit area to be of acceptable size
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        if xButtonImage.size.width < 64 {
            dx = xButtonImage.size.width - 64.0
        }
        
        if xButtonImage.size.height < 64 {
            dy = xButtonImage.size.height - 64.0
        }
        
        xButtonRect = xButtonRect.insetBy(dx: dx, dy: dy)
        
        // check if the user pressed the cancelled button
        if xButtonRect.contains(tapPoint) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WDNotificationCancelled), object: self, userInfo: userInfo as? [AnyHashable : Any])
        } else {
            // user pressed the notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WDNotificationPressed), object: self, userInfo: userInfo as? [AnyHashable : Any])
        }
    }
    
    func loadImage(_ imageName: String?) -> UIImage? {
        #if !TARGET_INTERFACE_BUILDER
        return UIImage(named: imageName ?? "")
        #else
        let bundle = Bundle(for: type(of: self))
        return UIImage(named: imageName ?? "", in: bundle, compatibleWith: traitCollection)
        #endif
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        /*CGContextRef context = UIGraphicsGetCurrentContext();
         CGContextSaveGState(context);
         CGColorRef shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
         CGContextSetShadowWithColor(context, CGSizeMake(-0, 1), 5, shadowColor);
         [super drawRect: rect];
         CGContextRestoreGState(context);*/
        
        // for iPhone X we need to take into account the notch which would hide our notification. So we offset by the safe inset
        var safeInsetY: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            if #available(iOS 13.0, *) {
                    safeInsetY += UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0.0
            }else{
                    safeInsetY += UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
            }
        }
        
        let textStartX: CGFloat = edgeMargin.x + icon.size.width + textXMargin
        let textWidth = bounds.size.width - textStartX - edgeMargin.x - xButtonImage.size.width - textXMargin
        
        var fitTextRect = message?.boundingRect(with: CGSize(width: textWidth, height: 100.0), options: .usesLineFragmentOrigin, attributes: textAttributes as? [NSAttributedString.Key : Any], context: nil) ?? CGRect()
        fitTextRect.origin.x = textStartX
        fitTextRect.origin.y = safeInsetY + (bounds.size.height - safeInsetY - fitTextRect.size.height) / 2.0
        
        (message! as NSString).draw(in: fitTextRect, withAttributes: textAttributes as? [NSAttributedString.Key : Any])
        
      //  text.drawInRect(NSOffsetRect(textRect, 0, 1), withAttributes: textFontAttributes)
        
        // center the images vertically
        icon.draw(at: CGPoint(x: edgeMargin.x, y: ((bounds.size.height - safeInsetY - icon.size.height) / 2.0) + safeInsetY + imageOffsetY))
        xButtonImage.draw(at: CGPoint(x: bounds.size.width - edgeMargin.x - xButtonImage.size.width, y: safeInsetY + ((bounds.size.height - safeInsetY - xButtonImage.size.height) / 2.0)))
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var maxSizeX: CGFloat = (edgeMargin.x + textXMargin) * 2.0 + icon.size.width + xButtonImage.size.width + 50.0
        
        if size.width > maxSizeX {
            maxSizeX = size.width
        }
        
        let textStartX: CGFloat = edgeMargin.x + icon.size.width + textXMargin
        let textWidth = maxSizeX - textStartX - edgeMargin.x - xButtonImage.size.width - textXMargin
        
        let fitTextRect = message?.boundingRect(with: CGSize(width: textWidth, height: 100.0), options: .usesLineFragmentOrigin, attributes: textAttributes as? [NSAttributedString.Key : Any], context: nil) ?? CGRect()
        
        var height = fitTextRect.size.height + edgeMargin.y * 2
        if height < minHeight {
            height = minHeight
        }
        
        if height > size.height {
            height = size.height
        }
        
        // adjust size for the safe inset (iPhone X notch cuts our notification otherwise)
        if #available(iOS 11.0, *) {
            if #available(iOS 13.0, *) {
                height += UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0.0
            }else{
                height += UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
            }
        }
        
        
        return CGSize(width: size.width, height: height)
    }
    
    override var intrinsicContentSize: CGSize {
        let textStartX: CGFloat = edgeMargin.x + icon.size.width + textXMargin
        let textWidth = bounds.size.width - textStartX - edgeMargin.x - xButtonImage.size.width - textXMargin
        
        let fitTextRect = message?.boundingRect(with: CGSize(width: textWidth, height: 100.0), options: .usesLineFragmentOrigin, attributes: textAttributes as? [NSAttributedString.Key : Any], context: nil) ?? CGRect()
        
        var height = fitTextRect.size.height + edgeMargin.y * 2
        
        if height < minHeight {
            height = minHeight
        }
        
        return CGSize(width: bounds.size.width, height: height)
    }
}


