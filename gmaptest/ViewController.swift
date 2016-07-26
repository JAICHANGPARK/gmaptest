//
//  ViewController.swift
//  gmaptest
//
//  Created by PARK JAICHANG on 7/26/16.
//  Copyright © 2016 JAICHANGPARK. All rights reserved.
//
// admob 이랑 gmsdk 사용 

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMobileAds

class VacationDestination: NSObject {
    
    let name : String
    let location : CLLocationCoordinate2D
    let zoom : Float
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float) {
        self.name = name
        self.location = location
        self.zoom = zoom
        
    }
    
}

class ViewController: UIViewController, GADBannerViewDelegate, GMSMapViewDelegate {
    @IBOutlet weak var bannerView: GADBannerView!
    
    let Request = GADRequest()

    var mapView: GMSMapView?
    
    var currentDestination: VacationDestination?
    
    let destinations = [VacationDestination(name: "sogang", location: CLLocationCoordinate2DMake(37.552333, 126.942374), zoom: 15),VacationDestination(name: "sogang", location: CLLocationCoordinate2DMake(37.549788, 126.913980), zoom: 15)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Request.testDevices = [kGADSimulatorID]
        bannerView.delegate = self
        bannerView.adUnitID = "place your adunit"
        //bannerView.rootViewController = self
        bannerView.loadRequest(Request)
        
        GMSServices.provideAPIKey("place your provide api key")
        let camera = GMSCameraPosition.cameraWithLatitude(37.551549, longitude: 126.940774, zoom: 10)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
       // mapView.myLocationEnabled = true
        self.view = mapView
        
        //지도 종류 변경 
        // 1. kGMSTypeNormal = nomal
        // 2. kGMSTypeHybrid = Hybrid
        // 3. kGMSTypeSatellite = 위성 
        // 4. kGMSTypeTerrain = Terrain
        // 5. kGMSTypeNone
        mapView?.mapType = kGMSTypeNormal
        
        // 실내 지도 키고 끄기
        mapView?.indoorEnabled = false
        
        //
        
        mapView?.myLocationEnabled = true
        
        /* 파노라마 뷰
        let panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView
        
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: -33.732, longitude: 150.312))
 
        */
        
        let currentLocation = CLLocationCoordinate2DMake(37.551549, 126.940774)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "sogang univ"
        marker.map = mapView
        
        // 뷰 상위에 버튼 생성 (코드로 만들어 버리는 경우 )
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(next))
    }
    
        func next(){
            
            if currentDestination == nil {
                currentDestination = destinations.first
               // mapView?.camera = GMSCameraPosition.cameraWithTarget(currentDestination!.location, zoom: currentDestination!.zoom)

            } else{
                if let index = destinations.indexOf(currentDestination!){
                    currentDestination = destinations[index + 1]
                }
            }
            
            setMapCamera()
            
            /*
            let nextLocation = CLLocationCoordinate2DMake(37.549788, 126.913980)
            mapView?.camera = GMSCameraPosition.cameraWithLatitude(nextLocation.latitude, longitude: nextLocation.longitude, zoom: 15) //mapView?.camera = GMSCameraPosition.cameraWithLatitude(37.549788, longitude: 126.913980, zoom: 10)
            
            let marker = GMSMarker(position: nextLocation)
            marker.title = currentDestination?.name
            marker.map = mapView
            */
        }
    
    private func setMapCamera(){
        
        
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        
        mapView?.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(currentDestination!.location, zoom: currentDestination!.zoom))
        
        CATransaction.commit()
        
        let marker = GMSMarker(position: currentDestination!.location)
        marker.title = currentDestination?.name
        marker.map = mapView
    }
}




