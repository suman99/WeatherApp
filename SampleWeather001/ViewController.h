//
//  ViewController.h
//  SampleWeather001
//
//  Created by Suman on 07/03/17.
//  Copyright © 2017 Suman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DailyForecastBlock.h"

@interface ViewController : UIViewController<PassData,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    float Lat;
    float Long;
    UITextField *addedLocation;
    CLLocationCoordinate2D center;
    UIAlertController *alert;
}


@property(strong,nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray* dayTempArray;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollviewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *swipeViewTrailingConstraint;

@property(weak,nonatomic)NSString * textDataLat;
@property(weak,nonatomic)NSString * textDataLon;

@property (strong, nonatomic) IBOutlet UIView *myTempScreenView;
@property (strong, nonatomic) IBOutlet UIView *addLocationView;

@property bool showAddView;
@property CGRect expandedGuideFrame;
@property CGRect collapsedGuideFrame;
@property (nonatomic, weak) IBOutlet UIScrollView *weeklyForecastScollview;

@property (nonatomic, weak) IBOutlet UILabel *locationName;
@property (nonatomic, weak) IBOutlet UILabel *weekDayName;

@property (nonatomic, weak) IBOutlet UILabel *temp;

@property (nonatomic, weak) IBOutlet UILabel *condition;
@property (nonatomic, weak) IBOutlet UIImageView *icon;

- (IBAction)expandGuideViewAction:(id)sender;
- (IBAction)openAlertView:(id)sender;

@end

