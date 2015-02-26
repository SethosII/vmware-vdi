'use strict';

// creates a new graph and restores the options from the old, if existing
// initial zoom is the last day
function newGraph(toggleRangeSelector) {
	var selectedPool = getSelectedPool();

	var start;
	var end;
	var showRangeSelector;
	var rollPeriod;
	var animatedZooms;

	if (typeof graph == 'undefined') {
		end = new Date().getTime();
		start = new Date().getTime() - 1000 * 60 * 60 * 24;
		showRangeSelector = false;
		rollPeriod = 1;
		animatedZooms = true;
		showRangeSelector = false;
	} else {
		start = graph.xAxisRange()[0];
		end = graph.xAxisRange()[1];
		showRangeSelector = graph.getOption("showRangeSelector");
		if (toggleRangeSelector) {
			showRangeSelector = !showRangeSelector;
		}
		rollPeriod = graph.rollPeriod();
		if (showRangeSelector) {
			animatedZooms = false;
			showRangeSelector = true;
		} else {
			animatedZooms = true;
			showRangeSelector = false;
		}
	}

	return new Dygraph(
		document.getElementById("graphDiv"),
		selectedPool + ".csv",
		{
			labels: ["Date", "Users"],
			legend: 'always',
			title: selectedPool + " - concurrent users",
			dateWindow: [start, end],
			showRoller: true,
			rollPeriod: rollPeriod,
			showRangeSelector: showRangeSelector,
			animatedZooms: animatedZooms,
			drawCallback: function() {
				var start = graph.xAxisRange()[0];
				var end = graph.xAxisRange()[1];
				updateDateInput(start, end);
			},
			series: {
				Users: {
					color: 'rgba(0,88,156,255)'
				}
			}
		}
	);
}

// call approachRange with delay
function animateZoom(startRange, desiredRange, step) {
	setTimeout(function() {
		approachRange(startRange, desiredRange, step)
	}, 10)
}

// go one step further to the desired range
function approachRange(startRange, desiredRange, step) {
	var maxSteps = 10;
	if (step < maxSteps) {
		step++;
		var newRange = [startRange[0] + (desiredRange[0] - startRange[0]) * step / maxSteps, startRange[1] + (desiredRange[1] - startRange[1]) * step / maxSteps];
		graph.updateOptions({dateWindow: newRange});
		animateZoom(startRange, desiredRange, step);
	} else {
		graph.updateOptions({dateWindow: desiredRange});
		zooming = false;
	}
}

// zoom to the date range specified in the date input fields
function dateInput() {
	if (!zooming) {
		zooming = true;
		var startRange = graph.xAxisRange();
		var start = (new Date(document.getElementById("dateStart").value)).getTime();
		var end = (new Date(document.getElementById("dateEnd").value)).getTime();
		animateZoom(startRange, [start, end], 0);
	}
}

// return the currently selected pool
function getSelectedPool() {
	var pools = document.getElementsByName("pools");
	var selectedPool;
	for(var i = 0; i < pools.length; i++) {
		if(pools[i].checked == true) {
			selectedPool = pools[i].value;
			break;
		}
	}
	return selectedPool;
}

// resets zoom animated
function resetZoom() {
	if (!zooming) {
		zooming = true;
		var startRange = graph.xAxisRange();
		var desiredRange = graph.xAxisExtremes();
		animateZoom(startRange, desiredRange, 0);
	}
}

// create a new graph with the range selector toggled
function toggleRangeSelector() {
	graph = newGraph(true);

}

// update the data when minutes equal 2, 17, 32 or 47
function updateData() {
	var minute = new Date().getMinutes();
	var afterUpdate = minute == 2 || minute == 17 || minute == 32 || minute == 47;
	if (afterUpdate) {
		var selectedPool = getSelectedPool();
		graph.updateOptions({'file': selectedPool + ".csv"});
	}
}

// update the date input fields
function updateDateInput(start, end) {
	document.getElementById("dateStart").value = new Date(start);
	document.getElementById("dateEnd").value = new Date(end);
}

// zoom to the specified intervall, current left end is fixed
function zoom(xAxisLength) {
	if (!zooming) {
		zooming = true;
		var startRange = graph.xAxisRange();
		var end = graph.xAxisRange()[1];
		var start = end - xAxisLength;
		animateZoom(startRange, [start, end], 0);
	}
}
