// Enable hardware video acceleration via VAAPI
user_pref ("media.ffmpeg.vaapi.enabled", true);

// Improve the rendering performance by enabling Webrender
user_pref ("gfx.webrender.all", true);
user_pref ("gfx.webrender.compositor.force-enabled", true);

// For KDE: disable the media entry from Firefox, use the one from the Plasma
// browser integration plugin.
user_pref ("media.hardwaremediakeys.enabled", false);

// Scrolling -------------------------------------------------------------------

// Smooth scroll.
user_pref ("general.smoothScroll", true);
user_pref ("general.smoothScroll.lines.durationMaxMS", 125);
user_pref ("general.smoothScroll.lines.durationMinMS", 125);
user_pref ("general.smoothScroll.mouseWheel.durationMaxMS", 200);
user_pref ("general.smoothScroll.mouseWheel.durationMinMS", 100);
user_pref ("general.smoothScroll.msdPhysics.enabled", true);
user_pref ("general.smoothScroll.other.durationMaxMS", 125);
user_pref ("general.smoothScroll.other.durationMinMS", 125);
user_pref ("general.smoothScroll.pages.durationMaxMS", 125);
user_pref ("general.smoothScroll.pages.durationMinMS", 125);

// Smooth mousewheel scroll.
user_pref ("mousewheel.min_line_scroll_amount", 30);
user_pref ("mousewheel.system_scroll_override_on_root_content.enabled", true);
user_pref ("mousewheel.system_scroll_override_on_root_content.horizontal.factor", 175);
user_pref ("mousewheel.system_scroll_override_on_root_content.vertical.factor", 175);
user_pref ("toolkit.scrollbox.horizontalScrollDistance", 6);
user_pref ("toolkit.scrollbox.verticalScrollDistance", 2);

// Privacy ---------------------------------------------------------------------

// Enable plugins on Mozilla's sites.
user_pref ("extensions.webextensions.restrictedDomains", "");

// Disable domain guessing.
user_pref ("browser.fixup.alternate.enabled", false);

// Disable Normandy/Shield.
user_pref ("app.normandy.enabled", false);
user_pref ("app.shield.optoutstudies.enabled", false);

// Disable experiments.
user_pref ("messaging-system.rsexperimentloader.enabled", false);

// Disable activity stream (AS).
user_pref ("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref ("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref ("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref ("browser.newtabpage.activity-stream.feeds.system.topsites", false);
user_pref ("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref ("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref ("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref ("browser.newtabpage.activity-stream.showSponsored", false);
user_pref ("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref ("browser.newtabpage.activity-stream.telemetry", false);

// Disable ping centre telemetry.
user_pref ("browser.ping-centre.telemetry", false);

// Disable "What's new" in the new tab page.
user_pref ("browser.messaging-system.whatsNewPanel.enabled", false);

// Disable Safe Browsing.
user_pref ("browser.safebrowsing.blockedURIs.enabled", false);
user_pref ("browser.safebrowsing.downloads.enabled", false);
user_pref ("browser.safebrowsing.downloads.remote.block_dangerous", false);
user_pref ("browser.safebrowsing.downloads.remote.block_dangerous_host", false);
user_pref ("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref ("browser.safebrowsing.downloads.remote.block_uncommon", false);
user_pref ("browser.safebrowsing.downloads.remote.enabled", false);
user_pref ("browser.safebrowsing.downloads.remote.url", "");
user_pref ("browser.safebrowsing.malware.enabled", false);
user_pref ("browser.safebrowsing.phishing.enabled", false);
user_pref ("browser.safebrowsing.provider.google4.dataSharing.enabled", false);
user_pref ("browser.safebrowsing.provider.google4.dataSharingURL", "");
user_pref ("browser.safebrowsing.provider.google4.reportMalwareMistakeURL", "");
user_pref ("browser.safebrowsing.provider.google4.reportPhishMistakeURL", "");
user_pref ("browser.safebrowsing.provider.google4.reportURL", "");
user_pref ("browser.safebrowsing.provider.google.reportMalwareMistakeURL", "");
user_pref ("browser.safebrowsing.provider.google.reportPhishMistakeURL", "");
user_pref ("browser.safebrowsing.provider.google.reportURL", "");
user_pref ("browser.safebrowsing.reportPhishURL", "");

// Disable live search suggestions.
user_pref ("browser.search.suggest.enabled", false);
user_pref ("browser.urlbar.suggest.searches", false);

// Disable slow startup notifications.
user_pref ("browser.slowStartup.maxSamples", 0);
user_pref ("browser.slowStartup.notificationDisabled", true);
user_pref ("browser.slowStartup.samples", 0);

// Disable sending of crash reports.
user_pref ("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref ("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref ("browser.tabs.crashReporting.sendReport", false);

// Disable health report.
user_pref ("datareporting.healthreport.uploadEnabled", false);
user_pref ("datareporting.policy.dataSubmissionEnabled", false);

// Disable extension metadata updating to addons.mozilla.org.
user_pref ("extensions.getAddons.cache.enabled", false);

// Disable telemetry.
user_pref ("toolkit.coverage.endpoint.base", "");
user_pref ("toolkit.coverage.opt-out", true);
user_pref ("toolkit.telemetry.archive.enabled", false);
user_pref ("toolkit.telemetry.coverage.opt-out", true);
user_pref ("toolkit.telemetry.hybridContent.enabled", false);
user_pref ("toolkit.telemetry.bhrPing.enabled", false);
user_pref ("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref ("toolkit.telemetry.newProfilePing.enabled", false);
user_pref ("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref ("toolkit.telemetry.updatePing.enabled", false);
user_pref ("toolkit.telemetry.unified", false);

// Disable geo localization.
user_pref ("geo.enabled", false);

// Disable Firefox location tracking.
user_pref ("browser.region.update.enabled", false);
user_pref ("browser.region.network.url", "");

// Deactivate tracking protection and the 'Do not track' header. Ironically, it
// may be used for tracking (https://www.privacy-handbuch.de/handbuch_21i.htm).
user_pref ("privacy.trackingprotection.enabled", true);
user_pref ("privacy.donottrackheader.enabled", false);

// Activate the total cookie protection.  Since v86, this technique is favored
// over first-party isolation: https://www.privacy-handbuch.de/handbuch_21z.htm.
user_pref ("network.cookie.cookieBehavior", 5);

// Block the sending of the referer to third-party sites.  This is better hanled
// by the Smart Referer plugin, which allows for whitelisting.
//user_pref ("network.http.referer.XOriginPolicy", 2);

// Use US as locale in javascript.
user_pref ("javascript.use_us_english_locale", true);

// Disable Pocket, screenshots.
user_pref ("extensions.pocket.enabled", false);
user_pref ("extensions.screenshots.disabled", true);

// Security --------------------------------------------------------------------

// Enforce punycode for internationalized domain names to eliminate possible
// spoofing.
user_pref ("network.IDN_show_punycode", true);

// Display all parts of the URL in the location bar eg. http(s)://.
user_pref ("browser.urlbar.trimURLs", false);

// Display "insecure" icon and "Not Secure" text on insecure HTTP connections.
user_pref ("security.insecure_connection_icon.enabled", true);
user_pref ("security.insecure_connection_icon.pbmode.enabled", true);
user_pref ("security.insecure_connection_text.enabled", true);
user_pref ("security.insecure_connection_text.pbmode.enabled", true);

// Operate in HTTPS-only mode.
user_pref ("dom.security.https_only_mode", true);

// Download mixed content via HTTPS.
user_pref ("security.mixed_content.upgrade_display_content", true);
