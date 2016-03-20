//
//  OptimizelyCordovaLiveVariable.h
//  OptimizelyPhonegapApp
//
//  Created by Michael Ng on 3/19/16.
//
//
#import <Optimizely/Optimizely.h>
#import <UIKit/UIKit.h>

@interface OptimizelyCordovaLiveVariable : NSObject

extern int const VARIABLE_TYPE_BOOLEAN;
extern int const VARIABLE_TYPE_COLOR;
extern int const VARIABLE_TYPE_NUMBER;
extern int const VARIABLE_TYPE_STRING;

@property int variableType;
@property OptimizelyVariableKey *liveVariable;

-(id)initWithKey:(NSString*)key
            value:(id)value
             type:(int)type;
-(id)getValue;
@end
