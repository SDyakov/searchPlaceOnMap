//
//  ViewController.swift
//  showPlaceOnMap
//
//  Created by Admin on 26.09.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func serchButton(_ sender: Any)
    {
        let serchController = UISearchController(searchResultsController: nil)
        serchController.searchBar.delegate = self
        present(serchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //вызываете этот метод перед началом анимации или перехода
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Индикатор посередине экрана пока идет поиск
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text!
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (request, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if request == nil {
                print("ERROR")
            }
            else {
                //Очиста всех анатаций
                let annotation = self.mapView.annotations
                self.mapView.removeAnnotations(annotation)
                //Получение всех данных
                let latitude = request?.boundingRegion.center.latitude
                let longitude = request?.boundingRegion.center.longitude
                
                //Создание анатации 
                let annotat = MKPointAnnotation()
                annotat.title = searchBar.text
                annotat.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotat)
                
                //Увеличение карты 
                let coorditane = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coorditane, span)
                self.mapView.setRegion(region, animated: true)
                
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

