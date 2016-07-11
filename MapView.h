//
//  MapView.h
//  buddy
//
//  Created by Amit Verma  on 7/4/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapView : UIViewController<MKMapViewDelegate>
{
    
    IBOutlet MKMapView *mapView;
    CLLocationManager *locationManager;
    MKPolyline *routeLine; //your line
     MKPolylineView *routeLineView;
    float latitude;
    float longitude;
}

@property (nonatomic, assign) CLLocationCoordinate2D location;

- (IBAction)mapsDirections:(id)sender;
- (IBAction)backBtn:(id)sender;

@end
