(function() {
if (!window.GLOBALS) { window.GLOBALS = {}; };

var swipeThrottlingTime = 1;
var stopPoints = [1.83, 2.70, 8.50, 11.17, 12.17, 13.17, 14.17, 17.50, 18.50, 20.00];

window.GLOBALS.stopPoints = stopPoints;
window.GLOBALS.swipeThrottlingTime = swipeThrottlingTime;
if (window.GLOBALS.scrubber) { window.GLOBALS.scrubber.stopPoints = stopPoints; };
})();
