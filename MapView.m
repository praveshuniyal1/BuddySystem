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
    
    MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D myCoordinate;
    myCoordinate.latitude=location.latitude;
    myCoordinate.longitude=location.longitude;
    annotation.coordinate = myCoordinate;
    [mapView addAnnotation:annotation];
    
    [self performSelector:@selector(zoomInToMyLocation)
               withObject:nil
               afterDelay:1];
}

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
