//
//  UIColor+CustomColors.m
//  Popping
//
//  Created by André Schneider on 25.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)customGrayColor
{
    return [self colorWithRed:149 green:165 blue:166];
}

+ (UIColor *)customRedColor
{
    return [self colorWithRed:231 green:76 blue:60];
}

+ (UIColor *)customYellowColor
{
    return [self colorWithRed:241 green:196 blue:15];
}

+ (UIColor *)customGreenColor
{
    return [self colorWithRed:46 green:204 blue:113];
}

+ (UIColor *)customBlueColor
{
//    return [self colorWithRed:52 green:152 blue:219];
    return [self colorWithRed:88 green:141 blue:236];

}
+ (UIColor *)customPinkColor{
    return [self colorWithRed:255 green:186 blue:210];
}

+ (UIColor *)customOrangeColor{
    return [self colorWithRed:243 green:156 blue:18];
}

+ (UIColor *)customPurpleColor{
    return [self colorWithRed:142 green:68 blue:173];
}

#pragma mark - Private class methods

+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue
{
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:1.f];
}

@end
