//
//  DailyForecastBlock.m
//  SampleWeather001
//
//  Created by Suman on 07/03/17.
//  Copyright © 2017 Suman. All rights reserved.
//

#import "DailyForecastBlock.h"

@interface DailyForecastBlock ()

@property (nonatomic, strong) UILabel *dayOfWeekTitle;
@property (nonatomic, strong) UIImageView *weatherIcon;
@property (nonatomic, strong) UILabel *temperature;
@property (nonatomic, strong) UIButton *btnCurrentDay;
@property (nonatomic) BOOL needsTopBorder;

@end

@implementation DailyForecastBlock

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        int tagInt = frame.origin.x/100;
        
        self.btnCurrentDay = [[UIButton alloc] init];
        [self.btnCurrentDay setBackgroundColor:[UIColor clearColor]];
        self.btnCurrentDay.tag = tagInt;
        [self.btnCurrentDay addTarget:self action:@selector(showCurrentDayTemparature:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.btnCurrentDay];
        
        self.dayOfWeekTitle = [[UILabel alloc] init];
        self.dayOfWeekTitle.textColor = [UIColor whiteColor];
        self.dayOfWeekTitle.backgroundColor = [UIColor clearColor];
        self.dayOfWeekTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        self.dayOfWeekTitle.textAlignment = NSTextAlignmentCenter;
        self.dayOfWeekTitle.text = @"SUN";
        [self addSubview:self.dayOfWeekTitle];
        
        self.weatherIcon = [[UIImageView alloc] init];
        self.weatherIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.weatherIcon];
        
        self.temperature = [[UILabel alloc] init];
        self.temperature.textColor = [UIColor whiteColor];
        self.temperature.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        self.temperature.textAlignment = NSTextAlignmentCenter;
        self.temperature.text = @"98° / 86°";
        [self addSubview:self.temperature];
        
        self.backgroundColor = [UIColor colorWithRed:(30.0/255.0) green:(178.0/255.0) blue:(205.00/255.0) alpha:1.0];
        self.weatherIcon.image = [UIImage imageNamed:@"sunny.png"];
    }
    return self;
}

- (void)showCurrentDayTemparature:(id)sender{
    UIButton* selBtn = (UIButton*)sender;
    [self.delegate passDataToFirst:selBtn.tag];
    
}




- (void)layoutSubviews {
    self.dayOfWeekTitle.frame = CGRectMake(0, 20, CGRectGetWidth(self.frame), 20);
    self.weatherIcon.frame = CGRectMake(20, 54, 60, 60);
    self.temperature.frame = CGRectMake(0, 126, CGRectGetWidth(self.frame), 20);
    self.btnCurrentDay.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)configureTodaysBlock:(Weather*)weather {
    self.backgroundColor = [UIColor colorWithRed:(44.0/255.0) green:(210.0/255.0) blue:1.0 alpha:1.0];
    self.temperature.hidden = FALSE;
    self.temperature.text = [NSString stringWithFormat:@"%d° / %d°", weather.temperatureMax, weather.temperatureMin];
    self.weatherIcon.hidden = TRUE;
    self.dayOfWeekTitle.text = @"TODAY";
    
    self.needsTopBorder = FALSE;
}


- (void)configureBlock:(Weather*)weather index:(float)index{
    
    
    UIColor* currentBGColor = [UIColor colorWithRed:(44.0/255.0) green:(210.0/255.0) blue:1.0 alpha:1.0];
    
    //get the hue, brightness, and saturation components of the new color to make a lighter shade for the highlight state
    CGFloat hue, saturation, brightness, alpha;
    [currentBGColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    //now set highlight state by modifying brightness with a 30% increase
    self.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:(brightness / (1.0 + (index/10.0))) alpha:alpha];


    //self.backgroundColor = [UIColor colorWithRed:(30.0/255.0) green:(178.0/255.0) blue:(205.00/255.0) alpha:1.0];
    self.needsTopBorder = TRUE;
    
    self.weatherIcon.image = [weather getWeatherImageForCurrentCondition];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    self.dayOfWeekTitle.text = [[dateFormatter stringFromDate:weather.dateOfForecast] uppercaseString];
    
    self.temperature.text = [NSString stringWithFormat:@"%d° / %d°", weather.temperatureMax, weather.temperatureMin];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(24.0/255.0) green:(157.0/255.0) blue:(178.00/255.0) alpha:1.0].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0f);
    
    if(self.needsTopBorder) {
        CGContextMoveToPoint(context, 0.0f, 1.0f); //start at this point
        
        CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), 1.0f); //draw to this point
        
        // and now draw the Path!
        CGContextStrokePath(context);
    }
}


@end
