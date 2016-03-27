#import <Cordova/CDV.h>
#import <Optimizely/Optimizely.h>
#import "OptimizelyCordovaLiveVariable.h"

@interface OptimizelyCordovaPlugin : CDVPlugin

@property (nonatomic, strong) NSMutableDictionary *liveVariablesMap;
@property (nonatomic, strong) NSMutableDictionary *codeBlocksMap;

- (void) booleanVariable:(CDVInvokedUrlCommand*)command;
- (void) codeBlock:(CDVInvokedUrlCommand*)command;
- (void) colorVariable:(CDVInvokedUrlCommand*)command;
- (void) enableEditor:(CDVInvokedUrlCommand*)command;
- (void) executeCodeBlock:(CDVInvokedUrlCommand*)command;
- (void) stringVariable:(CDVInvokedUrlCommand*)command;
- (void) trackEvent:(CDVInvokedUrlCommand*)command;
- (void) trackRevenueWithDescription:(CDVInvokedUrlCommand*)command;
- (void) variableForKey:(CDVInvokedUrlCommand*)command;
@end