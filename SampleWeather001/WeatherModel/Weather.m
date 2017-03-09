//
//  Weather.m
//  SampleWeather001
//
//  Created by Suman on 08/03/17.
//  Copyright © 2017 Suman. All rights reserved.
//

#import "Weather.h"

@implementation Weather


- (instancetype)initWithDictionary:(NSDictionary *)dictionary isCurrentWeather:(BOOL)isCurrentWeather{
    self = [super init];
    
    if (self) {
        /*
         * Take the weather data from the API and parse it into this
         * weather object. Error check each field as there is no
         * guarantee that the same data will be available for every
         * location.
         */
        
        _dateOfForecast = [self utcToLocalTime:[NSDate dateWithTimeIntervalSince1970:[dictionary[@"dt"] doubleValue]]];
        
        // the current weather JSON and the weekly JSON are formatted
        // slightly differnt. We need to parse it differnetly based
        // on that format
        if(isCurrentWeather) {
            int temperatureMin = [dictionary[@"main"][@"temp_min"] intValue];
            if(temperatureMin) {
                _temperatureMin = temperatureMin-273.15;
            }
            
            int temperatureMax = [dictionary[@"main"][@"temp_max"] intValue];
            if(temperatureMax) {
                _temperatureMax = temperatureMax-273.15;
            }
            
            int humidity = [dictionary[@"main"][@"humidity"] intValue];
            if(humidity) {
                _humidity = humidity;
            }
            
            float windSpeed = [dictionary[@"wind"][@"speed"] floatValue];
            if(windSpeed) {
                _windSpeed = windSpeed;
            }
        }
        else {
            int temperatureMin = [dictionary[@"temp"][@"min"] intValue];
            if(temperatureMin) {
                _temperatureMin = temperatureMin-273.15;
            }
            
            int temperatureMax = [dictionary[@"temp"][@"max"] intValue];
            if(temperatureMax) {
                _temperatureMax = temperatureMax-273.15;
            }
            
            
            int temperatureDay = [dictionary[@"temp"][@"day"] intValue];
            if(temperatureDay) {
                _temperatureDay = temperatureDay-273.15;
            }
            
            int humidity = [dictionary[@"humidity"] intValue];
            if(humidity) {
                _humidity = humidity;
            }
            
            float windSpeed = [dictionary[@"speed"] floatValue];
            if(windSpeed) {
                _windSpeed = windSpeed;
            }
            
            
        }
        
        /*
         * weather section of the response is an array of dictionary objects.
         * the first object in the array contains the desired weather information.
         * this JSON is formatted the same for both requests.
         */
        NSArray* weather = dictionary[@"weather"];
        if([weather count] > 0) {
            NSDictionary* weatherData = [weather objectAtIndex:0];
            if(weatherData) {
                NSString *status = weatherData[@"main"];
                if(status) {
                    _status = status;
                }
                
                int statusID = [weatherData[@"id"] intValue];
                if(statusID) {
                    _statusID = statusID;
                }
                
                NSString *condition = weatherData[@"description"];
                if(condition) {
                    _condition = condition;
                }
            }
        }
        
    }
    
    return self;
}

- (UIImage*)getWeatherImageForCurrentCondition {
    if(self.statusID >=200 && self.statusID <= 232) {
        return[UIImage imageNamed:@"thunder.png"];
    }
    else if(self.statusID >=300 && self.statusID <= 321) {
        return [UIImage imageNamed:@"rain.png"];
    }
    else if(self.statusID >=500 && self.statusID <= 531) {
        return [UIImage imageNamed:@"pour.png"];
    }
    else if(self.statusID >=801 && self.statusID <= 804) {
        return [UIImage imageNamed:@"cloudy.png"];
    }
    else {
        return [UIImage imageNamed:@"sunny.png"];
    }
}

/**
 *  Takes a unix UTC timestamp and converts it to
 *  an NSDate formatted in the device's local timezone
 *
 *  @param date Date to be converted
 *
 *  @return Converted date
 */
-(NSDate *)utcToLocalTime:(NSDate*)date {
    NSTimeZone *currentTimeZone = [NSTimeZone defaultTimeZone];
    NSInteger secondsOffset = [currentTimeZone secondsFromGMTForDate:date];
    return [NSDate dateWithTimeInterval:secondsOffset sinceDate:date];
}

@end
