/* Copyright Apple 2016+ */
/* Author: jcraig */

var $ = function(selector){
	return [].slice.call(document.querySelectorAll(selector));
};

// Override some broken accessibility in generated code from Hype.
var axInit = function(){
	
	// Correcting Hype's use of [aria-hidden="false"] 
	for (el of $('[aria-hidden="false"]')) {
		el.removeAttribute('aria-hidden');
	}

	// Correcting Hype's use of [aria-live]
	for (el of $('[aria-live]')) {
		el.removeAttribute('aria-live');
	}

	// Correcting Hype's use of [aria-flowto]
	for (el of $('[aria-flowto]')) {
		el.removeAttribute('aria-flowto');
	}
		
	var axContents = document.createElement('div');
	axContents.id = "axcontents";
	
	var hypeContainer = $('#logicaloperators_hype_container')[0];
	if (hypeContainer) { 
		//document.body.appendChild(axContents);
		document.body.insertBefore(axContents, hypeContainer);
	}
};

// don't forget to set new document.title on each sceen change

var hideAllWithSelector_exceptElementsWithSelector_ = function(hideSelector, showSelector){
	var elementsToShow = $(showSelector);
	var elementsToHide = $(hideSelector);
	elementsToHide = elementsToHide.filter(function(hideEl){
		return !(elementsToShow.includes(hideEl) || $('[aria-hidden="true"]').includes(hideEl));
	});
	for (showEl of elementsToShow) {
		showEl.removeAttribute('aria-hidden');
	}
	for (hideEl of elementsToHide) {
		hideEl.setAttribute('aria-hidden', 'true');
	}
}; 

var replaceAccessibilityContents = function(innerHTML) {
	var axContents = $('#axcontents')[0];
	if (!axContents) { 
		return;
	}
	axContents.innerHTML = innerHTML;

	// find first child of the new contents and make focusable
	var firstChild = axContents.firstChild;
	firstChild.style.outline = "none";
	firstChild.tabIndex = -1;
	
	updateFocus();
	//window.setTimeout(updateFocus, 1000);
	
};

var updateFocus = function(){
	var axContents = $('#axcontents')[0];
	if (!axContents) { 
		return;
	}
	// find and focus the first child of the new contents
	var firstChild = axContents.firstChild;
	firstChild.style.outline = "none";
	firstChild.tabIndex = -1;
	firstChild.focus();
	
}


