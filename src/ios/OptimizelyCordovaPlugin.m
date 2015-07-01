#import "OptimizelyCordovaPlugin.h"

@implementation OptimizelyCordovaPlugin

- (void)enableEditor:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];

    [Optimizely enableEditor];
    [Optimizely disableSwizzle];
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:@"Editor Enabled"];

    [self success:result callbackId:callbackId];
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

    [self success:result callbackId:callbackId];
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

    [self success:result callbackId:callbackId];
}

- (void)variableForKey:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* variableKey = [[command arguments] objectAtIndex:0];
    OptimizelyVariableKey *optimizelyVariableKey = [_liveVariablesMap valueForKey:variableKey];
    CDVPluginResult* result;
    if (optimizelyVariableKey != nil) {
      NSDictionary *resultDictionary = @{
        @"variableKey": variableKey,
        @"variableValue": [Optimizely stringForKey:optimizelyVariableKey]
      };

      result = [CDVPluginResult
                resultWithStatus:CDVCommandStatus_OK
                messageAsDictionary:resultDictionary];
    } else {
      result = [CDVPluginResult
                resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self success:result callbackId:callbackId];
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

    [self success:result callbackId:callbackId];
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

      [self success:result callbackId:callbackId];
    }
}

@end