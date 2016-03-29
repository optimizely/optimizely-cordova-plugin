/**
 * Live Variables module handles registering and fetching variables
 */
var _ = require('./lodash');
var enums = require('./enums');
var nativeMixin = require('./native_mixin');

var liveVariables = {
  /**
   * Retrieves the boolean value for the variable registered with the given variable key
   * @param  {String}   variableKey
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  booleanForKey: function(variableKey, successCallback, errorCallback) {
    return retrieveVariableValue(
      variableKey,
      enums.VARIABLE_TYPES.BOOLEAN,
      successCallback,
      errorCallback
    );
  },
  /**
   * Registers a boolean live variable with the given variable key and default value
   * @param  {String}   variableKey
   * @param  {Boolean}  defaultValue
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  booleanVariable: function(variableKey, defaultValue, successCallback, errorCallback) {
    return registerVariable(
      variableKey,
      defaultValue,
      enums.VARIABLE_TYPES.BOOLEAN,
      successCallback,
      errorCallback
    );
  },
  /**
   * Retrieves the color value for the variable registered with the given variable key
   * as a hex string
   * @param  {String}   variableKey
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  colorForKey: function(variableKey, successCallback, errorCallback) {
    return retrieveVariableValue(
      variableKey,
      enums.VARIABLE_TYPES.COLOR,
      successCallback,
      errorCallback
    );
  },
  /**
   * Registers a color live variable with the given variable key and default value
   * @param  {String}   variableKey
   * @param  {String}   defaultValue     color value in hex format
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  colorVariable: function(variableKey, defaultValue, successCallback, errorCallback) {
    return registerVariable(
      variableKey,
      defaultValue,
      enums.VARIABLE_TYPES.COLOR,
      successCallback,
      errorCallback
    );
  },
  /**
   * Retrieves the number value for the variable registered with the given variable key
   * @param  {String}   variableKey
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  numberForKey: function(variableKey, successCallback, errorCallback) {
    return retrieveVariableValue(
      variableKey,
      enums.VARIABLE_TYPES.NUMBER,
      successCallback,
      errorCallback
    );
  },
  /**
   * Registers a number live variable with the given variable key and default value
   * @param  {String}   variableKey
   * @param  {Number}   defaultValue
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  numberVariable: function(variableKey, defaultValue, successCallback, errorCallback) {
    return registerVariable(
      variableKey,
      defaultValue,
      enums.VARIABLE_TYPES.NUMBER,
      successCallback,
      errorCallback
    );
  },
  /**
   * Registers a string live variable with the given variable key and default value
   * @param  {String}   variableKey
   * @param  {String}   defaultValue
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  stringVariable: function(variableKey, defaultValue, successCallback, errorCallback) {
    return registerVariable(
      variableKey,
      defaultValue,
      enums.VARIABLE_TYPES.STRING,
      successCallback,
      errorCallback
    );
  },
  /**
   * Retrieves the string value for the variable registered with the given variable key
   * @param  {String}   variableKey
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  stringForKey: function(variableKey, successCallback, errorCallback) {
    return retrieveVariableValue(
      variableKey,
      enums.VARIABLE_TYPES.STRING,
      successCallback,
      errorCallback
    );
  },
};

/**
 * Registers the given variable
 * @param  {String}   variableKey
 * @param  {?}        defaultValue
 * @param  {String}   variableType
 * @param  {Function} successCallback
 * @param  {Function} errorCallback
 * @return {Promise}
 */
function registerVariable(variableKey, defaultValue, variableType, successCallback, errorCallback) {
  return nativeMixin.execNativeMethod({
    successCallback: successCallback,
    errorCallback: errorCallback,
    methodName: variableType + 'Variable',
    params: [variableKey, defaultValue],
  });
}

/**
 * Retrieve the value for the given variable key
 * @param  {String}   variableKey
 * @param  {String}   variableType
 * @param  {Function} successCallback
 * @param  {Function} errorCallback
 * @return {Promise}
 */
function retrieveVariableValue(variableKey, variableType, successCallback, errorCallback) {
  return nativeMixin.execNativeMethod({
    successCallback: successCallback,
    errorCallback: errorCallback,
    methodName: 'variableForKey',
    params: [variableKey, variableType],
  });
}

module.exports = _.mixin(
  liveVariables,
  nativeMixin
);
