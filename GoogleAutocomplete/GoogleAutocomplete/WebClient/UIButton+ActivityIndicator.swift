//
//  UIButton+ActivityIndicator.swift
//  WebClient-Swift
//
//  Created by Harry on 19/11/16.
//
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

extension UIButton {
    
    func setImageWithURL(strUrl: String, activityIndicatorViewStyle: UIActivityIndicatorViewStyle, controlState: UIControlState) {
        setImageWithURL(strUrl: strUrl, placeHolderImage: nil, activityIndicatorViewStyle: activityIndicatorViewStyle, controlState:controlState)
    }
    
    func setImageWithURL(strUrl: String, placeHolderImage placeholderImage: UIImage?, activityIndicatorViewStyle: UIActivityIndicatorViewStyle, controlState: UIControlState) {
        setImageWithURL(strUrl: strUrl, placeHolderImage: placeholderImage, activityIndicatorViewStyle: activityIndicatorViewStyle, controlState: controlState, completionBlock: nil)
    }
    
    func setImageWithURL(strUrl: String, placeHolderImage placeholderImage: UIImage?, activityIndicatorViewStyle: UIActivityIndicatorViewStyle, controlState: UIControlState, completionBlock:((_ image: UIImage?, _ error: Error?) -> Void)?) {
        Alamofire.request(strUrl).responseImage { response in
            if let image = response.result.value {
                self.addActivityIndicator(activityStyle: activityIndicatorViewStyle)
                self.setImage(image, for: controlState)
                completionBlock?(image, nil)
            }
            else {
                self.removeActivityIndicator()
                completionBlock?(nil, response.result.error)
            }
        }
    }
    
    func addActivityIndicator(activityStyle: UIActivityIndicatorViewStyle) {
        var activityIndicator = self.viewWithTag(TAG_ACTIVITY_INDICATOR) as? UIActivityIndicatorView
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: activityStyle)
            activityIndicator!.center = CGPoint(x: CGFloat(self.frame.size.width / 2), y: CGFloat(self.frame.size.height / 2))
            activityIndicator!.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
            activityIndicator!.hidesWhenStopped = true
            activityIndicator!.tag = TAG_ACTIVITY_INDICATOR
            self.addSubview(activityIndicator!)
        }
        activityIndicator?.startAnimating()
    }
    
    func removeActivityIndicator() {
        let activityIndicator = self.viewWithTag(TAG_ACTIVITY_INDICATOR) as? UIActivityIndicatorView
        if activityIndicator != nil{
            activityIndicator!.removeFromSuperview()
        }
    }
    
}
