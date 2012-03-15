import Data.Monoid
import System.Exit
import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.Run
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

main = do
    barpipe <- spawnPipe "xmobar"
    xmonad $ defaults {
        logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn barpipe
        }
    } `additionalKeysP` myKeys

defaults = defaultConfig {
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
    logHook            = myLogHook,
    startupHook        = myStartupHook
}

myTerminal           = "urxvt"
myFocusFollowsMouse  :: Bool
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

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , manageDocks ]

myEventHook = docksEventHook

myLogHook = return ()

myStartupHook = do
    spawn "trayer --edge top --align right --widthtype request --heighttype pixel --height 6 --SetDockType true --SetPartialStrut true --transparent true --alpha 0 --tint 0x000000 --distance -1 --expand true"

myKeys = [("C-M1-l", spawn "xscreensaver-command -lock")]
