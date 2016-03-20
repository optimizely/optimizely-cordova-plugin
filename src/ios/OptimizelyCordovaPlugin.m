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
    id variableValue = [[command arguments] objectAtIndex:1];

    [self registerVariableForKey:variableKey
                           value:variableValue
                            type:VARIABLE_TYPE_BOOLEAN];
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)colorVariable:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* variableKey = [[command arguments] objectAtIndex:0];
    id variableValue = [[command arguments] objectAtIndex:1];

    [self registerVariableForKey:variableKey
                           value:variableValue
                            type:VARIABLE_TYPE_COLOR];
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)stringVariable:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* variableKey = [[command arguments] objectAtIndex:0];
    id variableValue = [[command arguments] objectAtIndex:1];

    [self registerVariableForKey:variableKey
                           value:variableValue
                            type:VARIABLE_TYPE_STRING];
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)numberVariable:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* variableKey = [[command arguments] objectAtIndex:0];
    id variableValue = [[command arguments] objectAtIndex:1];

    [self registerVariableForKey:variableKey
                           value:variableValue
                            type:VARIABLE_TYPE_NUMBER];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)variableForKey:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* variableKey = [[command arguments] objectAtIndex:0];

    OptimizelyCordovaLiveVariable *variable = [_liveVariablesMap valueForKey:variableKey];

    CDVPluginResult* result;
    if (variable != nil) {
      NSDictionary *resultDictionary = @{
        @"variableKey": variableKey,
        @"variableValue": [variable getValue]
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

- (void)registerVariableForKey:(NSString*)key value:(id)value type:(int)type
{
    OptimizelyCordovaLiveVariable *variable = [[OptimizelyCordovaLiveVariable alloc] initWithKey:key
                                                                                           value:value
                                                                                            type:type];
    [Optimizely preregisterVariableKey:[variable liveVariable]];

    if (_liveVariablesMap == nil) {
        _liveVariablesMap = [[NSMutableDictionary alloc] init];
    }
    _liveVariablesMap[key] = variable;
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