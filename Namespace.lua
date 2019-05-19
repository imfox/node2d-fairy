local display = {}
display.Node = require("node.modules.Node");
display.Drawable = require("fairy.core.display.DisplayObject");
display.Stage = require("fairy.core.display.Stage");

local event = {};
event.EventDispatcher = require("node.modules.EventDispatcher");
event.Event = require("fairy.core.event.Event");
event.TouchEvent = require("fairy.core.event.TouchEvent");
event.KeyEvent = require("fairy.core.event.KeyEvent");

local utils = {};
utils.Utils = require("fairy.core.utils.Utils");
utils.Handler = require("node.modules.Handler");
utils.Pool = require("fairy.core.utils.Pool");
utils.Timer = require("fairy.core.utils.Timer");
utils.Tween = require("fairy.core.utils.Tween");
utils.FontManager = require("fairy.core.utils.FontManager");

local net = {};
net.Loader = require("fairy.core.net.Loader");
net.LoaderManager = require("fairy.core.net.LoaderManager");

local ui = {};
ui.UIEvent = require("fairy.ui.event.UIEvent");
ui.Component = require("fairy.ui.Component");
ui.Box = require("fairy.ui.Box");
ui.Image = require("fairy.ui.Image");
ui.Button = require("fairy.ui.Button");
ui.Label = require("fairy.ui.Label");

---@class Node_Core_Namespace
local namespace = {};
namespace.display = display;
namespace.event = event;
namespace.utils = utils;
namespace.ui = ui;
namespace.net = net;

------------------------------------------
namespace.Node = display.Node;
namespace.Drawable = display.Drawable;
namespace.Stage = display.Stage;

namespace.EventDispatcher = event.EventDispatcher;
namespace.Event = event.Event;
namespace.TouchEvent = event.TouchEvent;
namespace.KeyEvent = event.KeyEvent

namespace.Utils = utils.Utils;
namespace.Handler = utils.Handler;
namespace.Pool = utils.Pool;
namespace.Loader = net.Loader;
namespace.LoaderManager = net.LoaderManager;
namespace.Timer = utils.Timer;
namespace.Tween = utils.Tween;

return namespace;


