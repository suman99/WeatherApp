//
//  WeatherService.m
//  SampleWeather001
//
//  Created by Suman on 08/03/17.
//  Copyright © 2017 Suman. All rights reserved.
//

#import "WeatherService.h"

@implementation WeatherService

- (void)getWeeklyWeather:(float)latitude longitude:(float)longitude completionBlock:(void (^)(NSArray *,NSString *))completionBlock {
    
//    NSString *dataUrl = @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=17.4401&lon=78.3489&cnt=7&APPID=d2addfc115414f2b39b468d5594a9115";
    
     NSString *dataUrl =[NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&APPID=d2addfc115414f2b39b468d5594a9115",latitude,longitude ];
    
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              NSError *errorJson=nil;
                                              NSDictionary* weatherData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                                              
                                              NSString* tempStr1 = weatherData[@"city"][@"name"];
                                              NSString* tempStr2 = weatherData[@"city"][@"country"];
                                              NSString* locationStr = [tempStr1 stringByAppendingString:@","];
                                              
                                              locationStr = [locationStr stringByAppendingString:tempStr2];
                                              
                                              NSLog(@"responseDict=%@",weatherData);
                                              
                                              NSMutableArray *weeklyWeather = [[NSMutableArray alloc] init];
                                              
                                              for(NSDictionary* weather in weatherData[@"list"]) {
                                                  Weather* day = [[Weather alloc] initWithDictionary:weather isCurrentWeather:false];
                                                  [weeklyWeather addObject:day];
                                              }
                                              
                                              completionBlock(weeklyWeather,locationStr);
                                          }];
    
    [downloadTask resume];
}

@end
