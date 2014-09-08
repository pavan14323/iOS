//
//  PlaceMark.h
//  MapViewExample
//
//  Created by Pavan Kumar on 08/09/14.
//  Copyright (c) 2014 Pavan Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Place;


@interface PlaceMark : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property(nonatomic ,retain)NSString *lTitle;
@property(nonatomic ,retain)NSString *lSubTitle;
@property(nonatomic)BOOL isUserLocation;
@property(nonatomic)BOOL showRightCallout;


-(id)initWithCoordinates:(CLLocationCoordinate2D)kCoordinates;


@end
