//
//  ViewController.m
//  SampleWeather001
//
//  Created by Suman on 07/03/17.
//  Copyright © 2017 Suman. All rights reserved.
//

#import "ViewController.h"
#import "WeatherService.h"
#import "DailyForecastBlock.h"
#import "Weather.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *weeklyForecastScollview;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollviewHeightConstraint;

@property (nonatomic, weak) IBOutlet UILabel *locationName;
@property (nonatomic, weak) IBOutlet UILabel *weekDayName;

@property (nonatomic, weak) IBOutlet UILabel *temp;

@property (nonatomic, weak) IBOutlet UILabel *condition;
@property (nonatomic, weak) IBOutlet UIImageView *icon;

@end

@implementation ViewController

@synthesize dayTempArray;
@synthesize locationManager;
@synthesize textDataLat,textDataLon;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.

    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    Lat = self.locationManager.location.coordinate.latitude;
    Long = self.locationManager.location.coordinate.longitude;
//
    NSLog(@"Lat : %f  Long : %f",Lat,Long);
    
}

- (void)passDataToFirst:(int)selValue{
    NSLog(@"Suman123123::%d",selValue);
    Weather* day = [dayTempArray objectAtIndex:selValue];
    self.temp.text = [NSString stringWithFormat:@"%d°", day.temperatureDay];
    self.condition.text = [day.condition uppercaseString];
    self.icon.image = [day getWeatherImageForCurrentCondition];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    self.weekDayName.text = [[dateFormatter stringFromDate:day.dateOfForecast] uppercaseString];
}

- (void)viewWillLayoutSubviews {
    [self.weeklyForecastScollview setContentSize:CGSizeMake(100 * 7, CGRectGetHeight(self.weeklyForecastScollview.frame))];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        textDataLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        textDataLon = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        Lat = [textDataLat floatValue];
        Long = [textDataLon floatValue];
        NSLog(@"New Loc value: %@", newLocation);
        NSLog(@"Old Loc value: %@", oldLocation);
       
        NSLog(@"New Lat value: %f", Lat);
        NSLog(@"New lon value: %f", Long);
        
        CLLocationDistance distance = [currentLocation distanceFromLocation:oldLocation];
        NSString *miles =[NSString stringWithFormat:@"%.1fmi",(distance/1609.344)];
        float milesvalue = [miles floatValue];

        NSLog(@"Calculated Miles %f", milesvalue);


        
        if (Lat && Long == 0.000000)
        {
            [self passLatandLong];
        }
        else if(milesvalue >6.2)
        {
            [self passLatandLong];

        }
            else
        {
            static dispatch_once_t once;
            dispatch_once(&once, ^ {
                [self passLatandLong];
            });
        }
    }
    
}

-(void)passLatandLong
{
    
    WeatherService *weatherService = [[WeatherService alloc] init];
    [weatherService getWeeklyWeather:Lat longitude:Long completionBlock:^(NSArray * weatherData,NSString* locInfo) {
        dayTempArray = weatherData;
        dispatch_async(dispatch_get_main_queue(), ^{
            float count = 0.0;
            
            for (Weather* day in weatherData) {
                DailyForecastBlock *block = [[DailyForecastBlock alloc] initWithFrame:CGRectMake(100 * count, 0, 100, self.scrollviewHeightConstraint.constant)];
                block.delegate = self;
                self.locationName.text = locInfo;
                
                if([[NSCalendar currentCalendar] isDateInToday:day.dateOfForecast]) {
                    [block configureTodaysBlock:day];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"EEEE"];
                    self.weekDayName.text = [[dateFormatter stringFromDate:day.dateOfForecast] uppercaseString];
                    self.temp.text = [NSString stringWithFormat:@"%d°", day.temperatureDay];
                    self.condition.text = [day.condition uppercaseString];
                    self.icon.image = [day getWeatherImageForCurrentCondition];
                }
                else {
                    [block configureBlock:day index:count];
                }
                [self.weeklyForecastScollview addSubview:block];
                
                count++;
            }
        });
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
