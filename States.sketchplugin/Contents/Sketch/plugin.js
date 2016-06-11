// States
// plugin.js
// Copyright © 2016 Internals Exposed. All rights reserved.

@import "lib/runtime.js"

function showStatesWindow(context)
{
	if (NSClassFromString("STStatesController") == null) {
		runtime.loadBundle("States.bundle");
		[STSketch setPluginContextDictionary: context];
	}

	var controller = [StatesController defaultController];
	if ([[controller window] isVisible]) {
		[[controller window] close];
	} else {
		[controller showWindow: nil];
	}
}
