(function() {
if (!window.GLOBALS) { window.GLOBALS = {}; };

var swipeThrottlingTime = 1;
var stopPoints = [2.70, 5.37, 13.23, 14.73, 19.33, 22.00, 28.70, 35.83, 38.20];

window.GLOBALS.stopPoints = stopPoints;
window.GLOBALS.swipeThrottlingTime = swipeThrottlingTime;
if (window.GLOBALS.scrubber) { window.GLOBALS.scrubber.stopPoints = stopPoints; };
})();
