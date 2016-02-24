//
//  LocationManager.m
//  Hello
//
//  Created by webAstral on 11/3/14.
//  Copyright (c) 2014 Webastral. All rights reserved.
//

#import "LocationManager.h"
#import "ServerManager.h"

@implementation LocationManager


static LocationManager *sharedInstance = nil;
typedef void(^addressCompletion)(NSString *);

+(LocationManager*)locationInstance
{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!sharedInstance)
        {
            sharedInstance = [[self alloc] init];
           
        }
        //allochiamo la sharedInstance
        
    });
    
    return sharedInstance;
}

-(CLLocationCoordinate2D)getcurrentLocation
{
    
    if (locationManager==nil)
    {
        locationManager=[[CLLocationManager alloc]init];

    }
       locationManager.delegate=self;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) 
        {
            [locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];

        }
        
   [locationManager startUpdatingLocation];
    
    //[locationManager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:600.0];
    
   
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    
    return coordinate;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
   
   // [ServerManager showAlertView:@"Error" withmessage:error.localizedDescription];
    //[errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   // NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        longitudeLabel = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        latitudeLabel = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        [[NSUserDefaults standardUserDefaults] setObject:longitudeLabel forKey:@"LongitudeAs"];
                [[NSUserDefaults standardUserDefaults] setObject:latitudeLabel forKey:@"LatitudeAs"];
    }
}
// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
     CLLocation * currentLoc = (CLLocation *)[locations lastObject];
    if (currentLoc != nil)
    {
        longitudeLabel = [NSString stringWithFormat:@"%.4f", currentLoc.coordinate.longitude];
        latitudeLabel = [NSString stringWithFormat:@"%.4f", currentLoc.coordinate.latitude];
        
        [[NSUserDefaults standardUserDefaults] setObject:longitudeLabel forKey:@"LongitudeAs"];
        [[NSUserDefaults standardUserDefaults] setObject:latitudeLabel forKey:@"LatitudeAs"];
        
        
        
        CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:currentLoc.coordinate.latitude longitude:currentLoc.coordinate.longitude];
        
        [self getAddressFromLocation:eventLocation complationBlock:^(NSString * address) {
            if(address)
            {
               NSString* getaddress = address;
                
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isUpdated"]==NO)
                {
                    [[NSUserDefaults standardUserDefaults]setObject:getaddress forKey:@"getAddress"];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isUpdated"];
                    
                    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"userID"])
                    {
                        NSMutableDictionary *postdict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"userID"],@"user_id",latitudeLabel,@"latitude",longitudeLabel,@"longitude",nil];
                        
                        if ([[ServerManager getSharedInstance]checkNetwork]==YES)
                        {
                            [ServerManager getSharedInstance].Delegate=self;
                            [[ServerManager getSharedInstance]postDataOnserverLocation:postdict withrequesturl:KUpdateUserLocation];
                            
                            
                        }

                       /*
                        
                        NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://dev414.trigma.us/Buddy/webs/%@user_id=%@&latitude=%@&longitude=%@",KUpdateUserLocation,[[NSUserDefaults standardUserDefaults]valueForKey:@"userID"],latitudeLabel,longitudeLabel]];
                        
                        
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                        [request setURL:urlString];
                        [request setHTTPMethod:@"POST"];
                        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                        
                        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                        [connection start];

                        */
                        
                   }
                }
                else
                {
                    if ([getaddress isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"getAddress"]])
                    {
                        
                    }
                    else
                    {
                        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"userID"])
                        {
                            NSMutableDictionary *postdict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"userID"],@"user_id",latitudeLabel,@"latitude",longitudeLabel,@"longitude",nil];
                            
                            if ([[ServerManager getSharedInstance]checkNetwork]==YES)
                            {
                                [ServerManager getSharedInstance].Delegate=self;
                                [[ServerManager getSharedInstance]postDataOnserverLocation:postdict withrequesturl:KUpdateUserLocation];
                                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isUpdated"];
                                
                            }

                            
                            /*
                            
                            NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://dev414.trigma.us/Buddy/webs/%@user_id=%@&latitude=%@&longitude=%@",KUpdateUserLocation,[[NSUserDefaults standardUserDefaults]valueForKey:@"userID"],latitudeLabel,longitudeLabel]];
                            
                            
                            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                            [request setURL:urlString];
                            [request setHTTPMethod:@"POST"];
                            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                            
                            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            [connection start];

                            */
                                                    }
                        
                    }
                    
                }
                
                
            }
        }];
        
        
        
        
    }

}


-(void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             address = [NSString stringWithFormat:@"%@, %@ %@", placemark.name, placemark.postalCode, placemark.locality];
             completionBlock(address);
         }
     }];
}




-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    webData=[[NSMutableData alloc]init];
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[ServerManager getSharedInstance] hideHud];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{


}



-(void)serverReponse:(NSDictionary *)responseDict withrequestName:(NSString *)serviceurl
{
    NSLog(@"Response tripathi -->> %@ and serviceURL------->>> %@",responseDict,serviceurl);
    
    if ([serviceurl isEqual:KUpdateUserLocation])
    {
        if ([[responseDict valueForKey:@"message"] isEqualToString:@"You have already registered with this facebook id"])
        {
            [KappDelgate showHomeView];
        }
        [locationManager stopUpdatingLocation];
    }

}
-(void)failureRsponseError:(NSError *)failureError
{
    [[ServerManager getSharedInstance]hideHud];
    [ServerManager showAlertView:@"Error!!" withmessage:failureError.localizedDescription];
}

- (NSArray*)getDistanceaccordingRadius:(int)circle
{
    
    //CLLocationDistance radius = circle;
    double lat=currentLocation.coordinate.latitude;
    double longit=currentLocation.coordinate.longitude;
//    CLLocation* target = [[CLLocation alloc] initWithLatitude:lat longitude:longit];
//    CLLocationDistance distance = [currentLocation distanceFromLocation:target];
//    return distance;
    
    NSArray *testLocations = @[[[CLLocation alloc] initWithLatitude:19.0759 longitude:72.8776]];
    
    CLLocationDistance maxRadius = circle; // in meters
    //Current location coordinate..
     CLLocation* targetLocation = [[CLLocation alloc] initWithLatitude:lat longitude:longit];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(CLLocation *testLocation, NSDictionary *bindings) {
        return ([testLocation distanceFromLocation:targetLocation] <= maxRadius);
    }];
    
    NSArray *closeLocations = [testLocations filteredArrayUsingPredicate:predicate];
    
    NSLog(@"closeLocations=%@",closeLocations);

    return closeLocations;
       
}

-(void)reverseGeocodeAddrLatitude:(CLLocationDegrees)latitude
                            longitude:(CLLocationDegrees)longitude Success:(void(^)(NSString * currentAddress))sucess
{
    if (geoCoder==nil)
    {
         geoCoder=[[CLGeocoder alloc]init];
    }
   
    CLLocation * myloc=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geoCoder reverseGeocodeLocation:myloc completionHandler:
     ^(NSArray *placemarks, NSError *error)
    {
         
         //Get nearby address
         if (error==nil)
         {
             if(placemarks && placemarks.count > 0)
             {
                 CLPlacemark *placemark= [placemarks objectAtIndex:0];
                 //address is NSString variable that declare in .h file.
               
//                 NSString * address = [NSString stringWithFormat:@"%@ , %@ , %@ ,%@",[placemark thoroughfare],[placemark locality],[placemark administrativeArea],[placemark country]];
                 
                 NSString * address = [NSString stringWithFormat:@"%@",[placemark locality]];
                 
                 NSLog(@"New Address Is:%@",placemark.region);
                 //String to hold address
                 //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 
                 sucess(address);
                 //Print the location to console
                 NSLog(@"I am currently at %@",address);

             }
             
                }
         else
         {
             NSLog(@"I am currently at %@",error.description);
             [[ServerManager getSharedInstance]hideHud];
         }
         
         
     }];
}

-(void)getLocationFromAddressString: (NSString*) addressStr Success:(void(^)(CLLocationCoordinate2D center))sucess
 {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result)
    {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
   
     sucess(center);
     
}

@end
