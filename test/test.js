var assert = require('chai').assert;
var myModule = require('../index');

describe('Module', function() {
    it('should export "hello world"', function() {
        assert.equal(myModule, 'hello world');
    });
});
