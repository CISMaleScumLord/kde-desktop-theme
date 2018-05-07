--  =======================================================
--  Name:       conky.lua
--  Author:     CisMaleScumLord
--  Date:       Dec 2016
--  Licence:    GPLV3 or at your choice, later
--  =======================================================

require 'os'
require 'cairo'

-- ---------------------------------------------------------
local days = {
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
}

local months = {
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
}

--  Conky colours
--  --------------------------------------------------------
local STATUS_NORMAL = "${color6}"
local STATUS_ALERT = "${color7}"
local STATUS_EMERGENCY = "${color8}"

--  Internal colours and alphas
--  --------------------------------------------------------
local MAIN_COLOUR = 0x7B7B7B
local HIGHLIGHT_COLOUR = 0x46AFFD
local ALPHA_FULL = 1.0
local ALPHA_TRANSPARENT = 0.0
local ALPHA_THREE_QUARTERS = 0.75
local ALHPHA_ONE_HALF = 0.5

local FONT_FACE = "control freak"
local FONT_SIZE_NORMAL = 16
local FONT_SIZE_LARGE = 32
local FONT_SIZE_SMALL = 12

--  --------------------------------------------------------
--  Describe the analogue clock
--  --------------------------------------------------------

local clock = {
    centre_x=  0,
    centre_y = 173,
    max_hours = 12,
    max_units = 60
}

local hours = {
    max_value = 12,
    graph_radius = 44,
    graph_thickness = 3,
    unit_background_arc = 360 / clock['max_hours'],
    unit_foreground_arc = 30,
    graph_bg_colour = MAIN_COLOUR,
    graph_bg_alpha = ALHPHA_ONE_HALF,
    graph_fg_colour = MAIN_COLOUR,
    graph_fg_alpha = ALPHA_THREE_QUARTERS,
    text_radius = 0,
    text_weight = 0,
    text_size = FONT_SIZE_LARGE,
    text_fg_colour = MAIN_COLOUR,
    text_fg_alpha = ALPHA_FULL,
    graduation_radius = 40,
    graduation_thickness = 6,
    graduation_mark_thickness = 2,
    graduation_unit_angle = 30,
    graduation_fg_colour = MAIN_COLOUR,
    graduation_fg_alpha = ALPHA_FULL,
}
local minutes = {
    max_value = 60,
    graph_radius = 50,
    graph_thickness = 2,
    unit_background_arc = 360 / clock['max_units'],
    unit_foreground_arc = 6,
    graph_bg_colour = MAIN_COLOUR,
    graph_bg_alpha = ALHPHA_ONE_HALF,
    graph_fg_colour = MAIN_COLOUR,
    graph_fg_alpha = ALPHA_THREE_QUARTERS,
    text_radius = 28,
    text_weight = 0,
    text_size = FONT_SIZE_SMALL,
    text_fg_colour = MAIN_COLOUR,
    text_fg_alpha = ALPHA_FULL,
    graduation_radius = 52,
    graduation_thickness = 0,
    graduation_mark_thickness = 2,
    graduation_unit_angle = 0,
    graduation_fg_colour = MAIN_COLOUR,
    graduation_fg_alpha = ALPHA_FULL,
}


local seconds = {
    max_value = 60,
    graph_radius = 47,
    graph_thickness = 2,
    unit_background_arc = 360 / clock['max_units'],
    unit_foreground_arc = 5,
    graph_bg_colour = MAIN_COLOUR,
    graph_bg_alpha = ALPHA_TRANSPARENT,
    graph_fg_colour = HIGHLIGHT_COLOUR,
    graph_fg_alpha = ALPHA_THREE_QUARTERS,
    text_radius = 59,
    text_weight = 0,
    text_size = FONT_SIZE_SMALL,
    text_fg_colour = MAIN_COLOUR,
    text_fg_alpha = ALPHA_FULL,
    graduation_radius = 0,
    graduation_thickness = 0,
    graduation_mark_thickness = 2,
    graduation_unit_angle = 0,
    graduation_fg_colour = MAIN_COLOUR,
    graduation_fg_alpha = ALPHA_TRANSPARENT,
}

function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_clock_ring(display, data, value, show_value)
    local max_value = data['max_value']
    local x, y = clock["centre_x"], clock["centre_y"]
    local graph_radius = data['graph_radius']
    local graph_thickness, unit_foreground_arc = data['graph_thickness'], data['unit_foreground_arc']
    local unit_background_arc = data['unit_background_arc']
    local graph_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
    local graph_fg_colour, graph_fg_alpha = data['graph_fg_colour'], data['graph_fg_alpha']

    value = tonumber(value)

    -- background ring
    cairo_arc(display, x, y, graph_radius, 0, 2 * math.pi)
    cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
    cairo_set_line_width(display, graph_thickness)
    cairo_stroke(display)

    -- arc of value
    local val = (value % max_value)
    local i = 1
    while i <= val do
        cairo_arc(display, x, y, graph_radius,(  ((unit_background_arc * i) - unit_foreground_arc)*(2*math.pi/360)  )-(math.pi/2),((unit_background_arc * i) * (2*math.pi/360))-(math.pi/2))
        cairo_set_source_rgba(display,rgb_to_r_g_b(graph_fg_colour,graph_fg_alpha))
        cairo_stroke(display)
        i = i + 1
    end
    local angle = (unit_background_arc * i) - unit_foreground_arc

    -- graduations marks
    local graduation_radius = data['graduation_radius']
    local graduation_thickness, graduation_mark_thickness = data['graduation_thickness'], data['graduation_mark_thickness']
    local graduation_unit_angle = data['graduation_unit_angle']
    local graduation_fg_colour, graduation_fg_alpha = data['graduation_fg_colour'], data['graduation_fg_alpha']
    if graduation_radius > 0 and graduation_thickness > 0 and graduation_unit_angle > 0 then
        local nb_graduation = 360 / graduation_unit_angle
        local i = 1
        while i <= nb_graduation do
            cairo_set_line_width(display, graduation_thickness)
            cairo_arc(display, x, y, graduation_radius, (((graduation_unit_angle * i)-(graduation_mark_thickness/2))*(2*math.pi/360))-(math.pi/2),(((graduation_unit_angle * i)+(graduation_mark_thickness/2))*(2*math.pi/360))-(math.pi/2))
            cairo_set_source_rgba(display,rgb_to_r_g_b(graduation_fg_colour,graduation_fg_alpha))
            cairo_stroke(display)
            cairo_set_line_width(display, graph_thickness)
            i = i + 1
        end
    end

    -- text
    if show_value then
        local text_radius = data['text_radius']
        local text_weight, text_size = data['text_weight'], data['text_size']
        local text_fg_colour, text_fg_alpha = data['text_fg_colour'], data['text_fg_alpha']
        local e = cairo_text_extents_t:create()

        cairo_select_font_face (display, "control freak", CAIRO_FONT_SLANT_NORMAL, text_weight);
        cairo_set_font_size (display, text_size);
        cairo_set_source_rgba (display, rgb_to_r_g_b(text_fg_colour, text_fg_alpha));

        cairo_text_extents(display, value, e)
        local x_offset = (e.width / 2 + e.x_bearing)
        local y_offset = (e.height / 2 + e.y_bearing)

        if data['text_radius'] > 0 then
            cairo_text_extents(display, value, e)
            x = x + text_radius * (math.cos((angle * 2 * math.pi / 360)-(math.pi/2))) - x_offset
            y = y + text_radius * (math.sin((angle * 2 * math.pi / 360)-(math.pi/2))) - y_offset
        else
            cairo_text_extents(display, value, e)
            x = x - x_offset
            y = y - y_offset
        end

        cairo_move_to (display, x, y)
        cairo_show_text (display, value)
        cairo_stroke (display)
    end
end

local function draw_calendar(display, year, month, day, wday)

    local text = days[wday]
    local e = cairo_text_extents_t:create()

    cairo_select_font_face (display, FONT_FACE, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
    cairo_set_font_size (display, FONT_SIZE_NORMAL);
    cairo_set_source_rgba (display, rgb_to_r_g_b(MAIN_COLOUR, ALPHA_FULL))

    cairo_text_extents(display, text, e)
    local x = conky_window.width / 4 * 3 - (e.width / 2 + e.x_bearing)
    local y = 153

    cairo_move_to(display, x, y)
    cairo_show_text(display, text)

    cairo_set_font_size(display, FONT_SIZE_LARGE)
    text = day
    cairo_text_extents(display, text, e)
    x = conky_window.width / 4 * 3 - (e.width / 2 + e.x_bearing)
    y = 183

    cairo_move_to(display, x, y)
    cairo_show_text(display, text)

    cairo_set_font_size(display, FONT_SIZE_NORMAL)
    text = months[month] .. " " .. year
    cairo_text_extents(display, text, e)
    x = conky_window.width / 4 * 3 - (e.width / 2 + e.x_bearing)
    y = 203

    cairo_move_to(display, x, y)
    cairo_show_text(display, text)

    cairo_stroke(display)

end

function conky_colour_select(type)

    local value = 0
    local status = ""

    if type == 'cpu' then
        value = tonumber(conky_parse('${cpu cpu0}'))
    elseif type == 'mem' then
        value = tonumber(conky_parse('${memperc}'))
    end

    if value == nil then
        value = 0
    end

    if value > 75 then
        status = STATUS_EMERGENCY
    elseif value > 50 then
        status = STATUS_ALERT
    else
        status = STATUS_NORMAL
    end

    return status

end

function conky_main()
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)

    local updates = conky_parse('${updates}')
    update_num = tonumber(updates)

    clock.centre_x =  conky_window.width / 4

    if update_num > 2 then
        local now = os.date("*t")

        draw_clock_ring(display, hours, now.hour, true)
        draw_clock_ring(display, minutes, now.min, true)
        draw_clock_ring(display, seconds, now.sec, false)

        draw_calendar(display, now.year, now.month, now.day, now.wday)
    end

    cairo_surface_destroy(cs)
    cairo_destroy(display)
end
