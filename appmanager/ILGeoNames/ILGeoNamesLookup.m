//
//  ILGeoNamesLookup.m
//
//  Created by Claus Broch on 20/06/10.
//  Copyright 2010-2011 Infinite Loop. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted
//  provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice, this list of conditions 
//    and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice, this list of 
//    conditions and the following disclaimer in the documentation and/or other materials provided 
//    with the distribution.
//  - Neither the name of Infinite Loop nor the names of its contributors may be used to endorse or 
//    promote products derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR 
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY 
//  WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  

#import "ILGeoNamesLookup.h"
#import "LocationManager.h"
#if USE_TOUCHJSON_PARSER
# import "CJSONDeserializer.h"
#else
# import "JSONKit.h"
#endif

static NSString *kILGeoNamesFindNearbyURL = @"http://api.geonames.org/findNearbyJSON?lat=%.8f&lng=%.8f&style=FULL&username=%@";
static NSString *kILGeoNamesFindNearbyToponymsURL = @"http://api.geonames.org/findNearbyJSON?lat=%.8f&lng=%.8f&maxRows=%d&radius=%.3f&style=FULL&username=%@";
static NSString *kILGeoNamesFindNearbyWikipediaURL = @"http://api.geonames.org/findNearbyWikipediaJSON?lat=%.8f&lng=%.8f&maxRows=%d&radius=%.3f&style=FULL&username=%@&lang=%@";
static NSString *kILGeoNamesSearchURL = @"http://api.geonames.org/searchJSON?q=%@&maxRows=%d&startRow=%d&lang=%@&isNameRequired=true&style=FULL&username=%@";

NSString *const kILGeoNamesErrorDomain = @"org.geonames";

@interface ILGeoNamesLookup ()
{
    BOOL isSearch;
}

- (void)threadedRequestWithURLString:(NSString*)urlString;
- (void)sendRequestWithURLString:(NSString*)urlString;
- (void)downloadStarted;
- (void)parseEnded:(NSArray*)result;
- (void)parseError:(NSError*)error;

@property BOOL done;

@property (nonatomic, retain) NSURLConnection *dataConnection;
@property (nonatomic, retain) NSMutableData *dataBuffer;

@end


@implementation ILGeoNamesLookup

@synthesize userID;
@synthesize done;
@synthesize dataConnection;
@synthesize dataBuffer;
@synthesize delegate;

#pragma mark -
#pragma mark Data request handling

- (id)initWithUserID:(NSString*)aUserID {
	self = [super init];
	if(self) {
		userID = [aUserID copyWithZone:nil];
	}
	return self;
}

- (void)dealloc {
	[userID release];
	
	[super dealloc];
}

- (void)sendRequestWithURLString:(NSString*)urlString {
    // Detach a thread to perform the request
	[NSThread detachNewThreadSelector:@selector(threadedRequestWithURLString:) toTarget:self withObject:urlString];
}

- (void)threadedRequestWithURLString:(NSString*)urlString {
    NSAutoreleasePool *downloadPool = [[NSAutoreleasePool alloc] init];
	NSURLRequest	*request;
	
	// TODO - handle multiple outstanding requests

	@synchronized(self) {
		done = NO;
		self.dataBuffer = [NSMutableData data];
		// Create the request
		request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
								   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
							   timeoutInterval:60.0];
		// Create the connection with the request and start loading the data
		dataConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
	
	// Just sit spinning in the run loop until all is done
	if(self.dataConnection)
	{
		[self performSelectorOnMainThread:@selector(downloadStarted) withObject:nil waitUntilDone:NO];
        while (!done) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
        }
	}
	
    // Release resources used only in this thread.
	@synchronized(self) {
		self.dataBuffer = nil;
		self.dataConnection = nil;
	}

	[downloadPool release];
}

- (void)findNearbyPlaceNameForLatitude:(double)latitude longitude:(double)longitude {
	NSString	*urlString;
	
	// Request formatted according to http://www.geonames.org/export/web-services.html#findNearby
	urlString = [NSString stringWithFormat:kILGeoNamesFindNearbyURL, latitude, longitude, userID];
//    [self sendRequestWithURLString:urlString];
}

- (void)findNearbyToponymsForLatitude:(double)latitude longitude:(double)longitude maxRows:(NSInteger)maxRows radius:(double)radius {
	NSString	*urlString;
	
	// Request formatted according to http://www.geonames.org/export/web-services.html#findNearby
	urlString = [NSString stringWithFormat:kILGeoNamesFindNearbyToponymsURL, latitude, longitude, maxRows, radius, userID];
//    [self sendRequestWithURLString:urlString];
}

- (void)findNearbyWikipediaForLatitude:(double)latitude longitude:(double)longitude maxRows:(NSInteger)maxRows radius:(double)radius languageCode:(NSString *)languageCode {
	NSString	*urlString;
	
	if ((! languageCode) || [languageCode length] == 0) {
		languageCode = @"en";
	}
	
	// Request formatted according to http://www.geonames.org/export/wikipedia-webservice.html#findNearbyWikipedia
	urlString = [NSString stringWithFormat:kILGeoNamesFindNearbyWikipediaURL, latitude, longitude, maxRows, radius, userID, languageCode];
//    [self sendRequestWithURLString:urlString];
}

- (void)search:(NSString*)query maxRows:(NSInteger)maxRows startRow:(NSUInteger)startRow language:(NSString*)langCode
{
	NSString	*urlString;
	
	// Sanitize parameters
	if(!langCode) {
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		NSArray	*localizations = [bundle preferredLocalizations];
		if([localizations count])
			langCode = [localizations objectAtIndex:0];
		else
			langCode = @"en";
	}
	if(maxRows > 1000)
		maxRows = 1000;

    CLLocationCoordinate2D  loctCoord = [[LocationManager locationInstance]getcurrentLocation];

    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",loctCoord.latitude] forKey:@"City_LAT"];
   
      [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",loctCoord.longitude] forKey:@"City_LONG"];
    
//	// Request formatted according to http://www.geonames.org/export/geonames-search.html
	NSString *escQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([escQuery isEqualToString:@"Yes"])
    {
        isSearch=NO;
        urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=AJYEDMWZKIUULUZB0LTC1D1CZQM11IHIBIGPTS5FBRMPXSF4&client_secret=WDIDMXXOGM2N2ZYAV4DI5B0PDLGAQYH13M1ZEDGZBOJUXWMI&v=20130815&ll=%f,%f&llAcc=5000&categoryId=530e33ccbcbc57f1066bbff3&limit=50&radius=50000",loctCoord.latitude,loctCoord.longitude];
    }
    else
    {
//        urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=AJYEDMWZKIUULUZB0LTC1D1CZQM11IHIBIGPTS5FBRMPXSF4&client_secret=WDIDMXXOGM2N2ZYAV4DI5B0PDLGAQYH13M1ZEDGZBOJUXWMI&v=20130815&ll=%f,%f&llAcc=50000&categoryId=530e33ccbcbc57f1066bbff3&limit=5000&query=%@",loctCoord.latitude,loctCoord.longitude,escQuery];
        
        //used for search near by places
//        urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=AJYEDMWZKIUULUZB0LTC1D1CZQM11IHIBIGPTS5FBRMPXSF4&client_secret=WDIDMXXOGM2N2ZYAV4DI5B0PDLGAQYH13M1ZEDGZBOJUXWMI&v=20130815&ll=%f,%f&query=%@",loctCoord.latitude,loctCoord.longitude,escQuery];
        
        //used facebook api for search city adgeolocation&location_types=city& https://graph.facebook.com/search?q=%@&type=place&access_token=%@
        isSearch=YES;
        urlString = [NSString stringWithFormat:@"https://graph.facebook.com/search?q=%@&type=adgeolocation&location_types=city&access_token=%@",escQuery,[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"]];
        
        
        //used facebook api for near by search api
        //https://graph.facebook.com/search?q=ritual&type=place&center=37.76,-122.427&distance=1000&access_token=mytoken.
        
//        https://api.foursquare.com/v2/venues/search?client_id=AJYEDMWZKIUULUZB0LTC1D1CZQM11IHIBIGPTS5FBRMPXSF4&client_secret=WDIDMXXOGM2N2ZYAV4DI5B0PDLGAQYH13M1ZEDGZBOJUXWMI&v=20130815&ll=30.727617,76.846662&query=aroma
    }
    [self sendRequestWithURLString:urlString];
    

}

- (void)cancel
{
	@synchronized(self) {
		[self.dataConnection cancel];
		done = YES;
	}
}

#pragma mark -
#pragma mark Internal callback handling

- (void)downloadStarted
{
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
	
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(geoNamesLookup:networkIsActive:)]) 
        [self.delegate geoNamesLookup:self networkIsActive:YES];
}

- (void)parseEnded:(NSArray*)result
{
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
	
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(geoNamesLookup:networkIsActive:)]) {
        [self.delegate geoNamesLookup:self networkIsActive:NO];
	}
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(geoNamesLookup:didFindGeoNames:totalFound:)]) {
		
		
		NSUInteger total = [result count];
//			total = [[result count]  intValue];
		
        [self.delegate geoNamesLookup:self didFindGeoNames:result totalFound:total];
	}
}

- (void)parseError:(NSError*)error
{
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
	
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(geoNamesLookup:networkIsActive:)]) 
        [self.delegate geoNamesLookup:self networkIsActive:NO];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(geoNamesLookup:didFailWithError:)]) 
        [self.delegate geoNamesLookup:self didFailWithError:error];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate handling

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse 
{
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Store the downloaded chunk of data.
	@synchronized(self) {
		[self.dataBuffer appendData:data];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	done = YES;
	
    [self performSelectorOnMainThread:@selector(parseError:) withObject:error waitUntilDone:NO];
    //NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSDictionary	*resultDict;
	NSError			*error = nil;
	
    // Parse the data
	@synchronized(self) {
#if USE_TOUCHJSON_PARSER
		resultDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:dataBuffer error:&error];
#else
        resultDict = [dataBuffer objectFromJSONDataWithParseOptions:JKParseOptionValidFlags error:&error];
#endif
	}
	if(resultDict) {
        NSArray *geoNames;
        if (isSearch==NO)
        {
            geoNames = [[resultDict valueForKey:@"response"] valueForKey:@"venues"];
        }
        else{
            geoNames = [resultDict valueForKey:@"data"];
        }
		
		
		if (geoNames) {
			[self performSelectorOnMainThread:@selector(parseEnded:) withObject:geoNames waitUntilDone:NO];
		} 
		else {
			NSDictionary *status = [resultDict objectForKey:kILGeoNamesErrorResponseKey];
			if (status) {
				// Geonames failed to provide a result - return the status supplied in the response
				NSString	*message = [status objectForKey:kILGeoNamesErrorMessageKey];
				NSString	*value = [status objectForKey:kILGeoNamesErrorCodeKey];
				NSError		*error = [NSError errorWithDomain:kILGeoNamesErrorDomain 
													  code:[value intValue]
												  userInfo:[NSDictionary dictionaryWithObject:message 
																					   forKey:NSLocalizedDescriptionKey]];
				[self performSelectorOnMainThread:@selector(parseError:) withObject:error waitUntilDone:NO];
			}
			else {
				// Geonames just failed on us - use a default error code
				NSString	*message = NSLocalizedStringFromTable(@"ILGEONAMES_UNKNOWN_LOOKUP_ERR", @"ILGeoNames", @"");
				NSError		*error = [NSError errorWithDomain:kILGeoNamesErrorDomain 
													  code:kILGeoNamesNoResultsFoundError
												  userInfo:[NSDictionary dictionaryWithObject:message
																					   forKey:NSLocalizedDescriptionKey]];
				[self performSelectorOnMainThread:@selector(parseError:) withObject:error waitUntilDone:NO];
			}
		}
		
	}
	else
	{
		[self performSelectorOnMainThread:@selector(parseError:) withObject:error waitUntilDone:NO];
	}
	
		
    // Set the condition which ends the run loop.
	@synchronized (self) {
		done = YES; 
	}
}

@end


NSString *const kILGeoNamesResultsKey = @"geonames";
NSString *const kILGeoNamesTotalResultsCountKey = @"totalResultsCount";

NSString *const kILGeoNamesAdminCode1Key = @"adminCode1";
NSString *const kILGeoNamesAdminCode2Key = @"adminCode2";
NSString *const kILGeoNamesAdminCode3Key = @"adminCode3";
NSString *const kILGeoNamesAdminName1Key = @"adminName1";
NSString *const kILGeoNamesAdminName2Key = @"adminName2";
NSString *const kILGeoNamesAdminName3Key = @"adminName3";
NSString *const kILGeoNamesAdminName4Key = @"adminName4";
NSString *const kILGeoNamesNameKey = @"name";
NSString *const kILGeoNamesToponymNameKey = @"toponymName";
NSString *const kILGeoNamesContinentCodeKey = @"continentCode";
NSString *const kILGeoNamesCountryCodeKey = @"countryCode";
NSString *const kILGeoNamesCountryNameKey = @"countryName";
NSString *const kILGeoNamesPopulationKey = @"population";
NSString *const kILGeoNamesTitleKey = @"title";
NSString *const kILGeoNamesSummaryKey = @"summary";
NSString *const kILGeoNamesWikipediaURLKey = @"wikipediaUrl";

NSString *const kILGeoNamesAlternateNamesKey = @"alternameNames";
NSString *const kILGeoNamesAlternateNameKey = @"name";
NSString *const kILGeoNamesAlternateLanguageKey = @"lang";

NSString *const kILGeoNamesIDKey = @"geonameId";
NSString *const kILGeoNamesFeatureKey = @"feature";
NSString *const kILGeoNamesFeatureClassKey = @"fcl";
NSString *const kILGeoNamesFeatureCodeKey = @"fcode";
NSString *const kILGeoNamesFeatureClassNameKey = @"fclName";
NSString *const kILGeoNamesFeatureNameKey = @"fcodeName";
NSString *const kILGeoNamesScoreKey = @"score";

NSString *const kILGeoNamesLatitudeKey = @"lat";
NSString *const kILGeoNamesLongitudeKey = @"lng";
NSString *const kILGeoNamesDistanceKey = @"distance";
NSString *const kILGeoNamesElevationKey = @"elevation";
NSString *const kILGeoNamesLanguageKey = @"lang";
NSString *const kILGeoNamesRankKey = @"rank";

NSString *const kILGeoNamesTimeZoneInfoKey = @"timezone";
NSString *const kILGeoNamesTimeZoneDSTOffsetKey = @"dstOffset";
NSString *const kILGeoNamesTimeZoneGMTOffsetKey = @"gmtOffset";
NSString *const kILGeoNamesTimeZoneIDKey = @"timeZoneId";

NSString *const kILGeoNamesErrorResponseKey = @"status";
NSString *const kILGeoNamesErrorMessageKey = @"message";
NSString *const kILGeoNamesErrorCodeKey = @"value";
