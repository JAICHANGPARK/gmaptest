//
//  ViewController.swift
//  gmaptest
//
//  Created by PARK JAICHANG on 7/26/16.
//  Copyright © 2016 JAICHANGPARK. All rights reserved.
//  admob 과 google map sdk 
// 수정 사항 
// 1. polyline 
// 2. polygon 
// 3. circle 

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
    
    /*-------------------------------------------
        zoom : 
     
        1: World
        5: Landmass/continent
        10: City
        15: Streets
        20: Buildings
    
     ------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Request.testDevices = [kGADSimulatorID]
        bannerView.delegate = self
        bannerView.adUnitID = "place your adunit code"
        //bannerView.rootViewController = self
        bannerView.loadRequest(Request)
        
        GMSServices.provideAPIKey("place your google map sdk ios api key")
        let camera = GMSCameraPosition.cameraWithLatitude(37.551549, longitude: 126.940774, zoom: 15)
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
        // compass 추가
        //let mapView = GMSMapView.mapWithFrame(.zero, camera: camera)
        //mapView?.settings.compassButton = true
        // my Location 버튼 추가
        mapView?.settings.myLocationButton = true
        // floor picker
        mapView?.settings.indoorPicker = true
        
        //Polyline 사용 하여 경로 그리기
        // 속성 
        // 1. strokeWidth : 선 두께 결정
        // 2. geodesic
        // 3. strokeColor  = polyline.strokeColor = UIColor.blueColor()
        //                   polyline.strokeColor = UIColor.redColor()
        //
        //
        //
        let path = GMSMutablePath()
        path.addCoordinate(CLLocationCoordinate2D(latitude: 37.551549, longitude: 126.940774))
        path.addCoordinate(CLLocationCoordinate2D(latitude: 37.552333, longitude: 126.942374))
        path.addCoordinate(CLLocationCoordinate2D(latitude: 37.549788, longitude: 126.913980))
        let rectangle = GMSPolyline(path: path)
        rectangle.map = mapView
        
        rectangle.strokeWidth = 10.0
        rectangle.strokeColor = UIColor.redColor()
        
        //---------------------------
        
        // polygon 
        
        // Create a rectangular path
        let rect = GMSMutablePath()
        rect.addCoordinate(CLLocationCoordinate2D(latitude: 37.551549, longitude: 126.940774))
        rect.addCoordinate(CLLocationCoordinate2D(latitude: 37.552333, longitude: 126.942374))
        rect.addCoordinate(CLLocationCoordinate2D(latitude: 37.549788, longitude: 126.913980))
        //rect.addCoordinate(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.2))
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
        polygon.strokeColor = UIColor.blackColor()
        polygon.strokeWidth = 2
        polygon.map = mapView
        
        //----------------------------------polygon
        
        //---circle 
        
        let circleCenter = CLLocationCoordinate2D(latitude: 37.551549, longitude: 126.940774)
        let circ = GMSCircle(position: circleCenter, radius: 1000)
        
        circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        circ.strokeColor = UIColor.redColor()
        circ.strokeWidth = 5
        circ.map = mapView
        
        //--------------------------------circle

        //--Use GMSURLTileLayer to fetch tiles from URL
        
        let floor = 1
        
        // Implement GMSTileURLConstructor
        // Returns a Tile based on the x,y,zoom coordinates, and the requested floor
        let urls = { (x: UInt, y: UInt, zoom: UInt) -> NSURL in
            let url = "https://www.example.com/floorplans/L\(floor)_\(zoom)_\(x)_\(y).png"
            return NSURL(string: url)!
        }
        
        // Create the GMSTileLayer
        let layer = GMSURLTileLayer(URLConstructor: urls)
        
        // Display on the map at a specific zIndex
        layer.zIndex = 100
        layer.map = mapView
        
        //-----------------------Use GMSURLTileLayer to fetch tiles from URL
        
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
        mapView?.settings.compassButton = true

        
        
    }
    
    }




