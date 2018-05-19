//
//  MultiplePinsViewController.swift
//  GoogleAutocomplete
//
//  Created by  on 06/05/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class MultiplePinsViewController: UIViewController,GMSMapViewDelegate {

    @IBOutlet weak var viewMap : GMSMapView!
    
    var modeldisco = ModelDiscovery(json: JSON.null)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewMap?.isMyLocationEnabled = true
        viewMap?.delegate = self
        self.getDisco()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print(AppUtility.shared.currentLocation.coordinate)
           // self.setMapCameraToCurrentLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Other Methods
    
    func setMapCameraToCurrentLocation() {
        if AppUtility.shared.currentLocation.coordinate.latitude != 0.0 &&
            AppUtility.shared.currentLocation.coordinate.longitude != 0.0 {
            let camera = GMSCameraPosition.camera(withTarget: AppUtility.shared.currentLocation.coordinate, zoom:16)
            self.viewMap?.camera = camera
        }
    }
    
    func  getDisco() -> Void {
        var dictParams:[String:Any] = ["login_user_id":50,
                                       "user_id":50,
                                       "filter":0]
        
        WSManager.POST("http://52.25.140.200:5004/api/place/user-discoveries", param: dictParams, success: { (jsonResponse) in
            
            self.modeldisco = ModelDiscovery(json: jsonResponse)
            var bounds = GMSCoordinateBounds()

            if let dataValue = self.modeldisco.data {
                for data in dataValue {
                    
                    data.marker.map = self.viewMap
                    bounds = bounds.includingCoordinate(data.marker.position)
                    self.viewMap.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0 , 50.0 ,50.0 ,50.0)))


                    
//                    print("Data object \(String(describing: data.locationName))")
//                    print("Data object \(String(describing: data.latitude))")
//                    print("Data object \(String(describing: data.longitude))")
                }
            }
            
            //self.viewMap.animate(with: update)
         
          
            
//            let dictData = jsonResponse.dictionaryObject as? [String: Any]
//            let arrData = dictData!["data"] as! Array<Dictionary<String, Any>>
//
        
            
        }) { (error, isTimeOut) in
            
        }
        
    }
    
    
    
}
