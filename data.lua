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
    type = "tips-and-tricks-item",
    name = "cidl-change-drop-lane",
    category = "inserters",
    indent = 1,
    order = "g",
    trigger = { type = "build-entity", entity = "inserter" },
    dependencies = { "inserters" },
    simulation = {
      save = "__ChangeInserterDropLane__/simulations/change-drop-lane.zip",
      init = [[
        player = game.create_test_player({ name = "fufucuddlypoops" })
        player.teleport({ -7, 2 })
        game.camera_alt_info = true
        game.camera_player = player
        game.camera_player_cursor_position = { -7, 1.5 }

        step_0 = function()
          start_tick = game.tick
          script.on_nth_tick(1, function()
            if game.tick - start_tick > 60 then
              step_1()
            end
          end)
        end

        step_1 = function()
          target_cursor_position = { -4.5, -1.5 }
          script.on_nth_tick(1, function()
            local finished = game.move_cursor({ position = target_cursor_position })
            if finished then
              step_2()
            end
          end)
        end

        step_2 = function()
          start_tick = game.tick
          script.on_nth_tick(1, function()
            if game.tick - start_tick > 15 then
              remote.call("ChangeInserterDropLane_simulation", "change_selected_lane", player)
              step_3()
            end
          end)
        end

        step_3 = function()
          start_tick = game.tick
          script.on_nth_tick(1, function()
            if game.tick - start_tick > 15 then
              step_4()
            end
          end)
        end

        step_4 = function()
          target_cursor_position = { -1.5, -1.5 }
          script.on_nth_tick(1, function()
            local finished = game.move_cursor({ position = target_cursor_position })
            if finished then
              step_5()
            end
          end)
        end

        step_5 = function()
          start_tick = game.tick
          script.on_nth_tick(1, function()
            if game.tick - start_tick > 15 then
              remote.call("ChangeInserterDropLane_simulation", "change_selected_lane", player)
              step_6()
            end
          end)
        end

        step_6 = function()
          start_tick = game.tick
          script.on_nth_tick(1, function()
            if game.tick - start_tick > 15 then
              step_7()
            end
          end)
        end

        step_7 = function()
          target_cursor_position = { -7, 1.5 }
          script.on_nth_tick(1, function()
            local finished = game.move_cursor({ position = target_cursor_position })
            if finished then
              step_8()
            end
          end)
        end

        step_8 = function()
          start_tick = game.tick
          script.on_nth_tick(1, function()
            if game.tick - start_tick > 240 then
              step_0()
            end
          end)
        end

        step_0()
      ]],
    },
  },
})
