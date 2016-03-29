/*global cordova, module*/
var _ = require('./lodash');
var codeBlocks = require('./code_blocks');
var goalTracking = require('./goal_tracking');
var liveVariables = require('./live_variables');
var nativeMixin = require('./native_mixin');

var optimizely = _.mixin({
  /**
   * Enables the SDK to connect to the web editor
   * Must be called before <startOptimizely>
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  enableEditor: function(successCallback, errorCallback) {
    return this.execNativeMethod({
      successCallback: successCallback,
      errorCallback: errorCallback,
      methodName: "enableEditor",
      params: []
    });
  },
  /**
   * Initializes the Optimizely SDK
   * All calls to register live variables and code blocks should happen before
   * calling this method.
   * @param  {String}   projectToken
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  startOptimizely: function(projectToken, successCallback, errorCallback) {
    if (!projectToken) {
      throw new Error('Must pass in a project token');
    }

    return this.execNativeMethod({
      successCallback: successCallback,
      errorCallback: errorCallback,
      methodName: "startOptimizely",
      params: [projectToken]
    });
  },
}, nativeMixin);

module.exports = _.extend(
  {},
  optimizely,
  codeBlocks,
  goalTracking,
  liveVariables
);
