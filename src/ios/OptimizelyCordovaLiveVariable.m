//
//  OptimizelyCordovaLiveVariable.m
//  OptimizelyPhonegapApp
//
//  Created by Michael Ng on 3/19/16.
//
//

#import "OptimizelyCordovaLiveVariable.h"

@implementation OptimizelyCordovaLiveVariable

int const VARIABLE_TYPE_BOOLEAN = 1;
int const VARIABLE_TYPE_COLOR = 2;
int const VARIABLE_TYPE_NUMBER = 3;
int const VARIABLE_TYPE_STRING = 4;

-(id)initWithKey:(NSString*)key value:(id)value type:(int)type
{
    if (self = [super init]) {
        _variableType = type;

        switch (type) {
            case VARIABLE_TYPE_BOOLEAN:
            _liveVariable = [OptimizelyVariableKey optimizelyKeyWithKey:key
                                                            defaultBOOL:value];
            break;

            case VARIABLE_TYPE_COLOR:
            _liveVariable = [OptimizelyVariableKey optimizelyKeyWithKey:key
                                                        defaultUIColor:[self getColorFromHexString:value]];
            break;

            case VARIABLE_TYPE_NUMBER:
            _liveVariable = [OptimizelyVariableKey optimizelyKeyWithKey:key
                                                        defaultNSNumber:value];
            break;


            case VARIABLE_TYPE_STRING:
            _liveVariable = [OptimizelyVariableKey optimizelyKeyWithKey:key
                                                        defaultNSString:value];
            break;

            default:
            break;
        }
    }
    return self;
}

-(UIColor *)getColorFromHexString:(NSString*)hexStr
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;

    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];

    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];

    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1];

    return color;
}

-(NSString *)getHexColorFromUIColor:(UIColor*)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);

    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];

    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

-(id)getValue
{
    id variableValue;

    switch (_variableType) {
        case VARIABLE_TYPE_BOOLEAN:
        variableValue = [NSNumber numberWithBool:[Optimizely boolForKey:_liveVariable]];
        break;

        case VARIABLE_TYPE_COLOR:
        variableValue = [self getHexColorFromUIColor:[Optimizely colorForKey:_liveVariable]];
        break;

        case VARIABLE_TYPE_NUMBER:
        variableValue = [Optimizely numberForKey:_liveVariable];
        break;

        case VARIABLE_TYPE_STRING:
        variableValue = [Optimizely stringForKey:_liveVariable];
        break;

        default:
        break;
    }

    return variableValue;
}

@end