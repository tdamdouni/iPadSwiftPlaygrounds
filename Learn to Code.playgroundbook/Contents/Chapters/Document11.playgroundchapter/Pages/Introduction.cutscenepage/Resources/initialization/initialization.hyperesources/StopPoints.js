(function() {
if (!window.GLOBALS) { window.GLOBALS = {}; };

var swipeThrottlingTime = 1;
var stopPoints = [1.70, 5.40, 9.50, 12.00, 14.80];

window.GLOBALS.stopPoints = stopPoints;
window.GLOBALS.swipeThrottlingTime = swipeThrottlingTime;
if (window.GLOBALS.scrubber) { window.GLOBALS.scrubber.stopPoints = stopPoints; };
})();
