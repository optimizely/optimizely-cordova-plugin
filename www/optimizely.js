/*global cordova, module*/

module.exports = {
    codeBlock: function(codeBlockKey, codeBranchNames, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Optimizely", "codeBlock", [codeBlockKey, codeBranchNames]);
    },
    enableEditor: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Optimizely", "enableEditor", []);
    },
    executeCodeBlock: function(codeBlockKey, codeBranches, context, errorCallback) {
        cordova.exec(function(codeBranchIndex) {
          codeBranches[parseInt(codeBranchIndex, 10)].apply(context);
        }, errorCallback, "Optimizely", "executeCodeBlock", [codeBlockKey]);
    },
    startOptimizely: function(token, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Optimizely", "startOptimizely", [token]);
    },
    stringVariable: function(variableKey, variableValue, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Optimizely", "stringVariable", [variableKey, variableValue]);
    },
    variableForKey: function(variableKey, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Optimizely", "variableForKey", [variableKey]);
    }
};
