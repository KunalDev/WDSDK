//
//  WDLoadingView.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 17/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation
import UIKit

class WDLoadingView: UIView {
    
    var lineWidth: CGFloat = 0.0
    /// var tintColor: UIColor?
    var showCount: Int = 0
    var isSpinning = false
    var replicatorLayer: CAReplicatorLayer!
    
    static let sharedInstance = WDLoadingView(frame:CGRect(x: 0, y: 0, width: 40, height: 40))
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        showCount = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.startSpinner), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    class func addLoadingView(to view: UIView) -> WDLoadingView {
        let loadingView = WDLoadingView.initLoadingView()
        let center = CGPoint(x: (view.frame.size.width) / 2.0, y: (view.frame.size.height) / 2.0)
        loadingView.center = center
        view.addSubview(loadingView)
        return loadingView
    }
    
    class func initLoadingView() -> WDLoadingView {
        
        //if let loadingView = WDLoadingView.sharedInstance as? WDLoadingView{
            
            let loadingView = WDLoadingView.sharedInstance
            
            loadingView.isHidden = false
            loadingView.alpha = 0.0
            
            UIView.animate(withDuration: 0.5, animations: {
                loadingView.alpha = 1.0
            }) { finished in
                
            }
            
            loadingView.startSpinner()
            let height = Float(UIScreen.main.bounds.size.height)
            let width = Float(UIScreen.main.bounds.size.width)
            let center = CGPoint(x: CGFloat(width / 2), y: CGFloat(height / 2))
            loadingView.center = center
            return loadingView
       // }
    }
    
    class func hideLoadingView(in view: UIView?) {
        if let loadingView = WDLoadingView.getLoadingView(in: view){
            UIView.animate(withDuration: 0.5, animations: {
                loadingView.alpha = 0.0
            }) { finished in
                loadingView.stopSpinner()
                if loadingView != nil {
                    loadingView.removeFromSuperview()
                }
            }
        }
    }
    
    class func getLoadingView(in view: UIView?) -> WDLoadingView? {
        let subviews = view?.subviews
        //let WDLoadingViewClass = WDLoadingView.self
        for findView in subviews ?? [] {
            if (findView is WDLoadingView) {
                return findView as? WDLoadingView
            }
        }
        return nil
    }
    
    func initialize(){
        
    }
    
    func setup() {
        replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = bounds
        
        let instances: CGFloat = 15.0
        let layerWidth: CGFloat = 3.0
        let cornerRadius: CGFloat = layerWidth / 2.0
        
        replicatorLayer.instanceCount = Int(instances)
        replicatorLayer.instanceDelay = 1.0 / 30.0
        replicatorLayer.preservesDepth = false
        replicatorLayer.instanceColor = UIColor(red: 0.0, green: 131.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0).cgColor
        
        replicatorLayer.instanceRedOffset = 0.0
        replicatorLayer.instanceGreenOffset = 0.0
        replicatorLayer.instanceBlueOffset = -0.002
        replicatorLayer.instanceAlphaOffset = 0.0
        
        let angle: CGFloat = .pi * 2.0 / instances
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        
        let instanceLayer = CALayer()
        
        let midX: CGFloat = bounds.midX - layerWidth / 2.0
        instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 3.0)
        instanceLayer.backgroundColor = UIColor.white.cgColor
        instanceLayer.cornerRadius = cornerRadius
        replicatorLayer.addSublayer(instanceLayer)
        
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = NSNumber(value: 1.0)
        fadeAnim.toValue = NSNumber(value: 0.0)
        fadeAnim.duration = 0.6
        fadeAnim.repeatCount = Float(INT32_MAX)
        instanceLayer.opacity = 0.1
        instanceLayer.add(fadeAnim, forKey: "FadeAnimation")
        
        layer.addSublayer(replicatorLayer)
    }
    
    @objc func startSpinner() {
        isSpinning = true
        setup()
    }
    
    func stopSpinner() {
        isSpinning = false
        replicatorLayer.removeFromSuperlayer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
