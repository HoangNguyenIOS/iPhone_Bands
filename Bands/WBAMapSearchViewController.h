//
//  WBAMapSearchViewController.h
//  Bands
//
//  Created by Thomas Chen on 6/23/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WBAWebViewController.h"

typedef enum {
    WBAMapViewActionButtonIndexMapType,
    WBAMapViewActionButtonIndexSatelliteType,
    WBAMapViewActionButtonIndexHybridType,
} WBAMapViewActionButtonIndex;

@interface WBAMapSearchViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKUserLocation *userLocation;
@property (nonatomic, strong) NSMutableArray *searchResultMapItems;

- (IBAction)actionButtonTouched:(id)sender;

- (void) searchForRecordStores;

@end
