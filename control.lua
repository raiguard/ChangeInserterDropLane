do
  -- Don't load if sim scenario has already loaded this (in another lua state)
  local modloader = remote.interfaces["modloader"]
  if modloader and modloader[script.mod_name] then
    return
  end
end

local flib_gui = require("__flib__/gui-lite")
local flib_math = require("__flib__/math")
local flib_position = require("__flib__/position")

local inserter_drop_vectors = {
  [true] = { [0] = { 0.01, -0.2 }, [2] = { 0.2, 0.01 }, [4] = { -0.01, 0.2 }, [6] = { -0.2, -0.01 } }, -- Near lane
  [false] = { [0] = { 0.0, 0.2 }, [2] = { -0.2, 0.0 }, [4] = { 0.0, -0.2 }, [6] = { 0.2, 0.0 } }, -- Far lane
}

--- @param entity LuaEntity
local function is_compatible(entity)
  return entity.prototype.allow_custom_vectors and not string.find(entity.name, "%-?miniloader%-inserter")
end

--- @param entity LuaEntity
local function get_is_far(entity)
  local drop_pos_vector = flib_position.sub(entity.drop_position, entity.position)
  local vector_length = flib_math.sqrt(drop_pos_vector.x * drop_pos_vector.x + drop_pos_vector.y * drop_pos_vector.y)
  return vector_length % 1 < 0.5, drop_pos_vector
end

--- @param entity LuaEntity
--- @param is_far boolean
local function change_mode_fx(entity, is_far)
  -- Flying text
  entity.surface.create_entity({
    type = "flying-text",
    name = "flying-text",
    position = entity.position,
    text = is_far and { "message.cidl-drop-far" } or { "message.cidl-drop-near" },
    color = { r = 1, g = 0.5, b = 0.25 },
  })
  -- Welding sound
  game.play_sound({
    path = "cidl-welding",
    position = entity.position,
    volume_modifier = 1.0,
  })
  -- Welding particle
  entity.surface.create_particle({
    name = "cidl-welding",
    position = { entity.position.x, entity.position.y + 1 },
    movement = { 0.0, -0.05 },
    height = 1.0,
    vertical_speed = 0.015,
    frame_speed = 1,
  })
end

--- @param player LuaPlayer
--- @param entity LuaEntity
local function change_lane(player, entity)
  if not entity.prototype.allow_custom_vectors then
    player.create_local_flying_text({
      text = { "message.cidl-cannot-change-drop-lane" },
      create_at_cursor = true,
    })
    player.play_sound({ path = "utility/cannot_build" })
    return
  end

  -- Change lane
  local is_far, drop_pos_vector = get_is_far(entity)
  local dpf = inserter_drop_vectors[is_far][entity.direction]
  entity.drop_position = {
    entity.position.x + flib_math.round(drop_pos_vector.x) + dpf[1],
    entity.position.y + flib_math.round(drop_pos_vector.y) + dpf[2],
  }

  -- Special effects
  change_mode_fx(entity, not is_far)
end

--- @param e EventData.on_gui_switch_state_changed
local function on_droplane_switch_state_changed(e)
  local player = game.get_player(e.player_index)
  if not player or player.opened_gui_type ~= defines.gui_type.entity then
    return
  end
  local entity = player.opened --[[@as LuaEntity?]]
  if not entity or not is_compatible(entity) then
    return
  end
  change_lane(player, entity)
  e.element.switch_state = get_is_far(entity) and "right" or "left"
end

--- @param player LuaPlayer
--- @param entity LuaEntity
local function create_gui(player, entity)
  local window = player.gui.relative.cidl_window
  if window then
    window.destroy()
  end
  flib_gui.add(player.gui.relative, {
    type = "frame",
    name = "cidl_window",
    caption = { "gui.cidl-drop-lane" },
    anchor = {
      gui = defines.relative_gui_type.inserter_gui,
      position = defines.relative_gui_position.right,
    },
    {
      type = "frame",
      style = "inside_shallow_frame_with_padding",
      {
        type = "switch",
        left_label_caption = { "gui.cidl-near" },
        right_label_caption = { "gui.cidl-far" },
        switch_state = get_is_far(entity) and "right" or "left",
        handler = {
          [defines.events.on_gui_switch_state_changed] = on_droplane_switch_state_changed,
        },
      },
    },
  })
end

--- @param e EventData.CustomInputEvent
local function on_change_lane(e)
  local player = game.get_player(e.player_index)
  if not player then
    return
  end
  local entity = player.selected
  if not entity then
    return
  end
  if not player.can_reach_entity(entity) then
    player.create_local_flying_text({
      text = { "cant-reach" },
      create_at_cursor = true,
    })
    player.play_sound({ path = "utility/cannot_build" })
    return
  end
  change_lane(player, entity)
end

--- @param e EventData.on_pre_entity_settings_pasted
local function on_pre_entity_settings_pasted(e)
  local source, destination = e.source, e.destination
  if not source.valid or not destination.valid then
    return
  end
  if source.type ~= "inserter" or destination.type ~= "inserter" then
    return
  end
  if not destination.prototype.allow_custom_vectors then
    return
  end
  global.temp_inserter_settings[destination.unit_number] = {
    drop_position = destination.drop_position,
    pickup_position = destination.pickup_position,
  }
end

--- @param e EventData.on_entity_settings_pasted
local function on_entity_settings_pasted(e)
  local source, destination = e.source, e.destination
  if not source.valid or not destination.valid then
    return
  end
  if source.type ~= "inserter" or destination.type ~= "inserter" then
    return
  end
  if not destination.prototype.allow_custom_vectors then
    return
  end

  local destination_unit_number = destination.unit_number --[[@as uint]]
  local temp_settings = global.temp_inserter_settings[destination_unit_number]
  if not temp_settings then
    return
  end
  global.temp_inserter_settings[destination_unit_number] = nil

  destination.drop_position = temp_settings.drop_position
  destination.pickup_position = temp_settings.pickup_position

  local player = game.get_player(e.player_index)
  if not player then
    return
  end
  local destination_is_far = get_is_far(destination)
  if destination_is_far ~= get_is_far(source) then
    change_lane(player, destination)
  end
end

--- @param e EventData.on_gui_opened
local function on_gui_opened(e)
  local player = game.get_player(e.player_index)
  if not player then
    return
  end
  if player.opened_gui_type ~= defines.gui_type.entity then
    return
  end
  local entity = player.opened --[[@as LuaEntity?]]
  if not entity or not is_compatible(entity) then
    return
  end
  create_gui(player, entity)
end

--- @class InserterSettings
--- @field drop_position MapPosition
--- @field pickup_position MapPosition

local function on_init()
  --- @type table<uint, InserterSettings?>
  global.temp_inserter_settings = {}
end

flib_gui.add_handlers({ on_droplane_switch_state_changed = on_droplane_switch_state_changed })
flib_gui.handle_events()

script.on_init(on_init)
script.on_configuration_changed(on_init)
script.on_event("cidl-change-lane", on_change_lane)
script.on_event(defines.events.on_gui_opened, on_gui_opened)
script.on_event(defines.events.on_pre_entity_settings_pasted, on_pre_entity_settings_pasted)
script.on_event(defines.events.on_entity_settings_pasted, on_entity_settings_pasted)

-- For simulations
remote.add_interface("ChangeInserterDropLane_simulation", {
  --- @param player LuaPlayer
  change_selected_lane = function(player)
    local selected = player.selected
    if not selected then
      return
    end
    change_lane(player, selected)
  end,
})
