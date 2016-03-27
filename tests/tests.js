exports.defineAutoTests = function() {
  describe('Optimizely plugin object', function() {
    it('should be defined in the window object', function() {
      expect(window.optimizely).toBeDefined();
    });
  });
};