//
//  PlaceMark.m
//  MapViewExample
//
//  Created by Pavan Kumar on 08/09/14.
//  Copyright (c) 2014 Pavan Kumar. All rights reserved.
//

#import "PlaceMark.h"

@implementation PlaceMark

@synthesize lTitle;
@synthesize lSubTitle;
@synthesize coordinate;

-(NSString *)title
{
	return lTitle;
}
-(NSString *)subtitle
{
	return lSubTitle;
}
-(id)initWithCoordinates:(CLLocationCoordinate2D)kCoordinates
{
	coordinate = kCoordinates;
	return self;
}

@end
