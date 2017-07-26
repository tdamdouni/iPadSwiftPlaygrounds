(function() {
if (!window.GLOBALS) { window.GLOBALS = {}; };

var swipeThrottlingTime = 1;
 var stopPoints = [1.70, 5.00, 7.50, 15.00, 25.50, 31.43, 33.13];

window.GLOBALS.stopPoints = stopPoints;
window.GLOBALS.swipeThrottlingTime = swipeThrottlingTime;
if (window.GLOBALS.scrubber) { window.GLOBALS.scrubber.stopPoints = stopPoints; };
})();
