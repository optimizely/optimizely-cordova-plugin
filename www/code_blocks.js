/**
 * Code Blocks module handles registering and executing code blocks
 */
var _ = require('./lodash');
var nativeMixin = require('./native_mixin');

var codeBlocks = {
  /**
   * Registers a code block
   * @param  {String}         codeBlockKey
   * @param  {Array<String>}  codeBranchNames
   * @param  {Function}       successCallback
   * @param  {Function}       errorCallback
   * @return {Promise}
   */
  codeBlock: function(codeBlockKey, codeBranchNames, successCallback, errorCallback) {
    return this.execNativeMethod({
      successCallback: successCallback,
      errorCallback: errorCallback,
      methodName: "codeBlock",
      params: [codeBlockKey, codeBranchNames]
    });
  },
  /**
   * Figures out wich code branch to execute and executes it
   * @param  {String}           codeBlockKey
   * @param  {Array<Function>}  codeBranches
   * @param  {Object}           context
   * @param  {Function}         errorCallback
   * @return {Promise}
   */
  executeCodeBlock: function(codeBlockKey, codeBranches, context, errorCallback) {
    // the native call actually just returns an index of the branch to execute
    return this.execNativeMethod({
      successCallback: function(codeBranchIndex) {
        codeBranches[parseInt(codeBranchIndex, 10)].apply(context);
      },
      errorCallback: errorCallback,
      methodName: "executeCodeBlock",
      params: [codeBlockKey]
    });
  },
};

module.exports = _.mixin(
  codeBlocks,
  nativeMixin
);
