//
//  WDNotificationManager.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 26/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox


class WDNotificationManager: NSObject {
    
    var animationInTime: CGFloat = 0.0/* time to animate the notification in */
    var animationOutTime: CGFloat = 0.0/* time to animate the notification out */
    var animationDismissTime: CGFloat = 0.0/* time to animate the notification out when pressed or cancelled */
    var displayTime: CGFloat = 0.0 // time before notification will be animated out
    
    static let sharedInstance = WDNotificationManager()
    
    private var queueArray = [WDNotificationView]()
    private var visibleArray = [WDNotificationView]()
    private var bAnimatingIn = false
    private var pushSound: SystemSoundID = 0
    
    
    override init() {
        super.init()
    //    queueArray = [WDNotificationView](repeating: 0, count: 10)
      //  visibleArray = [WDNotificationView](repeating: 0, count: 10)
        animationInTime = 0.3
        animationOutTime = 0.2
        animationDismissTime = 0.3
        displayTime = 6.0
        
        let soundPath = Bundle.main.path(forResource: "billreminder", ofType: "caf")
        let soundURL = URL(fileURLWithPath: soundPath ?? "")
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &pushSound)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationEvent(_:)), name: NSNotification.Name(rawValue: WDNotificationPressed), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationEvent(_:)), name: NSNotification.Name(rawValue: WDNotificationCancelled), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addNotificationMessage(_ message: String?, type: WDInAppNotificationType, userInfo: Any?) -> WDNotificationView? {
        
        let notificationView = WDNotificationView(frame: UIScreen.main.bounds)
        notificationView.message = message
        notificationView.userInfo = userInfo as? [AnyHashable : Any]
        notificationView.type = type
        
        notificationView.sizeToFit()
        
        notificationView.frame = CGRect(x: notificationView.frame.origin.x, y: -notificationView.frame.size.height, width: notificationView.frame.size.width, height: notificationView.frame.size.height)
        queueArray.append(notificationView)
        handleNextNotification()
        
        return notificationView
    }

    func handleNextNotification() {
        if !bAnimatingIn && queueArray.count > 0 {
            bAnimatingIn = true
            
            let topWindow: UIWindow?
            
            if #available(iOS 13.0, *) {
                topWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first ?? UIApplication.shared.windows.last
            }else{
                topWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first ?? UIApplication.shared.windows.last
            }
        
        //    let topWindow = (UIApplication.shared.keyWindow) ?? UIApplication.shared.windows.last
         //   UIApplication.shared.delegate?.window?.windowLevel = UIWindow.Level(.statusBar + 1)
            
        
            let showNotificationView = queueArray[0]
            queueArray.remove(at: 0)
            //if let showNotificationView = showNotificationView {
            topWindow?.subviews.last?.addSubview(showNotificationView)
            //}
            
            if showNotificationView.type != .WDNotificationTypeError && showNotificationView.type != .WDNotificationTypeGeneral {
                AudioServicesPlaySystemSound(pushSound)
            }
            
            //if let showNotificationView = showNotificationView {
                visibleArray.append(showNotificationView)
            //}
            UIView.animate(withDuration: TimeInterval(animationInTime), delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                showNotificationView.frame = CGRect(x: 0, y: 0, width: showNotificationView.frame.size.width , height: showNotificationView.frame.size.height )
                //nextView.transform = CGAffineTransformMakeTranslation(0, nextView.frame.size.height);
            }) { finished in
                self.bAnimatingIn = false
                showNotificationView.isUserInteractionEnabled = true
                
                self.handleNextNotification()
                
                showNotificationView.dismissTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.displayTime), target: self, selector: #selector(self.dismissNotificationView(_:)), userInfo: showNotificationView, repeats: false)
                
            }
        }
    }
    
    
    //  Converted to Swift 5.1 by Swiftify v5.1.28520 - https://objectivec2swift.com/
    @objc func dismissNotificationView(_ timer: Timer?) {
        let notificationView = timer?.userInfo as? WDNotificationView
        animateNotificationViewOff(notificationView, duration: animationOutTime)
    }
    
    /*
     - (void)dismissNotificationView:(WDNotificationView *)notificationView
     {
     [self animateNotificationViewOff:notificationView duration:self.animationOutTime];
     }*/
    
    @objc func handleNotificationEvent(_ notification: Notification?) {
        let notificationView = notification?.object as? WDNotificationView
        notificationView?.isUserInteractionEnabled = false
        notificationView?.dismissTimer?.invalidate()
        animateNotificationViewOff(notificationView, duration: animationDismissTime)
    }
    
    func animateNotificationViewOff(_ notificationView: WDNotificationView?, duration: CGFloat) {
        // [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveEaseIn, animations: {
            notificationView?.frame = CGRect(x: 0.0, y: (notificationView?.frame.origin.y ?? 0.0) - (notificationView?.frame.size.height ?? 0.0), width: notificationView?.frame.size.width ?? 0.0, height: notificationView?.frame.size.height ?? 0.0)
            //notificationView.transform = CGAffineTransformMakeTranslation(0,  0);
        }) { finished in
            self.visibleArray.removeAll { $0 as AnyObject === notificationView as AnyObject }
            notificationView?.removeFromSuperview()
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowLevel = .normal
        }
    }
    
    
    func isNotificationViewComplete(_ notificationView: WDNotificationView?) -> Bool {
        if notificationView != nil {
            if let notificationView = notificationView {
                if visibleArray.contains(notificationView) {
                    return false
                }
            }
            
            if let notificationView = notificationView {
                if queueArray.contains(notificationView) {
                    return false
                }
            }
        }
        
        
        return true
    }
    
    func remove(_ notificationView: WDNotificationView?, animated bAnimated: Bool) {
        // if its displayed
        if notificationView?.superview != nil {
            notificationView?.dismissTimer?.invalidate()
            notificationView?.dismissTimer = nil
            
            if (visibleArray.last) == notificationView {
                bAnimatingIn = false
                handleNextNotification()
            }
            
            if bAnimated {
                animateNotificationViewOff(notificationView, duration: animationDismissTime)
            } else {
                visibleArray.removeAll { $0 as AnyObject === notificationView as AnyObject }
                notificationView?.removeFromSuperview()
            }
        } else if let notificationView = notificationView {
            if queueArray.contains(notificationView) {
                queueArray.removeAll { $0 as AnyObject === notificationView as AnyObject }
            }
        }
    }
    
    func dismissAllVisibleNotificationViews(_ bAnimated: Bool) {
        if bAnimated {
            for notificationView in visibleArray {
                if notificationView.frame.origin.y == 0 {
                    animateNotificationViewOff(notificationView, duration: animationDismissTime)
                }
            }
        } else {
            for notificationView in visibleArray {
                notificationView.dismissTimer?.invalidate()
                notificationView.dismissTimer = nil
                notificationView.removeFromSuperview()
            }
        }
    }
}
