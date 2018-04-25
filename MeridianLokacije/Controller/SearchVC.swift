//
//  SearchVC.swift
//  MeridianLokacije
//
//  Created by Nikola Sabelnik on 11/7/17.
//  Copyright © 2017 SabelnikN. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire


class SearchVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var table: UITableView!
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    let annotation = MKPointAnnotation()

    var placeDetails = [Place]()
    var detail: Details!
    var placeDetail: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        table.isHidden = true
        search.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        hideWhenTapped()
        
        search.addTarget(self, action: #selector(self.textIsChanging(textField:)), for: .editingChanged)
        
        CallAPI.downloadPlaceID {
            for obj in places {
                CallAPI.downloadDetails(input: obj.placeId!) {
                    self.mapView.addAnnotations(details)
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
    }

    @IBAction func locate(_ sender: Any) {
        locationFinder()
    }

    
    func locationFinder() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            print(currentLocation)
            latitudePosition = currentLocation.coordinate.latitude
            longitudePosition = currentLocation.coordinate.longitude
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationFinder()
        }

        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05

        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(latitudePosition!, longitudePosition!)
        let region = MKCoordinateRegionMake(location, span)

        mapView.setRegion(region, animated: true)
        annotation.coordinate = CLLocationCoordinate2DMake(latitudePosition!, longitudePosition!)
        mapView.addAnnotation(annotation)
    }

    func hideWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchVC.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotation = annotation as? Details else { return nil}
        let identifier = "identifier"
        var view: MKAnnotationView

        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequedView.annotation = annotation
            view = dequedView
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = false;
            view.image = UIImage(named: "marker")
        }
        return view
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        let meridianAnnotation = view.annotation as! Details
        
        let customXibView = Bundle.main.loadNibNamed("AnnotationView", owner: self, options: nil)?[0] as! AnnotationView!
        
        customXibView?.address.text = meridianAnnotation.address
        customXibView?.phone.text = meridianAnnotation.phone
        
        let calloutFrame = view.frame
        customXibView?.frame = CGRect(x: (calloutFrame.size.width)-178.0, y: (calloutFrame.size.height)-210, width: 315, height: 146)
 
        customXibView?.blurOverlay.effect = UIBlurEffect(style: .light)
        customXibView?.layer.cornerRadius = 10.0
        customXibView?.layer.masksToBounds = false
        
        let shadowView = UIView(frame: CGRect(x: (calloutFrame.size.width)-178.0, y: (calloutFrame.size.height)-210, width: 315, height: 146))
        shadowView.translatesAutoresizingMaskIntoConstraints = true
        shadowView.backgroundColor = UIColor.lightGray
        shadowView.alpha = 0.5
        shadowView.layer.cornerRadius = 10.0
        shadowView.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowRadius = 20.0
        view.insertSubview(shadowView, at: 0)
        view.addSubview(customXibView!)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        for childView:AnyObject in view.subviews{
            childView.removeFromSuperview();
        }
    }
    
    @objc func textIsChanging(textField: UITextField) {
        
        if search.text == "" || search == nil {
            inSearch = false
            table.reloadData()
            view.endEditing(true)
        } else {
            inSearch = true
            let lower = search.text!.lowercased()
            
            filteredDetails = details.filter({$0.address?.lowercased().range(of: lower) != nil })
            
            table.reloadData()
        }
    }
}




extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? SearchCell
        
        
        
        if inSearch {
            cell?.address.text = filteredDetails[indexPath.row].address
        } else {
            cell?.address.text = details[indexPath.row].address
        }
        
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearch {
            table.isHidden = false
            return filteredDetails.count
        } else {
            table.isHidden = true
            return details.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pin = filteredDetails[indexPath.row].coordinate
        mapView.selectAnnotation(filteredDetails[indexPath.row], animated: true)
        
        let latDelta: CLLocationDegrees = 0.001
        let lonDelta: CLLocationDegrees = 0.001
        
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        tableView.isHidden = true
    }
}








