import Data.Maybe (fromJust)
import Data.Monoid
import Data.List (zipWith)
import GHC.IO.Handle.Types (Handle)
import System.Exit
import XMonad
import XMonad.Actions.UpdatePointer (updatePointer)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import qualified Data.Map        as M
import qualified XMonad.StackSet as W
import qualified Debug.Trace as T

myTerminal      = "konsole -e tmux"
myBorderWidth   = 1
myWorkspaces = [" www ", " dev ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

-- clickable :: [Char] -> String
-- clickable ws = do
  -- let idx = fromJust $ M.lookup ws myWorkspaceIndices
  -- T.trace ("indices: " ++ show myWorkspaceIndices ++ "; ws: " ++ show ws ++ "; idx: ") []
  -- return  "<action=xdotool key super+"++show i++">"++ws++"</action>"
  --  where i = fromJust $ M.lookup ws myWorkspaceIndices
  --
-- clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
--     where
--       i = do
--         T.trace ("indices: " ++ show myWorkspaceIndices ++ "; ws: " ++ show ws ++ "; idx: " ) []
--         return (fromJust $ M.lookup ws myWorkspaceIndices)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"
myBar = "xmobar"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask       = mod4Mask

-- Scratch Pads
scratchpads :: [NamedScratchpad]
scratchpads =
  [
    NS "authy" "authy" (className =? "Authy Desktop") (customFloating $ center 0.3 0.3),
    NS "blueberry" "blueberry" (className =? "Blueberry.py") (customFloating $ center 0.6 0.6),
    NS "htop" "konsole -name htop -e htop" (resource =? "htop") (customFloating $ center 0.6 0.6),
    NS "notion" "notion-app" (className =? "Notion") (customFloating $ center 0.9 0.9),
    NS "slack" "slack" (className =? "Slack") (customFloating $ center 0.6 0.6),
    NS "spotify" "spotify" (className =? "Spotify") (customFloating $ center 0.6 0.6),
    NS "terminal" "konsole -name terminal" (resource =? "terminal") (customFloating $ center 0.6 0.6),
    NS "todo" "todoist" (className =? "Todoist") (customFloating $ center 0.6 0.6)
  ]
  where center w h = W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
-- myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
myKeys = \conf -> mkKeymap conf $
    [
        ("<Print>",                spawn "deepin-screen-recorder"),
        ("<XF86AudioLowerVolume>", spawn "amixer -D pulse sset Master 1%- unmute"),
        ("<XF86AudioMute>",        spawn "amixer -D pulse sset Master toggle"),
        ("<XF86AudioNext>",        spawn "playerctl next"),
        ("<XF86AudioPlay>",        spawn "playerctl play-pause"),
        ("<XF86AudioPrev>",        spawn "playerctl previous"),
        ("<XF86AudioRaiseVolume>", spawn "amixer -D pulse sset Master 1%+ unmute"),
        ("<XF86AudioStop>",        spawn "playerctl stop"),
        ("M-,",                    sendMessage (IncMasterN 1)),
        ("M-.",                    sendMessage (IncMasterN (-1))),
        ("M-<F10>",                spawn "launch_redshift --manual 2000"),
        ("M-<F11>",                spawn "launch_redshift --auto 6500:2500"),
        ("M-<F12>",                spawn "launch_redshift --kill"),
        ("M-<Print>",              spawn "peek"),
        ("M-<Return>",             windows W.swapMaster),
        ("M-<Space>",              sendMessage NextLayout),
        ("M-<Tab>",                windows W.focusDown),
        ("M-S-<Return>",           spawn $ XMonad.terminal conf),
        ("M-S-<Space>",            setLayout $ XMonad.layoutHook conf), -- reset layout
        ("M-S-M1-q",                io (exitWith ExitSuccess)), -- quit xmonad
        ("M-S-a",                  namedScratchpadAction scratchpads "authy"),
        ("M-S-b",                  namedScratchpadAction scratchpads "blueberry"),
        ("M-S-c",                  kill),
        ("M-S-d",                  spawn "dmenu_run"), -- app launcher
        ("M-S-f",                  spawn  "dolphin"), -- file explorer
        ("M-S-h",                  namedScratchpadAction scratchpads "htop"),
        ("M-S-j",                  windows W.swapUp),
        ("M-S-k",                  windows W.swapDown),
        ("M-S-m",                  namedScratchpadAction scratchpads "spotify"),
        ("M-S-n",                  namedScratchpadAction scratchpads "notion"),
        ("M-S-p",                  spawn "gmrun"),
        ("M-S-q",                  kill),
        ("M-S-s",                  namedScratchpadAction scratchpads "slack"),
        ("M-S-t",                  namedScratchpadAction scratchpads "todo"),
        ("M-S-x",                  spawn "dm-tool lock"), -- lockscreen
        ("M-S-y",                  namedScratchpadAction scratchpads "terminal"),
        ("M-b",                    sendMessage ToggleStruts),
        ("M-d",                    spawn "albert show"),
        ("M-h",                    sendMessage Shrink),
        ("M-j",                    windows W.focusDown),
        ("M-k",                    windows W.focusUp),
        ("M-l",                    sendMessage Expand),
        ("M-m",                    windows W.focusMaster),
        ("M-n",                    refresh), -- resize windows to correct size
        ("M-q",                    spawn "pkill xmobar; xmonad --recompile; xmonad --restart"),
        ("M-t",                    withFocused $ windows . W.sink) -- put back into tiling
    ]
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [(m ++ k, windows $ f w)
      | (w, k) <- zip (XMonad.workspaces conf) (map show [1..9])
      , (m, f) <- [("M-",W.view), ("M-S-",W.shift)]] -- was W.greedyView
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [(m ++ "M-" ++ [k], screenWorkspace sc >>= flip whenJust (windows . f))
      | (k, sc) <- zip "wer" [1,2,0]
      , (f, m) <- [(W.view, ""), (W.shift, "S-")]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts(tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 3/4
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

manageCompositions = composeAll
    [
        className =? "Peek"           --> doFloat
    ]
manageScratchPads = namedScratchpadManageHook scratchpads

myManageHook :: ManageHook
myManageHook = def
    <+>      manageCompositions
    <+>      manageScratchPads

myEventHook = mempty
myStartupHook = return ()

main :: IO ()
main = do
  nitroproniroprocc <- spawnPipe "nitrogen --restore"
  xmobarproc0        <- spawnPipe "xmobar -x 0 -d"
  xmobarproc1        <- spawnPipe "xmobar -x 1 -d"
  comptonproc       <- spawnPipe "compton"
  redproc           <- spawnPipe "launch_redshift --auto 6500:2500"
  volumeproc        <- spawnPipe "launch_volumecontrol"
  albertproc        <- spawnPipe "albert"
  trayproc          <- spawnPipe "launch_trayer"
  ov                <- spawnPipe "launch_overrides"
  kbd               <- spawnPipe "setxkbmap lv -variant apostrophe"
  num               <- spawnPipe "enable-numlock-if-var"
  xmonad $ mkConfig xmobarproc0 xmobarproc1

mkConfig xmobarHandle0 xmobarHandle1 = docks def {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = mkLogHook xmobarHandle0 <+> mkLogHook xmobarHandle1,
        startupHook        = myStartupHook
    }

mkLogHook :: Handle -> X ()
mkLogHook h =
  let noScratchpad ws = if ws == "NSP" then "" else ws
      pp = xmobarPP
            {
              ppOutput          = hPutStrLn h,
              ppCurrent         = xmobarColor "#98be65" "" . wrap "[" "]",           -- Current workspace
              ppVisible         = xmobarColor "#98be65" "" . clickable,              -- Visible but not current workspace
              ppHidden          = xmobarColor "#82AAFF" "" . wrap "*" "" . clickable, -- Hidden workspaces
              ppHiddenNoWindows = xmobarColor "#c792ea" ""  . clickable,     -- Hidden workspaces (no windows)
              ppTitle           = xmobarColor "#b3afc2" "" . shorten 60,               -- Title of active window
              ppSep             =  "<fc=#666666> <fn=1>|</fn> </fc>",                    -- Separator character
              ppUrgent          = xmobarColor "#C45500" "" . wrap "!" "!",            -- Urgent workspace
              ppExtras          = [windowCount],                                     -- # of windows current workspace
              ppOrder           = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
            }
  in  do
        dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ pp
        updatePointer (0.5, 0.5) (0, 0)
