// plugin.js
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

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
