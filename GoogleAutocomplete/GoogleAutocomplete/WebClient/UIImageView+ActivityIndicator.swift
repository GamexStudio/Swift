
//
//  UIImageView+ActivityIndicator.swift
//  WebClient-Swift
//
//  Created by Harry on 19/11/16.
//
//

import Foundation
import Alamofire
import AlamofireImage

var TAG_ACTIVITY_INDICATOR = 156456

public enum ActivityIndicatorViewStyle : Int {
    
    case whiteLarge
    
    case white
    
    case gray
    
    case none
}

private let cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

extension UIImageView {
    
    func imageFromCache(strURL : String?) -> UIImage? {
        if strURL != nil {
            var path = cacheDirectoryPath + "/" + (strURL?.lastPathComponent)!
            if (strURL?.contains("/thumb"))! {
                path = cacheDirectoryPath + "/t_" + (strURL?.lastPathComponent)!
            }
            if FileManager.default.fileExists(atPath: path) {
                return UIImage(contentsOfFile: path)
            }
        }
        return nil
    }
    
    func cacheImage(strURL : String, image : UIImage?) -> Void {
        if image != nil {
            var data: Data?
            if strURL.pathExtension.lowercased() == "png" {
                data = UIImagePNGRepresentation(image!)
            }
            else if strURL.pathExtension.lowercased() == "jpg" || strURL.pathExtension.lowercased() == "jpeg"{
                data = UIImageJPEGRepresentation(image!, 1)!
            }
            
            var path = cacheDirectoryPath + "/" + (strURL.lastPathComponent)
            if strURL.contains("/thumb") {
                path = cacheDirectoryPath + "/t_" + (strURL.lastPathComponent)
            }
            try? data?.write(to: URL(fileURLWithPath: path))
        }
    }
    
    @objc func setImageWithURLObjC(_ strUrl: String?, placeHolderImage: UIImage? = nil, completionBlock:((_ image: UIImage?, _ error: Error?) -> Void)? = nil) {
        setImageWithURL(strUrl, placeHolderImage: placeHolderImage, activityIndicatorViewStyle: .white, completionBlock: completionBlock)
    }
  
    func setImageWithURL(_ strUrl: String?, placeHolderImage: UIImage? = nil, activityIndicatorViewStyle: ActivityIndicatorViewStyle? = .gray, completionBlock:((_ image: UIImage?, _ error: Error?) -> Void)? = nil) {
        self.image = placeHolderImage
       
        if let image = imageFromCache(strURL: strUrl) {
            self.image = image;
            completionBlock?(image, nil)
        }else {
            if strUrl != nil {
                if activityIndicatorViewStyle != .none {
                    self.addActivityIndicator(activityStyle: activityIndicatorViewStyle!)
                }
                
                Alamofire.request(strUrl!).responseImage { response in
                    if let image = response.result.value {
                        self.image = image;
                        self.cacheImage(strURL: strUrl!, image: image)
                        completionBlock?(image, nil)
                    }
                    else {
                        self.image = placeHolderImage
                        completionBlock?(nil, response.result.error)
                    }
                    self.removeActivityIndicator()
                }
            }
        }
        
    }

    func addActivityIndicator(activityStyle: ActivityIndicatorViewStyle) {
        var activityIndicator = self.viewWithTag(TAG_ACTIVITY_INDICATOR) as? UIActivityIndicatorView
        if activityIndicator == nil {
            var indicatiorStyle :  UIActivityIndicatorViewStyle = .white
            switch activityStyle {
            case .white:
                indicatiorStyle = .white
                break
            case .whiteLarge:
                indicatiorStyle = .whiteLarge
                break
            case .gray:
                indicatiorStyle = .gray
                break
            default:
                indicatiorStyle = .white
                
            }
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: indicatiorStyle)
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

