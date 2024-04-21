// Enable adding custom search engines
user_pref("browser.urlbar.update2.engineAliasRefresh", true);

// enable compact mode
user_pref("browser.compactmode.show", true);

// Disable pocket
user_pref("extensions.pocket.enabled", false);

// Enable urlbar searches
user_pref("keyword.enabled", true);

// enable WebRTC
user_pref("media.peerconnection.enabled", true)
user_pref("media.peerconnection.ico.no_host", false)
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", false)
user_pref("media.peerconnection.ice.default_address_only", true);

// needed for screensharing
user_pref("media.getusermedia.screensharing.enabled", true);

// screen flicker in Zoon, this should be false
user_pref("layers.acceleration.force-enabled", false)

// disable resistFingerprinting
user_pref("privacy.resistFingerprinting", false)

// disable letterboxing
user_pref("privacy.resistFingerprinting.letterboxing", false)

// enable mozAddonManager
user_pref("privacy.resistFingerprinting.block_mozAddonManager", false);

// do not disable asm.js
user_pref("javascript.options.asmjs", true)

// do not disable wasm
user_pref("javascript.options.wasm", true);

// do not disable WebGL
user_pref("webgl.disabled", false);
