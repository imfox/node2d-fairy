local display = {}
display.Node = require("node.modules.Node");
display.Drawable = require("fairy.core.display.DisplayObject");
display.Stage = require("fairy.core.display.Stage");

local event = {};
event.EventDispatcher = require("node.modules.EventDispatcher");
event.Event = require("fairy.core.event.Event");
event.TouchEvent = require("fairy.core.event.TouchEvent");

local utils = {};
utils.Utils = require("fairy.core.utils.Utils");
utils.Handler = require("node.modules.Handler");
utils.Pool = require("fairy.core.utils.Pool");

local ui = {};
ui.Image = require("fairy.ui.Image");

---@class Node_Core_Namespace
local namespace = {};
namespace.display = display;
namespace.event = event;
namespace.utils = utils;
namespace.ui = ui;

------------------------------------------
namespace.Node = display.Node;
namespace.Drawable = display.Drawable;
namespace.Stage = display.Stage;

namespace.EventDispatcher = event.EventDispatcher;
namespace.Event = event.Event;
namespace.TouchEvent = event.TouchEvent;

namespace.Utils = utils.Utils;
namespace.Handler = utils.Handler;
namespace.Pool = utils.Pool;

return namespace;


