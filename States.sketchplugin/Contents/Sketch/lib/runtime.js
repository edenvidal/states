// runtime.js
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

(function(){
	this.runtime = {};
	/// This function fetches the plugin path from a current script path
	this.runtime.pluginPath = function()
	{
		var result = [NSString stringWithString: coscript.env().scriptURL.path()];
		while(result.lastPathComponent().pathExtension() != "sketchplugin"){
			result = result.stringByDeletingLastPathComponent();
		}
		return result;
	}
	/// This function loads a bundle with the given name located in Resources directory
 	/// of this plugin
 	this.runtime.loadBundle = function(bundleName)
	{
		var bundlePath = runtime.pluginPath() + "/Contents/Resources/" + bundleName;
		var bundle = [NSBundle bundleWithPath: bundlePath];
		bundle.load();
	}
})();
