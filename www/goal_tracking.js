/**
 * Goal Tracking module handles tracking custom events and revenue events
 */
var _ = require('./lodash');
var nativeMixin = require('./native_mixin');

var goalTracking = {
  /**
   * Tracks the custom event with the given name
   * @param  {String}   eventName
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  trackEvent: function(eventName, successCallback, errorCallback) {
    if (!eventName) {
      throw new Error('Must supply an event name');
    }

    return this.execNativeMethod({
      successCallback: successCallback,
      errorCallback: errorCallback,
      methodName: 'trackEvent',
      params: [eventName],
    });
  },
  /**
   * Track the given revenue amount
   * @param  {int}      revenueAmount
   * @param  {String}   revenueDescription
   * @param  {Function} successCallback
   * @param  {Function} errorCallback
   * @return {Promise}
   */
  trackRevenueWithDescription: function(revenueAmount, revenueDescription, successCallback, errorCallback) {
    try {
      revenueAmount = parseInt(revenueAmount, 10);
    } catch (e) {
      throw new Error('The revenue amount should be an integer number of cents');
    }

    if (!revenueDescription) {
      throw new Error('Must supply a description for revenue tracking');
    }

    return this.execNativeMethod({
      successCallback: successCallback,
      errorCallback: errorCallback,
      methodName: 'trackRevenueWithDescription',
      params: [revenueAmount, revenueDescription],
    });
  },
};

module.exports = _.mixin(
  goalTracking,
  nativeMixin
);