(function() {
if (!window.GLOBALS) { window.GLOBALS = {}; };

var swipeThrottlingTime = 1;
var stopPoints = [1.70, 5.70, 11.50, 15.50, 17.50, 26.00, 28.00, 29.77, 34.57];

window.GLOBALS.stopPoints = stopPoints;
window.GLOBALS.swipeThrottlingTime = swipeThrottlingTime;
if (window.GLOBALS.scrubber) { window.GLOBALS.scrubber.stopPoints = stopPoints; };
})();
