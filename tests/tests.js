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
        }, 3000);

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
        }, 3000);

        var enableEditorPromise = window.optimizely.enableEditor();
        enableEditorPromise.then(function(result) {
          window.clearTimeout(enableEditorTimeout);
          expect(result).toEqual('Editor Enabled');
          done();
        });
      });
    });
  });
};
