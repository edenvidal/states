// States for Sketch
// runime.js
// Copyright © 2016 Internals Exposed. All rights reserved.


(function(){
	this.runtime = {};
	/// XXX
	this.runtime.pluginPath = function()
	{
		var result = [NSString stringWithString: coscript.env().scriptURL.path()];
		while(result.lastPathComponent().pathExtension() != "sketchplugin"){
			result = result.stringByDeletingLastPathComponent();
		}
		return result;
	}
	/// XXX
 	this.runtime.loadBundle = function(bundleName)
	{
		var bundlePath = runtime.pluginPath() + "/Contents/Resources/" + bundleName;
		var bundle = [NSBundle bundleWithPath: bundlePath];
		bundle.load();
	}
})();
