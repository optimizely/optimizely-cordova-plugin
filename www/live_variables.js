/**
 * Live Variables module handles registering and fetching variables
 */
var _ = require('./lodash');
var nativeMixin = require('./native_mixin');

var liveVariables = {
  /**
   * Retrieves the boolean value for the variable registered with the given variable key
   * @param  {String}   variableKey
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   */
  booleanForKey: function(variableKey, successCallback, errorCallback) {
    this.execNativeMethod({
      successCallback: successCallback,
      errorCallback: errorCallback,
      methodName: "variableForKey",
      params: [variableKey, 'boolean'],
    });
  },
  /**
   * Registers a boolean live variable with the given variable key and default value
   * @param  {String}   variableKey
   * @param  {Boolean}  variableValue
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   */
  booleanVariable: function(variableKey, variableValue, successCallback, errorCallback) {
    this.execNativeMethod({
      successCallback: successCallback,
      errorCallback: errorCallback,
      methodName: "booleanVariable",
      params: [variableKey, variableValue],
    });
  },
  /**
   * Retrieves the string value for the variable registered with the given variable key
   * @param  {String}   variableKey
   * @param  {String}   variableValue
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   */
  stringVariable: function(variableKey, variableValue, successCallback, errorCallback) {
    this.execNativeMethod({
      successCallback: successCallback,
      errorCallback: errorCallback,
      methodName: "stringVariable",
      params: [variableKey, variableValue],
    });
  },
  /**
   * Registers a string live variable with the given variable key and default value
   * @param  {String}   variableKey
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   */
  stringForKey: function(variableKey, successCallback, errorCallback) {
    this.execNativeMethod({
      successCallback: successCallback,
      errorCallback: errorCallback,
      methodName: "variableForKey",
      params: [variableKey, 'string'],
    });
  },
};

module.exports = _.mixin(
  liveVariables,
  nativeMixin
);
