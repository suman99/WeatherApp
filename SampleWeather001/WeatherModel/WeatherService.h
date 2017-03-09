//
//  WeatherService.h
//  SampleWeather001
//
//  Created by Suman on 08/03/17.
//  Copyright © 2017 Suman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"


@interface WeatherService : NSObject


- (void)getWeeklyWeather:(float)latitude longitude:(float)longitude completionBlock:(void (^)(NSArray *,NSString *))completionBlock;

//- (void)getCurrentWeather:(float)latitude longitude:(float)longitude completionBlock:(void (^)(Weather *))completionBlock;

@end
