#import "OptimizelyCordovaPlugin.h"

@implementation OptimizelyCordovaPlugin

static NSString *const STRING_VARIABLE_TYPE = @"string";
static NSString *const BOOL_VARIABLE_TYPE = @"boolean";
static NSString *const NUMBER_VARIABLE_TYPE = @"number";

- (void)enableEditor:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];

    [Optimizely enableEditor];
    [Optimizely disableSwizzle];
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@"Editor Enabled"];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)startOptimizely:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* token = [[command arguments] objectAtIndex:0];
    [Optimizely startOptimizelyWithAPIToken:token
                launchOptions:@{}];
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@"Optimizely Started"];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)booleanVariable:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* variableKey = [[command arguments] objectAtIndex:0];
    BOOL variableValue = [[command arguments] objectAtIndex:1];

    OptimizelyVariableKey *variable = [OptimizelyVariableKey optimizelyKeyWithKey:variableKey defaultBOOL:variableValue];
    [Optimizely preregisterVariableKey:variable];

    if (_liveVariablesMap == nil) {
      _liveVariablesMap = [[NSMutableDictionary alloc] init];
    }
    _liveVariablesMap[variableKey] = variable;

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)stringVariable:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* variableKey = [[command arguments] objectAtIndex:0];
    NSString* variableValue = [[command arguments] objectAtIndex:1];
    OptimizelyVariableKey *variable = [OptimizelyVariableKey optimizelyKeyWithKey:variableKey defaultNSString:variableValue];
    [Optimizely preregisterVariableKey:variable];

    if (_liveVariablesMap == nil) {
      _liveVariablesMap = [[NSMutableDictionary alloc] init];
    }
    _liveVariablesMap[variableKey] = variable;

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)numberVariable:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* variableKey = [[command arguments] objectAtIndex:0];
    NSNumber* variableValue = [[command arguments] objectAtIndex:1];

    OptimizelyVariableKey *variable = [OptimizelyVariableKey optimizelyKeyWithKey:variableKey defaultNSNumber:variableValue];
    [Optimizely preregisterVariableKey:variable];

    if (_liveVariablesMap == nil) {
      _liveVariablesMap = [[NSMutableDictionary alloc] init];
    }
    _liveVariablesMap[variableKey] = variable;

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)variableForKey:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* variableKey = [[command arguments] objectAtIndex:0];
    NSString* variableType = [[command arguments] objectAtIndex:1];

    OptimizelyVariableKey *optimizelyVariableKey = [_liveVariablesMap valueForKey:variableKey];
    CDVPluginResult* result;
    if (optimizelyVariableKey != nil) {
      id variableValue;

      if ([variableType isEqualToString:STRING_VARIABLE_TYPE]) {
        variableValue = [Optimizely stringForKey:optimizelyVariableKey];
      } else if ([variableType isEqualToString:BOOL_VARIABLE_TYPE]) {
        variableValue = [NSNumber numberWithBool:[Optimizely boolForKey:optimizelyVariableKey]];
      } else if ([variableType isEqualToString:NUMBER_VARIABLE_TYPE]) {
        variableValue = [Optimizely numberForKey:optimizelyVariableKey];
      }

      NSDictionary *resultDictionary = @{
        @"variableKey": variableKey,
        @"variableValue": variableValue
      };

      result = [CDVPluginResult
                resultWithStatus:CDVCommandStatus_OK
                messageAsDictionary:resultDictionary];
    } else {
      result = [CDVPluginResult
                resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)codeBlock:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* codeBlockKey = [[command arguments] objectAtIndex:0];
    NSArray* blockNames = [[command arguments] objectAtIndex:1];
    OptimizelyCodeBlocksKey *optimizelyCodeBlockKey = [OptimizelyCodeBlocksKey optimizelyCodeBlocksKey:codeBlockKey
                                                                               blockNames:blockNames];
    [Optimizely preregisterBlockKey:optimizelyCodeBlockKey];
    if (_codeBlocksMap == nil) {
      _codeBlocksMap = [[NSMutableDictionary alloc] init];
    }
    _codeBlocksMap[codeBlockKey] = optimizelyCodeBlockKey;

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)executeCodeBlock:(CDVInvokedUrlCommand*)command
{
    NSString *callbackId = [command callbackId];
    NSString *codeBlockKey = [[command arguments] objectAtIndex:0];
    OptimizelyCodeBlocksKey *optimizelyCodeBlockKey = _codeBlocksMap[codeBlockKey];
    NSArray *blockNames = [optimizelyCodeBlockKey blockNames];
    int numberBlockNames = [[optimizelyCodeBlockKey blockNames] count];
    __block int blockIndex = 0;

    if (optimizelyCodeBlockKey != nil) {
      switch (numberBlockNames) {
            case 1:
                [Optimizely codeBlocksWithKey:optimizelyCodeBlockKey blockOne:^{
                    __block blockIndex = 1;
                }defaultBlock:^{
                    blockIndex = 0;
                }];
                break;
            case 2:
                [Optimizely codeBlocksWithKey:optimizelyCodeBlockKey blockOne:^{
                    blockIndex = 1;
                }blockTwo:^{
                    blockIndex = 2;
                }defaultBlock:^{
                    blockIndex = 0;
                }];
                break;
            case 3:
                [Optimizely codeBlocksWithKey:optimizelyCodeBlockKey blockOne:^{
                    blockIndex = 1;
                }blockTwo:^{
                    blockIndex = 2;
                }blockThree:^{
                    blockIndex = 3;
                }defaultBlock:^{
                    blockIndex = 0;
                }];
                break;
            case 4:
                [Optimizely codeBlocksWithKey:optimizelyCodeBlockKey blockOne:^{
                    blockIndex = 1;
                }blockTwo:^{
                    blockIndex = 2;
                }blockThree:^{
                    blockIndex = 3;
                }blockFour:^{
                    blockIndex = 4;
                }defaultBlock:^{
                    blockIndex = 0;
                }];
                break;
            default:
                break;
      }

      CDVPluginResult* result = [CDVPluginResult
                                 resultWithStatus:CDVCommandStatus_OK
                                 messageAsInt:blockIndex];

      [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }
}

@end