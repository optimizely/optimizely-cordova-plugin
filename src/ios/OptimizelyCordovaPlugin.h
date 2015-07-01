#import <Cordova/CDV.h>
#import <Optimizely/Optimizely.h>

@interface OptimizelyCordovaPlugin : CDVPlugin

@property (nonatomic, strong) NSMutableDictionary *liveVariablesMap;
@property (nonatomic, strong) NSMutableDictionary *codeBlocksMap;

- (void) codeBlock:(CDVInvokedUrlCommand*)command;
- (void) enableEditor:(CDVInvokedUrlCommand*)command;
- (void) executeCodeBlock:(CDVInvokedUrlCommand*)command;
- (void) stringVariable:(CDVInvokedUrlCommand*)command;
- (void) variableForKey:(CDVInvokedUrlCommand*)command;
@end