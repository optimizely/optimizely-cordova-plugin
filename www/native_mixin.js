var exec = require('cordova/exec');
var FEATURE_NAME = 'Optimizely';

module.exports = {
  /**
   * [execNativeMethod description]
   * @param  {Object} options
   * @param  {Object} options.methodName
   * @param  {Object} options.params
   * @param  {Object} options.successCallback
   * @param  {Object} options.errorCallback
   */
  execNativeMethod: function(options) {
    exec(
      options.successCallback,
      options.errorCallback,
      FEATURE_NAME,
      options.methodName,
      options.params
    );
  }
}
