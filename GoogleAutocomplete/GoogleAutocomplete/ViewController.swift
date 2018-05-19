//
//  ViewController.swift
//  GoogleAutocomplete
//
//  Created by   on 29/04/18.
//  Copyright © 2018  . All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire
import SwiftyJSON
class ViewController: UIViewController,GMSMapViewDelegate {

    var placesClient: GMSPlacesClient!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!

    @IBOutlet var mapViewPlaces         : GMSMapView!
    
    @IBOutlet var txtStartLocation: UITextField!
    @IBOutlet var txtEndLocation: UITextField!
    
    var origin = ""
    var desti = ""
    var originLat: CLLocationDegrees?
    var originLongi: CLLocationDegrees?
    var destLat: CLLocationDegrees?
    var destLongi: CLLocationDegrees?
    var isStartLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        mapViewPlaces.delegate = self
        
        mapViewPlaces.settings.zoomGestures = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setMapCameraToCurrentLocation()
            self.origin = "\(AppUtility.shared.currentLocation.coordinate.latitude),\(AppUtility.shared.currentLocation.coordinate.longitude)"
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnTapped (_ sender : UIButton){
        self.mapViewPlaces.clear()
        self.createMarker(titleMarker: "", iconMarker: #imageLiteral(resourceName: "pin_check_yellow"), latitude: originLat!, longitude: originLongi!)
        self.createMarker(titleMarker: "", iconMarker: #imageLiteral(resourceName: "pin_check_yellow"), latitude: destLat!, longitude: destLongi!)
        self.drawPath(origin: origin, destination: desti)
    }
    
    
    func setMapCameraToCurrentLocation() {
        if AppUtility.shared.currentLocation.coordinate.latitude != 0.0 &&
            AppUtility.shared.currentLocation.coordinate.longitude != 0.0 {
            let camera = GMSCameraPosition.camera(withTarget: AppUtility.shared.currentLocation.coordinate, zoom:16)
            self.mapViewPlaces?.camera = camera
        }
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if isStartLocation {
            self.txtStartLocation.text = place.name
            originLat = place.coordinate.latitude
            originLongi = place.coordinate.longitude
            origin = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        }else {
            self.txtEndLocation.text = place.name
            destLat = place.coordinate.latitude
            destLongi = place.coordinate.longitude
            desti = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
            
        }
        self.createMarker(titleMarker: place.name, iconMarker:#imageLiteral(resourceName: "pin_check_yellow"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.isDraggable=true
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = self.mapViewPlaces
        
        let coorniNate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        let camera = GMSCameraPosition.camera(withTarget: coorniNate, zoom:16)
        self.mapViewPlaces?.camera = camera
    }
    
    
    func drawPath (origin: String, destination: String) {
        /* set the parameters needed */
       let prefTravel = "driving" /* options are driving, walking, bicycling */
        let gmapKey = "Ask Google"
        /* Make the url */
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(prefTravel)&key=" + K.GOOGLE_API_KEY)
        
        /* Fire the request */
        Alamofire.request(url!).responseJSON{(responseData) -> Void in
            if((responseData.result.value) != nil) {
                /* read the result value */
                let swiftyJsonVar = JSON(responseData.result.value!)
                /* only get the routes object */
                if let resData = swiftyJsonVar["routes"].arrayObject {
                    let routes = resData as! [[String: AnyObject]]
                    /* loop the routes */
                    if routes.count > 0 {
                        for rts in routes {
                            /* get the point */
                            let overViewPolyLine = rts["overview_polyline"]?["points"]
                            let path = GMSMutablePath(fromEncodedPath: overViewPolyLine as! String)
                            
                            /* set up poly line */
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 2
                            polyline.map = self.mapViewPlaces
                            
                            self.mapViewPlaces.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: polyline.path!)))
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        return view
    }
    
    

}

extension ViewController :UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtStartLocation {
            isStartLocation = true
        }else {
            isStartLocation = false
        }
        self.showLocationPicker(textField)
    }
    
    
    func showLocationPicker (_ textField: UITextField){
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        present(acController, animated: true, completion: nil)
    }
    
    
    
    
  /*  func getUserList () {
        
        let dictParams:[String:Any] = ["type":type,
                                       "user_id": User.loggedInUser()?.ID ?? 0,
                                       "service_token":User.loggedInUser()?.serviceToken ?? "",
                                       "google_place_id":googlePlaceId]
        
        SVProgressHUD.show()
        _ = WebClient.requestWithUrl(url: K.URL.GET_USERS, parameters: dictParams, completion: { (response, error) in
            SVProgressHUD.dismiss()
            
            if error == nil {
                let dictData = response as! Dictionary<String, Any>
                let data = dictData["data"] as! Array<Dictionary<String, Any>>
                self.arrAppUser = Mapper<AppUsers>().mapArray(JSONArray: data)
                
                self.tblViewUserList.reloadData()
            }
            else{
                ISMessages.show(error?.localizedDescription, type: .warning)
            }
            
        })
        
    }
    
    */
}

