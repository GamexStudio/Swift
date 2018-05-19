//
//  MAPViewController.swift
//  GoogleAutocomplete
//
//  Created by   on 29/04/18.
//  Copyright © 2018  . All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MAPViewController: UIViewController,GMSMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  

    @IBOutlet var mapViewPlaces         : GMSMapView!

    @IBOutlet var txtFieldSearch        : UITextField!

    @IBOutlet var tblViewAutoCompletePlaces: UITableView!
    var searchString = ""

    var arrAutoCompleteResults: Array<GMSAutocompletePrediction> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewPlaces.isMyLocationEnabled = true
        mapViewPlaces.delegate = self
       
        print(AppUtility.shared.currentLocation.coordinate)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        var param : Dictionary<String, Any> = ["username" : "dan@mapall.com",
                                               "password" : "pass123"]
        
        _ = WebClient.requestWithUrl(url: K.URL.LOGIN, parameters: param) { (response, error) in
            if error == nil {
                let dictData = response as! Dictionary<String, Any>
                let user =  User(dict: dictData[K.Key.Data] as! [String : Any])
                user.save()
                
            }
            else if (error as NSError?)?.code == 2 {
                
            }else {
                
            }
            
        }
        
    }

   
    func placeAutocomplete(strInput: String) {
        let autoCompleteFilter = GMSAutocompleteFilter()
        let placesClient = GMSPlacesClient.shared()
        autoCompleteFilter.type = .noFilter
        placesClient.autocompleteQuery(strInput, bounds: nil, filter: autoCompleteFilter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            self.arrAutoCompleteResults = results!
            self.tblViewAutoCompletePlaces.reloadData()
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFieldSearch {
            
            let strInput = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            searchString = strInput
            if strInput.isEmpty {
                tblViewAutoCompletePlaces.isHidden = true
            }else {
                tblViewAutoCompletePlaces.isHidden = false
                placeAutocomplete(strInput: strInput)
            }
            
        }
        return true
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrAutoCompleteResults.count > 0 && !searchString.isEmpty{
            tblViewAutoCompletePlaces.isHidden = false
        }else {
            tblViewAutoCompletePlaces.isHidden = true
        }
        return arrAutoCompleteResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceAutoCompleteCell", for: indexPath) as! PlaceAutoCompleteCell
        let autocompletePrediction = arrAutoCompleteResults[indexPath.row]
        cell.lblPlaceAddress.text = autocompletePrediction.attributedFullText.string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let autocompletePrediction = arrAutoCompleteResults[indexPath.row]
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(autocompletePrediction.placeID!, callback: { (place, error) -> Void in
            if place != nil {
                self.view.endEditing(true)
                let camera = GMSCameraPosition.camera(withTarget: place!.coordinate, zoom:self.mapViewPlaces.camera.zoom)
                self.mapViewPlaces.camera = camera
                
                let marker = GMSMarker(position:(place?.coordinate)!)

                marker.map = self.mapViewPlaces
                let strAddress = autocompletePrediction.attributedFullText.string
                self.txtFieldSearch.text = strAddress
                
                tableView.deselectRow(at: indexPath, animated: true)
                self.arrAutoCompleteResults.removeAll(keepingCapacity : false)
                self.tblViewAutoCompletePlaces.reloadData()
                
                
                
            }
        })
    }
   

}

//let dictData = response as! Dictionary<String, Any>
//let data = dictData["data"] as! Array<Dictionary<String, Any>>
//self.arrAppUser = Mapper<AppUsers>().mapArray(JSONArray: data)

