player = game.simulation.create_test_player({ name = "fufucuddlypoops" })
player.teleport({ -7, 2 })
game.simulation.camera_alt_info = true
game.simulation.camera_player = player
game.simulation.camera_player_cursor_position = { -7, 1.5 }

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
    local finished = game.simulation.move_cursor({ position = target_cursor_position })
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
    local finished = game.simulation.move_cursor({ position = target_cursor_position })
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
    local finished = game.simulation.move_cursor({ position = target_cursor_position })
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
