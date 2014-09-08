//
//  MapViewExampleViewController.m
//  MapViewExample
//
//  Created by Pavan Kumar on 07/09/14.
//  Copyright (c) 2014 Pavan Kumar. All rights reserved.
//

#import "MapViewExampleViewController.h"
#import "PlaceMark.h"


@interface MapViewExampleViewController ()

@end

@implementation MapViewExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Add Map To SubView
    [self.view addSubview:self.mapView];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    // Plot all points on map
    [self plotPointsonMap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter Methods

-(MKMapView *)mapView{
    
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 10, 320, 400)];
        _mapView.delegate = self;
        
    }
    
    return _mapView;
}

-(NSMutableArray *)geoCodes{
    if (_geoCodes == nil) {
        _geoCodes = [NSMutableArray new];
        
        NSMutableArray *stringsArray = [NSMutableArray new];
        
        [stringsArray addObject:@"41.3755722, -73.4533779"];
        [stringsArray addObject:@"44.3755722, -71.4733345"];
        [stringsArray addObject:@"46.3755722, -72.4533779"];
        [stringsArray addObject:@"41.3755722, -74.4533779"];
        [stringsArray addObject:@"41.3755722, -75.4533779"];
        [stringsArray addObject:@"41.3755722, -76.4533779"];
        [stringsArray addObject:@"41.3755722, -77.4533779"];
        [stringsArray addObject:@"41.3755722, -78.4533779"];
        [stringsArray addObject:@"41.3755722, -79.4533779"];
        [stringsArray addObject:@"41.3755722, -80.4533779"];
        [stringsArray addObject:@"41.3755722, -81.4533779"];
        
        // For loop to store some dummy data in form of PlaceMark objects
        
        for (int i = 0; i < stringsArray.count; i++) {
            
            NSString *geoCodeString = [stringsArray objectAtIndex:i];
            
            NSArray *geocodes = [geoCodeString componentsSeparatedByString:@","];
            
            
            // Store only if geocode count is 2
            if (geocodes.count == 2) {
                
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[geocodes objectAtIndex:0]doubleValue],[[geocodes objectAtIndex:1]doubleValue]);
                if (CLLocationCoordinate2DIsValid(coordinate)) {
                    
                    PlaceMark *objPlaceMark = [[PlaceMark alloc] initWithCoordinates:coordinate];
                    objPlaceMark.lTitle = [NSString stringWithFormat:@"Name - %d",i];
                    objPlaceMark.lSubTitle = [NSString stringWithFormat:@"Big Description - %d",i];
                } // End of inner if
                
            } // End of outer if
            
        } // End of for loop
        
    } // End of main if
    
    return _geoCodes;
}

#pragma mark - Helpers

-(void)plotPointsonMap{
    
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    BOOL hasUserLocation = YES;
    CLLocationCoordinate2D userCoordinates = CLLocationCoordinate2DMake(17.3432, 78.242525);
    NSUInteger loopcount = (hasUserLocation)?(self.geoCodes.count+1):self.geoCodes.count;
    
    for(int i = 0 ; i < loopcount; i++)
    {
        if (i == [self.geoCodes count]) {
            if (hasUserLocation) {//Current Location
                if(CLLocationCoordinate2DIsValid(userCoordinates)){
                    PlaceMark *objPlaceMark = [[PlaceMark alloc] initWithCoordinates:userCoordinates];
                    objPlaceMark.lTitle = @"User Location";
                    objPlaceMark.lSubTitle = @"Current Location description";
                    objPlaceMark.isUserLocation = YES;
                }
            }
        }
        else{
            
            PlaceMark *currentPlaceMark = [self.geoCodes objectAtIndex:i];
            
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, currentPlaceMark.coordinate.longitude);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, currentPlaceMark.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, currentPlaceMark.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, currentPlaceMark.coordinate.latitude);
            
            [self.mapView addAnnotation:currentPlaceMark];

        
        }
    }
    
    
    // Center the map
    MKCoordinateRegion region;
    @try {
        
        
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3;
        
        // Add a little extra space on the sides
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.3;
    }
    @catch (NSException * e) {
        NSLog(@"Exception for map view region is: %@", e);
    }
    
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}




#pragma mark - MAP View Delegate
- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation{
    NSString *annotationIdentifier = @"businessLocation";
    
    if ([annotation isKindOfClass:[PlaceMark class]]) {
        PlaceMark *objPlaceMark = (PlaceMark *)annotation;
        if (objPlaceMark.isUserLocation) {
            annotationIdentifier = @"userlocation";
            
            MKPinAnnotationView *annotationView = [[MKPinAnnotationView  alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.pinColor = MKPinAnnotationColorGreen;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
            
            return annotationView;
        }
        else{
            MKPinAnnotationView *annotationView = [[MKPinAnnotationView  alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.pinColor = MKPinAnnotationColorPurple;
            annotationView.canShowCallout = YES;
            
            return annotationView;
        }
    }
    return nil;
}

@end
