//
//  Weather.h
//  SampleWeather001
//
//  Created by Suman on 08/03/17.
//  Copyright © 2017 Suman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Weather : NSObject

@property (nonatomic, strong) NSDate *dateOfForecast;

@property (nonatomic, strong) NSString* status;

@property (nonatomic) int statusID;

@property (nonatomic, strong) NSString* condition;

@property (nonatomic) int temperatureMin;
@property (nonatomic) int temperatureMax;
@property (nonatomic) int temperatureDay;

@property (nonatomic) int humidity;

@property (nonatomic) float windSpeed;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary isCurrentWeather:(BOOL)isCurrentWeather;

- (UIImage*)getWeatherImageForCurrentCondition;

@end
