var exec = require('cordova/exec');
var FEATURE_NAME = 'Optimizely';

module.exports = {
  /**
   * Call into native SDK methods
   * @param  {Object} options
   * @param  {Object} options.methodName
   * @param  {Object} options.params
   * @param  {Object} options.successCallback
   * @param  {Object} options.errorCallback
   * @return {Promise}
   */
  execNativeMethod: function(options) {
    return new Promise(function(resolve, reject) {
      exec(
        function(result) {
          resolve(result);
          if (typeof options.successCallback === 'function') {
            options.successCallback(result);
          }
        },
        function(error) {
          reject(error);
          if (typeof options.errorCallback === 'function') {
            options.errorCallback(error);
          }
        },
        FEATURE_NAME,
        options.methodName,
        options.params
      );
    });
  }
}
