import Data.Monoid
import System.Exit
import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Util.Run
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

main = do
    barpipe <- spawnPipe statusbar
    xmonad $ defaultConfig {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        layoutHook         = avoidStruts $ smartBorders $ myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook barpipe,
        startupHook        = myStartupHook
    } `additionalKeysP` myKeys


myTerminal           = "urxvt"
myFocusFollowsMouse  = False
myBorderWidth        = 2
myModMask            = mod4Mask
myWorkspaces         = ["1:web","2:shell","3:code","4","5","6","7","8:media","9:chat"]
myNormalBorderColor  = "#e0e0e0"
myFocusedBorderColor = "#f0b050"

myLayout = tiled ||| Mirror tiled ||| noBorders Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100

myManageHook = composeOne
    [ className =? "MPlayer"        -?> doFloat
    , className =? "Gimp"           -?> doFloat
    , resource  =? "desktop_window" -?> doIgnore
    , resource  =? "kdesktop"       -?> doIgnore
    , isFullscreen                  -?> doFullFloat
    ] <+> manageDocks

myEventHook = docksEventHook

statusbar = "xmobar"
myLogHook barpipe = dynamicLogWithPP $ xmobarPP
    { ppOutput  = hPutStrLn barpipe
    }

myStartupHook = do
    spawn "trayer --edge top --align right --widthtype request --heighttype pixel --height 6 --SetDockType true --SetPartialStrut true --transparent true --alpha 0 --tint 0x000000 --distance -1 --expand true"

home       = "/home/mfischer"
screenlock = "xscreensaver-command -lock"
consolekit = "dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager."
upower     = "dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower."

myKeys = [("C-M1-l",                    spawn (screenlock))
         ,("C-S-M1-l",                  spawn (screenlock))
         ,("C-S-M1-h",                  spawn (consolekit ++ "Stop"))
         ,("C-S-M1-r",                  spawn (consolekit ++ "Restart"))
         ,("C-S-M1-s",                  spawn (upower ++ "Suspend" ++ " & " ++ screenlock))
         ,("C-S-M1-d",                  spawn (upower ++ "Hibernate" ++ " & " ++ screenlock))
         ,("<XF86Sleep>",               spawn (upower ++ "Suspend" ++ " & " ++ screenlock))
         ,("<XF86Suspend>",             spawn (upower ++ "Hibernate" ++ " & " ++ screenlock))
         ,("M-=",                       spawn (home ++ "/bin/volume.sh up"))
         ,("M--",                       spawn (home ++ "/bin/volume.sh down"))
         ,("M-0",                       spawn (home ++ "/bin/volume.sh mute"))
         ,("<XF86AudioRaiseVolume>",    spawn (home ++ "/bin/volume.sh up"))
         ,("<XF86AudioLowerVolume>",    spawn (home ++ "/bin/volume.sh down"))
         ,("<XF86AudioMute>",           spawn (home ++ "/bin/volume.sh mute"))
         ,("M-<F7>",                    spawn (home ++ "/bin/media.sh prev"))
         ,("M-<F8>",                    spawn (home ++ "/bin/media.sh next"))
         ,("M-<F9>",                    spawn (home ++ "/bin/media.sh toggle_play"))
         ,("M-<F10>",                   spawn (home ++ "/bin/media.sh toggle"))
         ,("M-<F11>",                   spawn (home ++ "/bin/media.sh volume_down"))
         ,("M-<F12>",                   spawn (home ++ "/bin/media.sh volume_up"))
         ,("<XF86AudioPrev>",           spawn (home ++ "/bin/media.sh prev"))
         ,("<XF86AudioNext>",           spawn (home ++ "/bin/media.sh next"))
         ,("<XF86AudioPlay>",           spawn (home ++ "/bin/media.sh toggle_play"))
         ,("M-<XF86AudioRaiseVolume>",  spawn (home ++ "/bin/media.sh volume_up"))
         ,("M-<XF86AudioLowerVolume>",  spawn (home ++ "/bin/media.sh volume_down"))
         ,("M-<XF86AudioMute>",         spawn (home ++ "/bin/volume.sh mute"))
         ]

