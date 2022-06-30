//
//  ViewController.swift
//  MapApplication
//
//  Created by Artem Stetsenko on 30.06.2022.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController {
    var annotationArray = [MKPointAnnotation]()
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let addAdress: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "addAdress"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let resetRoute: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "reset"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    let startNavigation: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "startButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
      setConstraints()
        addAdress.addTarget(self, action: #selector(addAdressButtonPressed), for: .touchUpInside)
        resetRoute.addTarget(self, action: #selector(resetRouteButtonPressed), for: .touchUpInside)
        startNavigation.addTarget(self, action: #selector(startNavigationButtonPressed), for: .touchUpInside)
        mapView.delegate = self
    }
    
    
    @objc func addAdressButtonPressed(){
        alertAddAdress(title: "Where to go?", placeholder: "Enter Adress") { [self] (text) in
            setupPlacemark(addressPlace: text)
    }
    
        
    }
    @objc func resetRouteButtonPressed(){
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationArray = [MKPointAnnotation]()
        startNavigation.isHidden = true
        resetRoute.isHidden = true
    }
    @objc func startNavigationButtonPressed(){
        for index in 0...annotationArray.count - 2 {
            createDirectionRequest(startCoordinate: annotationArray[index].coordinate, destinationCoordinate: annotationArray[index + 1].coordinate)
            }
        mapView.showAnnotations(annotationArray, animated: true)
    }
    
    private func setupPlacemark (addressPlace: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressPlace) { [self] (placemark, error) in
            if let error = error {
                print(error)
                alertError(title: "Error", message: "Something going wrong")
                return
            }
            guard let placemarks = placemark else {return}
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(addressPlace)"
            guard let placeMarkLocation = placemark?.location else { return}
            annotation.coordinate = placeMarkLocation.coordinate
            
            annotationArray.append(annotation)
            
            if annotationArray.count > 2 {
                startNavigation.isHidden = false
                resetRoute.isHidden = false
            }
            mapView.showAnnotations(annotationArray, animated: true)
        }
    }
    private func createDirectionRequest (startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D){
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate {(responce, error) in
            if let error = error {
                print (error)
                return
            }
            guard let responce = responce else {
                self.alertError(title: "Error", message: "Route unreachable")
                return
            }
            var minRoute = responce.routes[0]
            for route in responce.routes {
                minRoute = (route.distance < minRoute.distance) ? route: minRoute
            }
            self.mapView.addOverlay(minRoute.polyline)
        }
    }
    
    
    func setConstraints () {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)])
        
        mapView.addSubview(addAdress)
        NSLayoutConstraint.activate([
            addAdress.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            addAdress.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            addAdress.heightAnchor.constraint(equalToConstant: 40),
            addAdress.widthAnchor.constraint(equalToConstant: 40)])
        
        mapView.addSubview(resetRoute)
        NSLayoutConstraint.activate([
            resetRoute.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50),
            resetRoute.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            resetRoute.heightAnchor.constraint(equalToConstant: 40),
            resetRoute.widthAnchor.constraint(equalToConstant: 40)])
       
        mapView.addSubview(startNavigation)
        NSLayoutConstraint.activate([
            startNavigation.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50),
            startNavigation.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            startNavigation.heightAnchor.constraint(equalToConstant: 40),
            startNavigation.widthAnchor.constraint(equalToConstant: 40)])
        
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .black
        return renderer
    }
    
}
