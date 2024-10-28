if mods["bobinserters"] then
  return
end

data:extend({
  { type = "custom-input", name = "cidl-change-lane", key_sequence = "SHIFT + L" },
  {
    type = "optimized-particle",
    name = "cidl-welding",
    life_time = 30,
    pictures = {
      layers = {
        {
          filename = "__ChangeInserterDropLane__/graphics/welding.png",
          priority = "extra-high",
          width = 200,
          height = 200,
          frame_count = 30,
          line_length = 6,
          animation_speed = 0.75,
          variation_count = 1,
          scale = 0.5,
        },
        {
          filename = "__ChangeInserterDropLane__/graphics/welding.png",
          priority = "extra-high",
          width = 200,
          height = 200,
          frame_count = 30,
          line_length = 6,
          animation_speed = 0.75,
          variation_count = 1,
          scale = 0.5,
          blend_mode = "additive-soft",
        },
        {
          filename = "__ChangeInserterDropLane__/graphics/welding.png",
          priority = "extra-high",
          width = 200,
          height = 200,
          frame_count = 30,
          line_length = 6,
          animation_speed = 0.75,
          variation_count = 1,
          scale = 0.5,
          blend_mode = "additive-soft",
        },
      },
    },
  },
  {
    type = "sound",
    name = "cidl-welding",
    category = "alert",
    filename = "__ChangeInserterDropLane__/sounds/welding.ogg",
    volume = 0.75,
    audible_distance_modifier = 0.5,
    aggregation = {
      max_count = 1,
      remove = true,
      count_already_playing = true,
    },
  },
  {
    type = "sprite",
    name = "cidl_change_lane_icon",
    filename = "__ChangeInserterDropLane__/graphics/change-lane-icon.png",
    size = 64,
    flags = { "gui-icon" },
  },
  {
    type = "tips-and-tricks-item",
    name = "cidl-change-drop-lane",
    tag = "[img=cidl_change_lane_icon]",
    category = "inserters",
    indent = 1,
    order = "g",
    trigger = { type = "build-entity", entity = "inserter" },
    dependencies = { "inserters" },
    simulation = {
      save = "__ChangeInserterDropLane__/simulations/change-drop-lane.zip",
      mods = { "ChangeInserterDropLane" },
      init_file = "__ChangeInserterDropLane__/simulation-control.lua",
    },
  },
})
