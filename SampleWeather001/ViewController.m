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
{

    NSInteger trailingSpace;

}

@end

@implementation ViewController

@synthesize dayTempArray;
@synthesize locationManager;
@synthesize textDataLat,textDataLon;
@synthesize expandedGuideFrame,collapsedGuideFrame,showAddView;
@synthesize myTempScreenView,addLocationView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    showAddView = NO;
    
    expandedGuideFrame = CGRectMake(myTempScreenView.frame.size.width-87, myTempScreenView.frame.size.height/2-53, 87, 66);
    collapsedGuideFrame = CGRectMake(myTempScreenView.frame.size.width-20, myTempScreenView.frame.size.height/2-53, 25, 66);
    
    [addLocationView setFrame:collapsedGuideFrame];

    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    Lat = self.locationManager.location.coordinate.latitude;
    Long = self.locationManager.location.coordinate.longitude;
    
    NSLog(@"Lat : %f  Long : %f",Lat,Long);
    
}

- (IBAction)expandGuideViewAction:(id)sender {
    
    showAddView =!showAddView;
    _swipeViewTrailingConstraint.constant = showAddView?trailingSpace-60:trailingSpace;

}

-(void)openAlertView:(id)sender
{
    
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Add Location"
                               message:@""
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
    {
         showAddView =!showAddView;
        _swipeViewTrailingConstraint.constant = showAddView?trailingSpace-60:trailingSpace;

        addedLocation = alert.textFields[0];
        NSLog(@"text was %@", addedLocation.text);
        [self getLocationFromAddressString:addedLocation.text];
        
    }];
   
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSLog(@"cancel btn");
        [alert dismissViewControllerAnimated:YES completion:nil];
        
        showAddView =!showAddView;
        _swipeViewTrailingConstraint.constant = showAddView?trailingSpace-60:trailingSpace;


    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Please Enter Location";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    [self presentViewController:alert animated:YES completion:nil];


}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    Lat = center.latitude;
    Long = center.longitude;
    [ self passLatandLong];
    return center;
    
    
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
    
    NSLog(@"New Lat value: %f", Lat);
    NSLog(@"New lon value: %f", Long);
    
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
