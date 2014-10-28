//
//  WBAMapSearchViewController.m
//  Bands
//
//  Created by Thomas Chen on 6/23/14.
//
//

#import "WBAMapSearchViewController.h"

@interface WBAMapSearchViewController ()

@end

@implementation WBAMapSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchResultMapItems = [NSMutableArray array];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (! [CLLocationManager locationServicesEnabled]) {
        UIAlertView *noLocationServicesAlert = [[UIAlertView alloc] initWithTitle:@"The Find Local Record Stores feature is not available" message:@"Location Services are not enabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noLocationServicesAlert show];
    }
    else {
        self.mapView.showsUserLocation = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) mapView: (MKMapView *) mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.userLocation = userLocation;
    
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.3f;
    coordinateSpan.longitudeDelta = 0.3f;
    
    MKCoordinateRegion regionToShow;
    regionToShow.center = userLocation.coordinate;
    regionToShow.span = coordinateSpan;
    
    [self.mapView setRegion:regionToShow animated:YES];
    //[self searchForRecordStores];
}

- (void) mapView: (MKMapView *) mapView regionDidChangeAnimated:(BOOL)animated
{
    [self searchForRecordStores];
}

- (IBAction)actionButtonTouched:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Map View", @"Satellite View", @"Hybrid View", nil];
    [actionSheet showInView:self.view];
}

- (void) actionSheet: (UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == WBAMapViewActionButtonIndexMapType) {
        self.mapView.mapType = MKMapTypeStandard;
    }
    else if (buttonIndex == WBAMapViewActionButtonIndexSatelliteType) {
        self.mapView.mapType = MKMapTypeSatellite;
    }
    else if (buttonIndex == WBAMapViewActionButtonIndexHybridType) {
        self.mapView.mapType = MKMapTypeHybrid;
    }
}

- (void) searchForRecordStores
{
    if (! self.userLocation) return;
    
    MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init];
    
    localSearchRequest.naturalLanguageQuery = @"Record Store";
    localSearchRequest.region = self.mapView.region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:localSearchRequest];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [localSearch startWithCompletionHandler:
     ^(MKLocalSearchResponse *response, NSError *error)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         
         if (error) {
             //NSLog(@"An error occured while performing the local search");
             UIAlertView *mapErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [mapErrorAlert show];
         }
         else {
             //NSLog(@"The local search found %d record stores", [response.mapItems count]);
             
             NSMutableArray *searchAnnotations = [NSMutableArray array];
             for (MKMapItem *mapItem in response.mapItems) {
                 if (! [self.searchResultMapItems containsObject:mapItem])
                 {
                     [self.searchResultMapItems addObject:mapItem];
                     
                     MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                     point.coordinate = mapItem.placemark.coordinate;
                     point.title = mapItem.name;
                     
                     if (mapItem.url) {
                         point.subtitle = mapItem.url.absoluteString;
                     }
                     
                     [searchAnnotations addObject:point];
                 }
             }
             
             [self.mapView addAnnotations:searchAnnotations];
         }
     }];
}

- (MKAnnotationView *)mapView: (MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.userLocation) return nil;
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"pinAnnotationView"];
    
    if (pinAnnotationView) {
        pinAnnotationView.annotation = annotation;
    }
    else {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinAnnotationView"
                             ];
        pinAnnotationView.canShowCallout = YES;
        pinAnnotationView.animatesDrop = YES;
    }
    
    if (((MKPointAnnotation *) annotation).subtitle) {
        pinAnnotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else {
        pinAnnotationView.leftCalloutAccessoryView = nil;
    }
    
    return pinAnnotationView;
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"recordStoreWebSearchSegue" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MKAnnotationView *annotationView = sender;
    MKPointAnnotation *pointAnnotation = (MKPointAnnotation *)annotationView.annotation;
    WBAWebViewController *webViewController = (WBAWebViewController *)segue.destinationViewController;
    webViewController.recordStoreUrlString = pointAnnotation.subtitle;
}

@end
