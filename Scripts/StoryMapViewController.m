//
//  StoryMapViewController.m
//  Scripts
//
//  Created by Maijid Moujaled on 9/21/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "StoryMapViewController.h"

@interface StoryMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@end

@implementation StoryMapViewController

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
    self.locationArray = [[NSMutableArray alloc] init];
    self.mapAnnotations = [[NSMutableArray alloc] init]; 
    
	// Do any additional setup after loading the view.
    NSLog(@"se on map: %@", self.storyEntries);
    
    
    
    for ( PFObject *storyEntry in self.storyEntries) {
        PFGeoPoint *geoPoint = [storyEntry objectForKey:@"location"];
        NSLog(@"geoPoint: %@", geoPoint);
        
        if (geoPoint) {
        
            CLLocationCoordinate2D location;
            location.latitude = geoPoint.latitude;
            location.longitude = geoPoint.longitude;
            
            [self.locationArray addObject:geoPoint];
            
            //Create an annotation for location objecct
            //            MKPointAnnotation *sourceAnnotation = [MKPointAnnotation new];
            //            sourceAnnotation.coordinate = startLocation;
            //            sourceAnnotation.title = @"Lea";
            //            sourceAnnotation.subtitle = @"Loving the life!";
            
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate  = location;
            annotation.title = [[storyEntry objectForKey:@"user"] username];
            [self.mapAnnotations addObject:annotation];

        }
    }
    NSLog(@"map ann: %@", self.mapAnnotations); 
    CLLocationCoordinate2D allLocations[ self.locationArray.count ];
    
    MKMapPoint points[self.locationArray.count];

    int i = 0;
    for (PFGeoPoint *geoPoint in self.locationArray)
    {
        CLLocationCoordinate2D location;
        location.latitude = geoPoint.latitude;
        location.longitude = geoPoint.longitude;
        allLocations[i++] = location;
        points[i++] = MKMapPointForCoordinate(location);
    }
    MKGeodesicPolyline *polyline = [MKGeodesicPolyline polylineWithCoordinates:allLocations count:self.locationArray.count];

    [self.mapView addAnnotations:self.mapAnnotations];
    if (self.locationArray.count > 1) {
        [self.mapView addOverlay:polyline level:MKOverlayLevelAboveRoads];
    }
    
//    MKCoordinateRegion boundingRegion = CoordinateRegionBoundingMapPoints(points, self.locationArray.count);

    /*
    boundingRegion.span.latitudeDelta *= 1.1f;
    boundingRegion.span.longitudeDelta *= 1.1f;
    [self.mapView setRegion:boundingRegion animated:YES];
*/
    
    /*
    CLLocationCoordinate2D coords[3] = {startLocation, endLocation, otherLocation};
    MKGeodesicPolyline *polyline = [MKGeodesicPolyline polylineWithCoordinates:coords count:3];
    */
    
    /*
    
    //Get a bunch of coordinates!!!
    //Create two coordinates.
    CLLocationCoordinate2D startLocation;
    startLocation.latitude = 39.281516;
    startLocation.longitude= 76.580806;
    
    CLLocationCoordinate2D endLocation;
    endLocation.latitude = 41.281516;
    endLocation.longitude= 92.580806;
    
    //------
    CLLocationCoordinate2D otherLocation;
    otherLocation.latitude = 60.281516;
    otherLocation.longitude= 76.580806;
    
    
    //Create annoations for all those coordinateSS!!!

    MKPointAnnotation *sourceAnnotation = [MKPointAnnotation new];
    sourceAnnotation.coordinate = startLocation;
    sourceAnnotation.title = @"Lea";
    sourceAnnotation.subtitle = @"Loving the life!";
    
    MKPointAnnotation *destinationAnnotation = [MKPointAnnotation new];
    destinationAnnotation.coordinate = endLocation;
    destinationAnnotation.title = @"Daniel";
    destinationAnnotation.subtitle = @"Notes on storytelling.";
    
    
    MKPointAnnotation *otherAnnotation = [MKPointAnnotation new];
    otherAnnotation.coordinate = otherLocation;
    otherAnnotation.title = @"Maijid";
    otherAnnotation.subtitle = @"I dunno.. whatever.";
    
    CLLocationCoordinate2D coords[3] = {startLocation, endLocation, otherLocation};
    MKGeodesicPolyline *polyline = [MKGeodesicPolyline polylineWithCoordinates:coords count:3];
    
    */
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc]
                                        initWithPolyline:(MKPolyline*)overlay];
        
        /*
         if (overlay == _route.flyPartPolyline) {
         renderer.strokeColor = [UIColor redColor];
         } else {
         renderer.strokeColor = [UIColor blueColor];
         }
         */
        renderer.strokeColor = [UIColor colorWithRed:1.000 green:0.522 blue:0.525 alpha:1.000];
        return renderer;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"Annotation class: %@", [annotation class]);
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *identifier = @"StoryRoute";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView
                                                                      dequeueReusableAnnotationViewWithIdentifier:identifier];
        // if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = NO;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" equalTo:annotation.title];
         NSArray *users = [userQuery findObjects];
        PFUser *user = users.firstObject;
        NSLog(@"user: %@", users);
        
        NSLog(@"an t: %@", annotation.title);
        
        PFFile *imageFile = [user objectForKey:@"image"];
//        self.profileImageView.file = imageFile;
//        [self.profileImageView loadInBackground];
//        

        
        
        /*
        UIImage *image = nil;
        if ([annotation.title isEqualToString:@"Lea"]) {
            image = [UIImage imageNamed:@"lea.jpg"];
        } else {
            image = [UIImage imageNamed:@"trigang.jpg"];
        }
        */
        
        PFImageView *imageView = [[PFImageView alloc] init];
        imageView.file = imageFile;
        [imageView loadInBackground];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, 35, 35);
        annotationView.leftCalloutAccessoryView = imageView;
        
        
        // UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //[rightButton addTarget:self action:@selector(showLocationDetails:)forControlEvents:UIControlEventTouchUpInside];
        //            annotationView.rightCalloutAccessoryView = rightButton;
        /*
         } else {
         annotationView.annotation = annotation;
         }
         */
        UIButton *button = (UIButton *)annotationView.rightCalloutAccessoryView;
        //button.tag = [locations indexOfObject:(Location *)annotation];
        return annotationView;
    }
    return nil;
}
@end
