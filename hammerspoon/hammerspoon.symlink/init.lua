hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0
hs.logger.defaultLogLevel = "info"

hyper = {"cmd", "alt", "shift", "ctrl"}
meh = {"alt", "shift", "ctrl"}

hs.loadSpoon("SpoonInstall")

Install=spoon.SpoonInstall
Install:andUse("WindowGrid", {
    config = { gridGeometries = { { "10x3" } } },
    hotkeys = { show_grid = {{"alt"}, "g"} },
    start = true
})
Install:andUse("WindowScreenLeftAndRight", {
    hotkeys = {
        screen_left  = { hyper, "[" },
        screen_right = { hyper, "]" },
    }
})
Install:andUse("WinWin")
Install:andUse("CountDown")
Install:andUse("DismissNotifications", {
    hotkeys = {
        all = {hyper, "'"}
    }
})
Install:andUse("FadeLogo", {
    config = {
        default_run = 1.0,
    },
    start = true
})
Install:andUse("Caffeine", {
    start   = true,
    hotkeys = { toggle = { hyper, "1" } },
})
Install:andUse("Keychain")
Install:andUse("Token", {
    hotkeys = {
        generate = { {"alt", "ctrl"} , "h"}
    },
    config = { secret_key = "token_tunnel" }})
Install:andUse("MoveSpaces", {
    hotkeys = {
        space_right = { {'ctrl','shift'}, '.' },
        space_left  =  { {'ctrl','shift'}, ',' }
    }
})
Install:andUse("Reload", {
    hotkeys = { reload = {{"cmd", "shift", "ctrl"}, "R"} }
})
Install:andUse("Pastebin", {
    config = {
        api_dev_key  = spoon.Keychain:login_keychain("pastebin_dev_key"),
        api_user_key = spoon.Keychain:login_keychain("pastebin_user_key")
    },
    loglevel = "debug"
})
Install:andUse("Seal", {
    hotkeys = { show = { {"cmd"}, "space" } },
    fn = function(s)
        s:loadPlugins({"apps", "calc", "screencapture", "useractions"})
        s.plugins.useractions.actions =
            {
            ["Hammerspoon docs webpage"] = {
                url = "http://hammerspoon.org/docs/",
                icon = hs.image.imageFromName(hs.image.systemImageNames.ApplicationIcon),
                }
            }
        s:refreshAllCommands()
    end,
    start = true,
})

Install:andUse("RecursiveBinder", {
    fn = function(s)
        -- Curried function so it isn't called immediately
        id = function(id) return function () hs.application.launchOrFocusByBundleID(id) end end

        -- Get bundle with: osascript -e 'id of app "Zoom.us"'
        app_keymap = {
            [s.singleKey('k', 'Slack')] = id('com.tinyspeck.slackmacgap'),
            [s.singleKey('d', 'Fantastical')] = id('com.flexibits.fantastical2.mac'),
            [s.singleKey('c', 'Chrome')] = id('com.google.Chrome'),
            [s.singleKey('f', 'Firefox')] = id('org.mozilla.firefox'),
            [s.singleKey('i', 'iTerm')] = id('com.googlecode.iterm2'),
            [s.singleKey('l', 'Sublime Text')] = id('com.sublimetext.3'),
            [s.singleKey('m', 'Messages')] = id('com.apple.iChat'),
            [s.singleKey('s', 'Spotify')] = id('com.spotify.client'),
            [s.singleKey('j', 'IDEA')] = id('com.jetbrains.intellij'),
            [s.singleKey('p', 'Postman')] = id('com.postmanlabs.mac'),
            [s.singleKey('v', 'Zoom')] = id('us.zoom.xos'),
            [s.singleKey('n', 'Notion')] = id('notion.id'),
        }
        hs.hotkey.bind('alt', 'a', s.recursiveBind(app_keymap))

        resize_keymap = {
            [s.singleKey('f', 'fullscreen')] = function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("fullscreen") end,
            [s.singleKey('h', 'Lefthalf of Screen')] = function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfleft") end,
            [s.singleKey('l', 'Righthalf of Screen')] = function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfright") end,
        }
        hs.hotkey.bind('alt', 'r', s.recursiveBind(resize_keymap))

        tools_keymap = {
            [s.singleKey('f', 'file visible')] = function() hs.eventtap.keyStroke({'cmd', 'shift'}, '.') end,
            [s.singleKey('h', 'hammerspoon console')] = function() hs.toggleConsole() end,
            [s.singleKey('v', 'paste unblocker')] = function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end,
            [s.singleKey('s', 'spotify song')] = function() hs.spotify.displayCurrentTrack() end,
            [s.singleKey('p', 'pastebin')] = function() spoon.Pastebin:paste() end,
            [s.singleKey('u', 'trigger notification')] = function() hs.notify.new({title = 'Break Time', informativeText = "TAKE A BREAK!!!", autoWithdraw = false, withdrawAfter = 0}):send() end,
            [s.singleKey('n', 'notifications')] = {
                [s.singleKey('a', 'dismiss all')] = function() 
                hs.osascript.applescript(
                    string.format(
                    [[
                    tell application "System Events" to tell process "Notification Center"
                        click button 1 in every window
                    end tell
                    ]]
                    )
                )
                end,
                [s.singleKey('s', 'click secondary')] = function()
                    hs.osascript.applescript(
                        string.format(
                            [[
                            tell application "System Events" to tell process "Notification Center"
                                try
                                    click button 2 of last item of windows
                                end try
                            end tell
                        ]]
                        )
                    )
                end
            }
        }
        hs.hotkey.bind('alt', 't', s.recursiveBind(tools_keymap))
        
        bookmarks_keymap = {}
        hs.hotkey.bind('alt', 'b', s.recursiveBind(bookmarks_keymap))

        keymap = {
            [s.singleKey('b')] = bookmarks_keymap,
            [s.singleKey('q', 'find+')] = {
                [s.singleKey('D', 'Desktop')] = function() openWithFinder('~/Desktop') end,
                [s.singleKey('p', 'Project')] = function() openWithFinder('~/p') end,
                [s.singleKey('d', 'Download')] = function() openWithFinder('~/Downloads') end,
                [s.singleKey('a', 'Application')] = function() openWithFinder('~/Applications') end,
                [s.singleKey('h', 'home')] = function() openWithFinder('~') end,
                [s.singleKey('f', 'hello')] = function() hs.alert.show('hello!') end
            },
            [s.singleKey('t', 'tools+')] = tools_keymap,
            [s.singleKey('a', 'apps+')] = app_keymap,
            [s.singleKey('r', 'resize+')] = resize_keymap,
        }

        hs.hotkey.bind('alt', 'f', s.recursiveBind(keymap))
    end
})

hs.hotkey.bindSpec({"alt", "h"}, 'Show Window Hints', function() hs.hints.windowHints() end)

-- Timer
hs.hotkey.bindSpec({"alt", "w"}, 'Show Window Hints', function() spoon.CountDown:startFor(25) end)
hs.hotkey.bindSpec({"alt", "1"}, 'Show Window Hints', function() spoon.CountDown:startFor(1) end)
hs.hotkey.bindSpec({"alt", "5"}, 'Show Window Hints', function() spoon.CountDown:startFor(5) end)
hs.hotkey.bindSpec({"alt", "q"}, 'Show Window Hints', function() spoon.CountDown:startFor(5) end)
hs.hotkey.bindSpec({"alt", "2"}, 'Show Window Hints', function() spoon.CountDown:startFor(20) end)
hs.hotkey.bindSpec({"alt", "e"}, 'Show Window Hints', function() spoon.CountDown:pauseOrResume() end)
hs.hotkey.bindSpec({"alt", "s"}, 'Show Window Hints', function() spoon.CountDown:showRemaining() end)

spaces = require("hs._asm.undocumented.spaces")
spotify_watcher = hs.application.watcher.new(function(app_name, event_type, app)
    if (app_name == 'Spotify' and hs.application.watcher.launched == event_type) then
        local win = app:mainWindow()
        if win ~= nil then
            local currentSpace = spaces.activeSpace()
            win:setFullScreen(true)
            repeat until win:isFullScreen()
            -- timer = hs.timer.delayed.new(2, function()  end)
            -- timer:start()
            spaces.changeToSpace(currentSpace)
        end

    end

end)
-- spotify_watcher:start()

