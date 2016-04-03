var DEFAULT_API_TIMEOUT = 3000;

exports.defineAutoTests = function() {
  describe('Optimizely plugin object', function() {
    it('should be defined in the window object', function() {
      expect(window.optimizely).toBeDefined();
    });
  });

  describe('public APIs', function() {
    describe('#startOptimizely', function() {
      it('should throw an error if no project token is passed in', function() {
        expect(window.optimizely.startOptimizely).toThrowError('Must pass in a project token');
      });

      it('should start optimizely within 3 seconds', function(done) {
        var startOptimizelyTimeout = window.setTimeout(function() {
          throw new Error('optimizely SDK not started on time');
        }, DEFAULT_API_TIMEOUT);

        var startOptimizelyPromise = window.optimizely.startOptimizely('ABC~123');
        startOptimizelyPromise.then(function(result) {
          window.clearTimeout(startOptimizelyTimeout);
          expect(result).toEqual('Optimizely Started');
          done();
        });
      });
    });

    describe('#enableEditor', function() {
      it('should enable the editor', function(done) {
        var enableEditorTimeout = window.setTimeout(function() {
          throw new Error('editor not enabled')
        }, DEFAULT_API_TIMEOUT);

        var enableEditorPromise = window.optimizely.enableEditor();
        enableEditorPromise.then(function(result) {
          window.clearTimeout(enableEditorTimeout);
          expect(result).toEqual('Editor Enabled');
          done();
        });
      });
    });

    describe('#refreshExperimentData', function() {
      it('should refresh the experiment data', function(done) {
        var refreshExperimentDataTimeout = window.setTimeout(function() {
          throw new Error('refresh experiment data timed out');
        }, DEFAULT_API_TIMEOUT);

        var refreshExperimentDataPromise = window.optimizely.refreshExperimentData();
        refreshExperimentDataPromise.then(function(result) {
          window.clearTimeout(refreshExperimentDataTimeout);
          expect(result).toEqual('OK');
          done();
        });
      });
    });

    describe('#setCustomTag', function() {
      it('should set the custom tag value', function(done) {
        var setCustomTagTimeout = window.setTimeout(function() {
          throw new Error('set custom tag timed out');
        }, DEFAULT_API_TIMEOUT);

        var setCustomTagPromise = window.optimizely.setCustomTag('loggedIn', 'true');
        setCustomTagPromise.then(function(result) {
          window.clearTimeout(setCustomTagTimeout);
          expect(result).toEqual('OK');
          done();
        });
      });
    });
  });
};
