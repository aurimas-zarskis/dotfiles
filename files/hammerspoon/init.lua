hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("RecursiveBinder")

spoon.RecursiveBinder.escapeKey = {{}, "escape"}

local singleKey = spoon.RecursiveBinder.singleKey

local keyMap = {
  [singleKey("a", "Android Studio")] = function() hs.application.launchOrFocus("Android Studio Preview Beta") end,
  [singleKey("b", "Browser")] = function() hs.application.launchOrFocus("Brave Browser") end,
  [singleKey("t", "Terminal")] = function() hs.application.launchOrFocus("Ghostty") end,
  [singleKey("s", "Slack")] = function() hs.application.launchOrFocus("Slack") end,
  [singleKey("h", "Hammerspoon+")] = {
    [singleKey("r", "Relod")] = function() hs.reload() hs.console.clearConsole() end,
  }
}

hs.hotkey.bind({"ctrl"}, "space", spoon.RecursiveBinder.recursiveBind(keyMap))
