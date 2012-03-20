import System.Information.CPU
import System.Information.Memory
import System.Taffybar
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.MPRIS
import System.Taffybar.SimpleClock
import System.Taffybar.Systray
import System.Taffybar.Weather
import System.Taffybar.Widgets.PollingGraph
import System.Taffybar.XMonadLog

cpuCallback = do
    (_, systemLoad, totalLoad) <- cpuLoad
    return [ totalLoad, systemLoad ]

memCallback = do
    mi <- parseMeminfo
    return [memoryUsedRatio mi]

main = do
    let log     = xmonadLogNew
        cpuCfg  = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1), (1, 0, 1, 0.5)]
                                     , graphPadding = 0
                                     }
        memCfg  = defaultGraphConfig { graphDataColors = [(1, 0, 0, 1)]
                                     , graphPadding = 0
                                     }
        wcfg    = (defaultWeatherConfig "EDSB") { weatherTemplate = "$tempC$°C" }

        note    = notifyAreaNew defaultNotificationConfig
        mpris   = mprisNew
        tray    = systrayNew
        cpu     = pollingGraphNew cpuCfg 1 cpuCallback
        mem     = pollingGraphNew memCfg 1 memCallback
        weather = weatherNew wcfg 30
        clock   = textClockNew Nothing "%a %b %_d %H:%M " 1

    defaultTaffybar defaultTaffybarConfig { startWidgets = [ log ]
                                          , endWidgets   = [ clock, weather, mem, cpu, tray, note ]
                                          , barHeight    = 20
                                          , barPosition  = Bottom
                                          }
