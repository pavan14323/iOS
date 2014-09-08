//
//  MapViewExampleViewController.h
//  MapViewExample
//
//  Created by Pavan Kumar on 07/09/14.
//  Copyright (c) 2014 Pavan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewExampleViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic,retain)MKMapView *mapView;

@property(nonatomic,retain)NSMutableArray *geoCodes;

@end
