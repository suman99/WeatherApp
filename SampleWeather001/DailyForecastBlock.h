//
//  DailyForecastBlock.h
//  SampleWeather001
//
//  Created by Suman on 07/03/17.
//  Copyright © 2017 Suman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@protocol PassData <NSObject>

-(void)passDataToFirst:(int)selValue;


@end

@interface DailyForecastBlock : UIView

@property(nonatomic,weak) id<PassData> delegate;

- (void)configureTodaysBlock:(Weather*)weather;
- (void)configureBlock:(Weather*)weather index:(float)index;

@end
