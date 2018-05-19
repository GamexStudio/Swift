
//
//  AppUtility.swift
//

import UIKit
import Foundation
import CoreLocation
import AVFoundation
import MobileCoreServices
import ObjectMapper


class AppUtility: NSObject,CLLocationManagerDelegate{
    
    /*
     NOTE: This class contains all the common methods
     */
    //@objc var tabBarController:   TabBarController?
    @objc var navigationController     : UINavigationController?
    
    
    
    
    var RSKImageCropedCompletion : ((UIImage?) -> Void)?
    var locationManager : CLLocationManager = CLLocationManager()
    @objc var currentLocation : CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    
    //MARK: -
    @objc static let shared = AppUtility()
    
    override init() {
        super.init()
        intializeOnce()
    }
    
    func intializeOnce() -> Void {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 500 //Meter
        locationManager.startUpdatingLocation()
        
        //self.SETUP_SVPROGRESS()
        
        if #available(iOS 9.0, *) {
            let searchBarTextAttributes: [String : AnyObject] = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white, NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        } else {
            // Fallback on earlier versions
        }
        
        let settings = UIUserNotificationSettings(types: [.alert , .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
        //let navFont = UIFont(name: kRegularFontName, size: 18.0)
        //        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : K.Color.green, NSAttributedStringKey.font: navFont!]

    
    }
    
   
    
  
  
    
    //MARK: - Class Functions
    class func GET_CONTROLLER(_ storyboardName: String = "Main", controllerName: String) -> UIViewController {
        let storyBoard = STORY_BOARD(storyboardName)
        return storyBoard.instantiateViewController(withIdentifier: controllerName)
    }
    class func STORY_BOARD(_ storyboardMame: String = "Main") -> UIStoryboard {
        let storyboard = UIStoryboard(name: storyboardMame, bundle: nil)
        return storyboard
    }
    
    //MARK: - CLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            currentLocation = locations[0]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    class func RGBACOLOR(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: (red) / 255.0, green: (green) / 255.0, blue: (blue) / 255.0, alpha: alpha)
    }
    
    class func RGBCOLOR(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return RGBACOLOR(red: red, green: green, blue: blue, alpha: 1)
    }
  
    
    
    
    
    
    
   
    
   
    
  
    
    //MARK: - WebService
    
    class func getCommonData(completion : (() -> ())? = nil) -> Void {
        /*if (User.loggedInUser() != nil) {
            let reqParam = ["user_id" : User.loggedInUser()!.ID] as [String : Any]
            _ = WebClient.requestWithUrl(url: K.URL.GET_COMMON_DATA, parameters: reqParam, completion: { (response, error) in
                if error == nil {
                    let dictData = ((response as! NSDictionary).value(forKey: "data")) as! NSDictionary
                    AppUtility.shared.notificationCount = dictData["notification_count"] as! Int
                    AppUtility.shared.myCheckCount = dictData["my_check_in"] as! Int
                    AppUtility.shared.myFollowerCount = dictData["follower_count"] as! Int
                    
                    completion?()
                }else {
                    
                }
            })
        }*/
    }
    
    //MARK: - Webservice
    





    
    
}
