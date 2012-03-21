import Data.Monoid
import DBus.Client.Simple
import System.Exit
import System.IO
import System.Taffybar.XMonadLog
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders
import XMonad.Util.Run
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

main = do
    -- barpipe <- spawnPipe statusbar
    client <- connectSession
    xmonad $ withUrgencyHook NoUrgencyHook
           $ defaultConfig {
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
        logHook            = myLogHook client,
        startupHook        = myStartupHook
    } `additionalKeysP` myKeys


myTerminal           = "urxvt"
myFocusFollowsMouse  = False
myBorderWidth        = 2
myModMask            = mod4Mask
myWorkspaces         = ["1","2","3","4","5","6","7","8","9"]
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
myLogHook target = dbusLogWithPP target $ taffybarPP
    { ppCurrent         = taffybarColor "#000000" "#f0b050" . pad
    , ppHidden          = taffybarColor "#000000" "" . pad
    , ppHiddenNoWindows = taffybarColor "#c0c0c0" "" . pad
    , ppUrgent          = taffybarColor "#000000" "#ff0000" . pad
    , ppVisible         = wrap "(" ")"
    , ppTitle           = shorten 60
    , ppSep             = " :: "
    , ppWsSep           = ""
    }

myStartupHook = do
    setWMName "LG3D"
--    spawn "trayer --edge bottom --align right --widthtype pixel --width 100 --heighttype pixel --height 19 --SetDockType true --SetPartialStrut true --transparent true --alpha 0 --tint 0xe0e0e0 --distance -1 --expand true"
    spawn "taffybar"

home       = "/home/mfischer"
screenlock = "xscreensaver-command -lock"
consolekit = "dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager."
upower     = "dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower."
dmenu      = "dmenu_run -fn 'xft:Sans:size=8' -nb '#e0e0e0' -nf '#000000' -sb '#f0b050' -sf '#000000'"

myKeys = [("M-p",                       spawn (dmenu))
         ,("M-u",                       focusUrgent)
         ,("M-S-u",                     clearUrgents)
         ,("C-M1-l",                    spawn (screenlock))
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

