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
    }
    
    
    @objc func addAdressButtonPressed(){
        alertAddAdress(title: "Where to go?", placeholder: "Enter Adress") { (text) in
            print (text)
    }
    
        
    }
    @objc func resetRouteButtonPressed(){
        print("Reset")
    }
    @objc func startNavigationButtonPressed(){
        print("Start")
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

