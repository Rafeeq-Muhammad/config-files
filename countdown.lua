-- Extended Countdown Timer with Pause/Resume/Reset and UI Buttons
-- Based on original script by Lain

obs = obslua
source_name = ""
total_seconds = 0
cur_seconds = 0
last_text = ""
stop_text = ""
activated = false
paused = false

hotkey_reset_id = obs.OBS_INVALID_HOTKEY_ID
hotkey_pause_id = obs.OBS_INVALID_HOTKEY_ID
hotkey_resume_id = obs.OBS_INVALID_HOTKEY_ID

function set_time_text()
	local seconds = math.floor(cur_seconds % 60)
	local total_minutes = math.floor(cur_seconds / 60)
	local minutes = math.floor(total_minutes % 60)
	local hours = math.floor(total_minutes / 60)
	local text = string.format("%02d:%02d:%02d", hours, minutes, seconds)

	if cur_seconds < 1 then
		text = stop_text
	end

	if text ~= last_text then
		local source = obs.obs_get_source_by_name(source_name)
		if source ~= nil then
			local settings = obs.obs_data_create()
			obs.obs_data_set_string(settings, "text", text)
			obs.obs_source_update(source, settings)
			obs.obs_data_release(settings)
			obs.obs_source_release(source)
		end
		last_text = text
	end
end

function timer_callback()
	if not paused then
		cur_seconds = cur_seconds - 1
		if cur_seconds < 0 then
			obs.remove_current_callback()
			cur_seconds = 0
		end
		set_time_text()
	end
end

function start_timer_button(props, p)
	start_timer()
	return false
end

function pause_timer_button(props, p)
	paused = true
	return false
end

function resume_timer_button(props, p)
	paused = false
	return false
end

function reset_timer_button(props, p)
	reset_timer(true)
	return false
end

function start_timer()
	activated = true
	paused = false
	cur_seconds = total_seconds
	set_time_text()
	obs.timer_add(timer_callback, 1000)
end

function stop_timer()
	obs.timer_remove(timer_callback)
	activated = false
end

function pause_timer(pressed)
	if not pressed then
		return
	end
	if activated and not paused then
		paused = true
	end
end

function resume_timer(pressed)
	if not pressed then
		return
	end
	if activated and paused then
		paused = false
	end
end

function reset_timer(pressed)
	if not pressed then
		return
	end
	stop_timer()
	cur_seconds = total_seconds
	set_time_text()
	start_timer()
end

function script_properties()
	local props = obs.obs_properties_create()
	obs.obs_properties_add_int(props, "duration", "Duration (minutes)", 1, 100000, 1)

	local p = obs.obs_properties_add_list(
		props,
		"source",
		"Text Source",
		obs.OBS_COMBO_TYPE_EDITABLE,
		obs.OBS_COMBO_FORMAT_STRING
	)
	local sources = obs.obs_enum_sources()
	if sources ~= nil then
		for _, source in ipairs(sources) do
			source_id = obs.obs_source_get_unversioned_id(source)
			if source_id == "text_gdiplus" or source_id == "text_ft2_source" then
				local name = obs.obs_source_get_name(source)
				obs.obs_property_list_add_string(p, name, name)
			end
		end
	end
	obs.source_list_release(sources)

	obs.obs_properties_add_text(props, "stop_text", "Final Text", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_button(props, "start_button", "Start Timer", start_timer_button)
	obs.obs_properties_add_button(props, "pause_button", "Pause Timer", pause_timer_button)
	obs.obs_properties_add_button(props, "resume_button", "Resume Timer", resume_timer_button)
	obs.obs_properties_add_button(props, "reset_button", "Reset Timer", reset_timer_button)

	return props
end

function script_description()
	return "Countdown timer with pause, resume, reset, and UI control buttons.\nAdd a text source and link it to this timer."
end

function script_update(settings)
	total_seconds = obs.obs_data_get_int(settings, "duration") * 60
	source_name = obs.obs_data_get_string(settings, "source")
	stop_text = obs.obs_data_get_string(settings, "stop_text")
	cur_seconds = total_seconds
	set_time_text()
end

function script_defaults(settings)
	obs.obs_data_set_default_int(settings, "duration", 5)
	obs.obs_data_set_default_string(settings, "stop_text", "Time's up!")
end

function script_save(settings)
	local reset_hotkey_array = obs.obs_hotkey_save(hotkey_reset_id)
	obs.obs_data_set_array(settings, "reset_hotkey", reset_hotkey_array)
	obs.obs_data_array_release(reset_hotkey_array)

	local pause_hotkey_array = obs.obs_hotkey_save(hotkey_pause_id)
	obs.obs_data_set_array(settings, "pause_hotkey", pause_hotkey_array)
	obs.obs_data_array_release(pause_hotkey_array)

	local resume_hotkey_array = obs.obs_hotkey_save(hotkey_resume_id)
	obs.obs_data_set_array(settings, "resume_hotkey", resume_hotkey_array)
	obs.obs_data_array_release(resume_hotkey_array)
end

function script_load(settings)
	hotkey_reset_id = obs.obs_hotkey_register_frontend("reset_timer", "Reset Timer", reset_timer)
	local reset_hotkey_array = obs.obs_data_get_array(settings, "reset_hotkey")
	obs.obs_hotkey_load(hotkey_reset_id, reset_hotkey_array)
	obs.obs_data_array_release(reset_hotkey_array)

	hotkey_pause_id = obs.obs_hotkey_register_frontend("pause_timer", "Pause Timer", pause_timer)
	local pause_hotkey_array = obs.obs_data_get_array(settings, "pause_hotkey")
	obs.obs_hotkey_load(hotkey_pause_id, pause_hotkey_array)
	obs.obs_data_array_release(pause_hotkey_array)

	hotkey_resume_id = obs.obs_hotkey_register_frontend("resume_timer", "Resume Timer", resume_timer)
	local resume_hotkey_array = obs.obs_data_get_array(settings, "resume_hotkey")
	obs.obs_hotkey_load(hotkey_resume_id, resume_hotkey_array)
	obs.obs_data_array_release(resume_hotkey_array)
end
