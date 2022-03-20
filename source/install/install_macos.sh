#!/usr/bin/env bash
## Inspired :P in:
## - https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences ? Sharing)
#sudo scutil --set ComputerName "0x6D746873"
#sudo scutil --set HostName "0x6D746873"
#sudo scutil --set LocalHostName "0x6D746873"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "
# Set sidebar icon size to medium
sudo defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
# Increase window resize speed for Cocoa applications
sudo defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# Expand panels by default
sudo defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
sudo defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
sudo defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
sudo defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
# Save to disk (not to iCloud) by default
sudo defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# Disable the �Are you sure you want to open this application?� dialog
sudo defaults write com.apple.LaunchServices LSQuarantine -bool false
# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
sudo defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
# Disable automatic termination of inactive apps
sudo defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
# Disable the crash reporter
sudo defaults write com.apple.CrashReporter DialogType -string "none"
# Set Help Viewer windows to non-floating mode
sudo defaults write com.apple.helpviewer DevMode -bool true
# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
# Disable Notification Center and remove the menu bar icon
sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null
# Disable time machine
sudo defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################
# Trackpad: map bottom right corner to right-click
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
sudo defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
sudo defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
# Enable natural scrolling
sudo defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
sudo defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# Use scroll gesture with the Ctrl (^) modifier key to zoom
sudo defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
sudo defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
sudo defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
# Make keyboard saner...
sudo defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
sudo defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
sudo defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
sudo defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
sudo defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
sudo defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
sudo defaults write NSGlobalDomain KeyRepeat -int 1
sudo defaults write NSGlobalDomain InitialKeyRepeat -int 10
# Set language and text formats
sudo defaults write NSGlobalDomain AppleLanguages -array "en"
sudo defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
sudo defaults write NSGlobalDomain AppleMetricUnits -bool true
# Stop iTunes from responding to the keyboard media keys
sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

###############################################################################
# Energy saving                                                               #
###############################################################################
sudo pmset -a lidwake       1
sudo pmset -a autorestart   1
sudo pmset -a hibernatemode 0
sudo pmset -a sleep 		120
sudo pmset -a standbydelay 86400
# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on
# Charger
sudo pmset -c displaysleep 15
sudo pmset -c displaysleep 120
# Battery
sudo pmset -c displaysleep 5
sudo pmset -c sleep		   5


###############################################################################
# Screen                                                                      #
###############################################################################
# Require password immediately after sleep or screen saver begins
sudo defaults write com.apple.screensaver askForPassword      -int 1
sudo defaults write com.apple.screensaver askForPasswordDelay -int 0

# Screenshot
sudo defaults write com.apple.screencapture location -string "${HOME}/Desktop"
sudo defaults write com.apple.screencapture type -string "png"
sudo defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
sudo defaults write NSGlobalDomain AppleFontSmoothing -int 1
# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true


###############################################################################
# Finder                                                                      #
###############################################################################
# Finder: allow quitting via ? + Q; doing so will also hide desktop icons
sudo defaults write com.apple.finder QuitMenuItem -bool true
# Finder: disable window animations and Get Info animations
sudo defaults write com.apple.finder DisableAllAnimations -bool true
# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
sudo defaults write com.apple.finder NewWindowTarget -string "PfDe"
sudo defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"
# Show icons for hard drives, servers, and removable media on the desktop
sudo defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
sudo defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
sudo defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
sudo defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Make finder saner....
sudo defaults write com.apple.finder AppleShowAllFiles -bool true
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true
sudo defaults write com.apple.finder ShowStatusBar -bool true
sudo defaults write com.apple.finder ShowPathbar -bool false
sudo defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
sudo defaults write com.apple.finder _FXSortFoldersFirst -bool true
sudo defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
sudo defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
sudo defaults write com.apple.finder WarnOnEmptyTrash -bool false
sudo defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
sudo defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
sudo defaults write com.apple.frameworks.diskimages skip-verify -bool true
sudo defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
sudo defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# Automatically open a new Finder window when a volume is mounted
sudo defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
sudo defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
sudo defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
sudo defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Expand the following File Info panes:
# �General�, �Open with�, and �Sharing & Permissions�
sudo defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Enable spring loading for directories @???
## sudo defaults write NSGlobalDomain com.apple.springing.enabled -bool true
# Remove the spring loading delay for directories @???
## sudo defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Show the ~/Library /Volumes folder
chflags nohidden ~/Library
sudo chflags nohidden /Volumes


###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

## Make dock saner
sudo defaults write com.apple.dock launchanim -bool false
sudo defaults write com.apple.dock expose-animation-duration -float 0.1
sudo defaults write com.apple.dock autohide-delay -float 0
sudo defaults write com.apple.dock autohide-time-modifier -float 0
sudo defaults write com.apple.dock autohide -bool true
sudo defaults write com.apple.dock show-recents -bool false

# Enable highlight hover effect for the grid view of a stack (Dock)
sudo defaults write com.apple.dock mouse-over-hilite-stack -bool true
# Set the icon size of Dock items to 36 pixels
sudo defaults write com.apple.dock tilesize -int 36
# Change minimize/maximize window effect
sudo defaults write com.apple.dock mineffect -string "scale"
# Minimize windows into their application�s icon
sudo defaults write com.apple.dock minimize-to-application -bool true
# Show indicator lights for open applications in the Dock
sudo defaults write com.apple.dock show-process-indicators -bool true

# Don�t group windows by application in Mission Control
# (i.e. use the old Expos� behavior instead)
sudo defaults write com.apple.dock expose-group-by-app -bool false
# Disable Dashboard
sudo defaults write com.apple.dashboard mcx-disabled -bool true
# Don�t show Dashboard as a Space
sudo defaults write com.apple.dock dashboard-in-overlay -bool true
# Don�t automatically rearrange Spaces based on most recent use
sudo defaults write com.apple.dock mru-spaces -bool false
# Disable the Launchpad gesture (pinch with thumb and three fingers)
sudo defaults write com.apple.dock showLaunchpadGestureEnabled -int 0


###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don�t send search queries to Apple
sudo defaults write com.apple.Safari UniversalSearchEnabled    -bool false
sudo defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
sudo defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

sudo defaults write com.apple.Safari HomePage -string "about:blank"
sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
sudo defaults write com.apple.Safari ShowFavoritesBar -bool false
sudo defaults write com.apple.Safari ShowSidebarInTopSites -bool false
sudo defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
sudo defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
sudo defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
sudo defaults write com.apple.Safari ProxiesInBookmarksBar "()"
# Enable the Develop menu and the Web Inspector in Safari
sudo defaults write com.apple.Safari IncludeDevelopMenu -bool true
sudo defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# Add a context menu item for showing the Web Inspector in web views
sudo defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
# Warn about fraudulent websites
sudo defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
# Block pop-up windows
sudo defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

sudo defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
sudo defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true



###############################################################################
# Activity Monitor                                                            #
###############################################################################
# Show the main window when launching Activity Monitor
sudo defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
# Show all processes in Activity Monitor
sudo defaults write com.apple.ActivityMonitor ShowCategory -int 0
# Sort Activity Monitor results by CPU usage
sudo defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
sudo defaults write com.apple.ActivityMonitor SortDirection -int 0
