//
//  ViewController.h
//  SampleWeather001
//
//  Created by Suman on 07/03/17.
//  Copyright © 2017 Suman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyForecastBlock.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<PassData,CLLocationManagerDelegate>
{
    float Lat;
    float Long;
}
@property(strong,nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray* dayTempArray;

@property(weak,nonatomic)NSString * textDataLat;
@property(weak,nonatomic)NSString * textDataLon;

@end

