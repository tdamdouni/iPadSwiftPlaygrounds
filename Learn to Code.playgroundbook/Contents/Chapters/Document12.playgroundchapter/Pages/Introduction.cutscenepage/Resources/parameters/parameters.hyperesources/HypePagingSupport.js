(function() {

	function addSwipeListener(element, listener) {
		var startX, startY;
		var dx;
		var direction;
		var handlesTouches = 'ontouchstart' in window;
		var allowableYFudgeFactor = 40;
		var minimumRequiredTravel = 50;
		var travelDistanceToAssumeSwipe = 125;

		var touchstartEventName = handlesTouches ? 'touchstart' : 'mousedown';
		var touchmoveEventName = handlesTouches ? 'touchmove' : 'mousemove';
		var touchendEventName = handlesTouches ? 'touchend' : 'mouseup';

		function cancelTouch() {
			element.removeEventListener(touchmoveEventName, onTouchMove);
			element.removeEventListener(touchendEventName, onTouchEnd);
			startX = null;
			startY = null;
			direction = null;
		}

		function onTouchMove(e) {
			if (e.touches && e.touches.length > 1) {
				cancelTouch();
				return;
			}

			dx = e.pageX - startX;
			var dy = e.pageY - startY;
			if (direction == null) {
				direction = dx;
				e.preventDefault();
			}
			else if ((direction < 0 && dx > 0) || (direction > 0 && dx < 0) || Math.abs(dy) > allowableYFudgeFactor) {
				cancelTouch();
			}
			else if (Math.abs(dx) > travelDistanceToAssumeSwipe) {
				cancelTouch();
				listener({
					direction: dx > 0 ? 'right' : 'left'
				});			
			}
		}

		function onTouchEnd(e) {
			cancelTouch();
			if (Math.abs(dx) > minimumRequiredTravel) {
				listener({
					direction: dx > 0 ? 'right' : 'left'
				});
			}
		}

		function onTouchStart(e) {
			if (!e.touches || (e.touches && e.touches.length == 1)) {
				startX = e.pageX;
				startY = e.pageY;
				element.addEventListener(touchmoveEventName, onTouchMove, false);
				element.addEventListener(touchendEventName, onTouchEnd, false);
			}
		}

		element.addEventListener(touchstartEventName, onTouchStart, false);
	}

	class Timeline {
		constructor(doc) {
			this.doc = doc;
			this.timelineName = "Main Timeline";
		}

		get maxTime() { // -> Float
			return this.doc.durationForTimelineNamed(this.timelineName);
		}

		get currentTime() { // -> Float
			return this.doc.currentTimeInTimelineNamed(this.timelineName);
		}

		set currentTime(time) { // -> Float
			this.doc.goToTimeInTimelineNamed(time, this.timelineName);
		}

		get isPlaying() {
			return this.doc.isPlayingTimelineNamed(this.timelineName);
		}

		pause() {
			this.doc.pauseTimelineNamed(this.timelineName);
		}

		play() {
			this.doc.continueTimelineNamed(this.timelineName);
		}
	}

	class TimelineScrubber {

		constructor(timeline, stopPoints, swipeThrottlingTime) {
			this.timeline = timeline;
			this.stopPoints = stopPoints;
			this.swipeThrottlingTime = swipeThrottlingTime;

			this.lastTimeSeenWhilePlaying = Number.MAX_SAFE_INTEGER;
			this.lastGestureTime = 0;

			this.observeTimeline();
		}

		observeTimeline() {
			var self = this;

			setInterval(function() {
				var timeline = self.timeline;
				var currentTime = timeline.currentTime;
				var stopPoints = self.stopPoints;

				if (timeline.isPlaying) {
					for (var i in Object.keys(stopPoints)) {
						var point = stopPoints[i];
						if (point > self.lastTimeSeenWhilePlaying && point <= currentTime) {
							timeline.pause();
							timeline.currentTime = point;
						}
					}
					self.lastTimeSeenWhilePlaying = currentTime;
				}
			}, 20);
		}

		currentClockTimeMilliseconds() {
			return (new Date()).valueOf()
		}

		firstStopPointBeforeTime(time) {
			for (var i = this.stopPoints.length-1; i >= 0; i--) {
				var point = this.stopPoints[i];
				if (point < time - 0.5) {
					return point;
				}
			}
			return undefined;
		}

		firstStopPointAfterTime(time) {
			for (var i in Object.keys(this.stopPoints)) {
				var point = this.stopPoints[i];
				if (point > time + 0.5) {
					return point;
				}
			}
			return undefined;
		}

		swipedForward() {
			var currentWallTime = this.currentClockTimeMilliseconds()
			if (currentWallTime - this.lastGestureTime < this.swipeThrottlingTime * 1000) {
				// Throttle gestures
				return;
			}

			if (this.timeline.isPlaying) {
				var timeToCheck = this.timeline.currentTime;

				var nextTime = this.firstStopPointAfterTime(timeToCheck);
				if (nextTime === undefined) { nextTime = this.timeline.maxTime; }

				this.timeline.currentTime = nextTime;
				this.lastTimeSeenWhilePlaying = nextTime;
				this.timeline.play();
			}
			else if (!this.timeline.isPlaying) {
				this.timeline.play();
			}

			this.lastGestureTime = this.currentClockTimeMilliseconds()
		}

		swipedBackward() {
			var currentWallTime = this.currentClockTimeMilliseconds()
			if (currentWallTime - this.lastGestureTime < this.swipeThrottlingTime * 1000) {
				// Throttle gestures
				return;
			}

			var prevTime = this.firstStopPointBeforeTime(this.timeline.currentTime);
			if (prevTime === undefined) { prevTime = 0; }

			// We don't want to just start at the last stop point,
			// we want to rewind to the previous one.
			var prevTime = this.firstStopPointBeforeTime(prevTime);
			if (prevTime === undefined) { prevTime = 0; }

			this.timeline.currentTime = prevTime;
			this.timeline.play();

			this.lastGestureTime = this.currentClockTimeMilliseconds()
		}
	}

	if (!window.GLOBALS) { window.GLOBALS = {}; }

	if('HYPE_eventListeners' in window === false) { window.HYPE_eventListeners = Array(); }
	window.HYPE_eventListeners.push({'type':'HypeSceneLoad', 'callback': function(document, element, event) {
		var timeline = new Timeline(document);
		var throttlingTime = window.GLOBALS.swipeThrottlingTime;
		var scrubber = new TimelineScrubber(timeline, window.GLOBALS.stopPoints || [], throttlingTime === undefined ? 1 : throttlingTime);

		addSwipeListener(window.document.body, function(e) {
			if (e.direction === 'right') {
				scrubber.swipedBackward();
			}
			else if (e.direction === 'left') {
				scrubber.swipedForward();
			}
		});

		window.GLOBALS.timeline = timeline;
		window.GLOBALS.scrubber = scrubber;

		return true;
	}});

})();
