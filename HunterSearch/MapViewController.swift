//
//  MapViewController.swift
//  HunterSearch
//
//  Created by Swift Learning on 16.06.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationEnable()
        permissionToUseLocation()
    }
    
    // Реализации проверки активности службы геологации:
    
    func checkLocationEnable() {
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
        } else {
            showAlertLocation(title: "У вас выключена служба геолокации!", message: "Хотите включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    
    func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
   
    
    //Получение разрешения на использования координат пользователя.
    func permissionToUseLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            showAlertLocation(title: "Вы запретили использование геолокации", message: "Хотите разрешить?", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            fatalError()
        }
    }
    
    // Всплывающее оповещения
    func showAlertLocation(title: String, message: String, url: URL?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancellAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancellAction)
        
        present(alert, animated:  true, completion: nil)
    }
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        permissionToUseLocation()
    }
}
