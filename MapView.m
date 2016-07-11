//
//  MapView.m
//  buddy
//
//  Created by Amit Verma  on 7/4/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

#import "MapView.h"


@interface MapView ()

@end

@implementation MapView
@synthesize location;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
//    
//     latitude = locationManager.location.coordinate.latitude;
//     longitude = locationManager.location.coordinate.longitude;
    
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LongitudeAs"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LatitudeAs"]);

    
    
    latitude = [[[NSUserDefaults standardUserDefaults]objectForKey:@"LatitudeAs"] floatValue];
    longitude = [[[NSUserDefaults standardUserDefaults]objectForKey:@"LongitudeAs"] floatValue];
    
    MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D myCoordinate;
    myCoordinate.latitude=location.latitude;
    myCoordinate.longitude=location.longitude;
    annotation.coordinate = myCoordinate;
    [mapView addAnnotation:annotation];
    
    
//    CLLocationCoordinate2D coordinateArray[2];
//    coordinateArray[0] = CLLocationCoordinate2DMake(latitude, longitude);
//    coordinateArray[1] = CLLocationCoordinate2DMake(location.latitude, location.longitude);
//    
//    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
//    [mapView setVisibleMapRect:[routeLine boundingMapRect]]; //If you want the route to be
//    
//    [mapView addOverlay:routeLine];
    
    
    [self performSelector:@selector(zoomInToMyLocation)
               withObject:nil
               afterDelay:1];
}

//-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
//{
//    if(overlay == routeLine)
//    {
//        if(nil == routeLineView)
//        {
//            routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
//            routeLineView.fillColor = [UIColor redColor];
//            routeLineView.strokeColor = [UIColor redColor];
//            routeLineView.lineWidth = 5;
//            
//        }
//        
//        return routeLineView;
//    }
//    
//    return nil;
//}

-(void)zoomInToMyLocation
{
   
    MKCoordinateRegion region ;
    region.center.latitude = location.latitude ;
    region.center.longitude = location.longitude;
    region.span.longitudeDelta = 0.01;
    region.span.latitudeDelta = 0.01;
    
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:region];
    [mapView setRegion:adjustedRegion animated:YES];
    
    //[mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)myMap
            viewForAnnotation:(id < MKAnnotation >)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString* ShopAnnotationIdentifier = @"shopAnnotationIdentifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ShopAnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ShopAnnotationIdentifier] ;
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
    }
    return pinView;
}

- (IBAction)mapsDirections:(id)sender {
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",latitude, longitude, location.latitude, location.longitude];
   [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn:(id)sender
{
 [self dismissViewControllerAnimated:YES completion:nil];
}
@end
