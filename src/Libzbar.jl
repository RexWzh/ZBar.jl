module Libzbar

using zbar_jll
export zbar_jll

using CEnum

@cenum zbar_color_e::UInt32 begin
    ZBAR_SPACE = 0
    ZBAR_BAR = 1
end

const zbar_color_t = zbar_color_e

@cenum zbar_symbol_type_e::UInt32 begin
    ZBAR_NONE = 0
    ZBAR_PARTIAL = 1
    ZBAR_EAN2 = 2
    ZBAR_EAN5 = 5
    ZBAR_EAN8 = 8
    ZBAR_UPCE = 9
    ZBAR_ISBN10 = 10
    ZBAR_UPCA = 12
    ZBAR_EAN13 = 13
    ZBAR_ISBN13 = 14
    ZBAR_COMPOSITE = 15
    ZBAR_I25 = 25
    ZBAR_DATABAR = 34
    ZBAR_DATABAR_EXP = 35
    ZBAR_CODABAR = 38
    ZBAR_CODE39 = 39
    ZBAR_PDF417 = 57
    ZBAR_QRCODE = 64
    ZBAR_SQCODE = 80
    ZBAR_CODE93 = 93
    ZBAR_CODE128 = 128
    ZBAR_SYMBOL = 255
    ZBAR_ADDON2 = 512
    ZBAR_ADDON5 = 1280
    ZBAR_ADDON = 1792
end

const zbar_symbol_type_t = zbar_symbol_type_e

@cenum zbar_orientation_e::Int32 begin
    ZBAR_ORIENT_UNKNOWN = -1
    ZBAR_ORIENT_UP = 0
    ZBAR_ORIENT_RIGHT = 1
    ZBAR_ORIENT_DOWN = 2
    ZBAR_ORIENT_LEFT = 3
end

const zbar_orientation_t = zbar_orientation_e

@cenum zbar_error_e::UInt32 begin
    ZBAR_OK = 0
    ZBAR_ERR_NOMEM = 1
    ZBAR_ERR_INTERNAL = 2
    ZBAR_ERR_UNSUPPORTED = 3
    ZBAR_ERR_INVALID = 4
    ZBAR_ERR_SYSTEM = 5
    ZBAR_ERR_LOCKING = 6
    ZBAR_ERR_BUSY = 7
    ZBAR_ERR_XDISPLAY = 8
    ZBAR_ERR_XPROTO = 9
    ZBAR_ERR_CLOSED = 10
    ZBAR_ERR_WINAPI = 11
    ZBAR_ERR_NUM = 12
end

const zbar_error_t = zbar_error_e

@cenum zbar_config_e::UInt32 begin
    ZBAR_CFG_ENABLE = 0
    ZBAR_CFG_ADD_CHECK = 1
    ZBAR_CFG_EMIT_CHECK = 2
    ZBAR_CFG_ASCII = 3
    ZBAR_CFG_BINARY = 4
    ZBAR_CFG_NUM = 5
    ZBAR_CFG_MIN_LEN = 32
    ZBAR_CFG_MAX_LEN = 33
    ZBAR_CFG_UNCERTAINTY = 64
    ZBAR_CFG_POSITION = 128
    ZBAR_CFG_TEST_INVERTED = 129
    ZBAR_CFG_X_DENSITY = 256
    ZBAR_CFG_Y_DENSITY = 257
end

const zbar_config_t = zbar_config_e

@cenum zbar_modifier_e::UInt32 begin
    ZBAR_MOD_GS1 = 0
    ZBAR_MOD_AIM = 1
    ZBAR_MOD_NUM = 2
end

const zbar_modifier_t = zbar_modifier_e

@cenum video_control_type_e::UInt32 begin
    VIDEO_CNTL_INTEGER = 1
    VIDEO_CNTL_MENU = 2
    VIDEO_CNTL_BUTTON = 3
    VIDEO_CNTL_INTEGER64 = 4
    VIDEO_CNTL_STRING = 5
    VIDEO_CNTL_BOOLEAN = 6
end

const video_control_type_t = video_control_type_e

struct video_control_menu_s
    name::Ptr{Cchar}
    value::Int64
end

const video_control_menu_t = video_control_menu_s

struct video_controls_s
    name::Ptr{Cchar}
    group::Ptr{Cchar}
    type::video_control_type_t
    min::Int64
    max::Int64
    def::Int64
    step::UInt64
    menu_size::Cuint
    menu::Ptr{video_control_menu_t}
    next::Ptr{Cvoid}
end

const video_controls_t = video_controls_s

struct video_resolution_s
    width::Cuint
    height::Cuint
    max_fps::Cfloat
end

function zbar_version(major, minor, patch)
    @ccall libzbar.zbar_version(major::Ptr{Cuint}, minor::Ptr{Cuint}, patch::Ptr{Cuint})::Cint
end

function zbar_set_verbosity(verbosity)
    @ccall libzbar.zbar_set_verbosity(verbosity::Cint)::Cvoid
end

function zbar_increase_verbosity()
    @ccall libzbar.zbar_increase_verbosity()::Cvoid
end

function zbar_get_symbol_name(sym)
    @ccall libzbar.zbar_get_symbol_name(sym::zbar_symbol_type_t)::Ptr{Cchar}
end

function zbar_get_addon_name(sym)
    @ccall libzbar.zbar_get_addon_name(sym::zbar_symbol_type_t)::Ptr{Cchar}
end

function zbar_get_config_name(config)
    @ccall libzbar.zbar_get_config_name(config::zbar_config_t)::Ptr{Cchar}
end

function zbar_get_modifier_name(modifier)
    @ccall libzbar.zbar_get_modifier_name(modifier::zbar_modifier_t)::Ptr{Cchar}
end

function zbar_get_orientation_name(orientation)
    @ccall libzbar.zbar_get_orientation_name(orientation::zbar_orientation_t)::Ptr{Cchar}
end

function zbar_parse_config(config_string, symbology, config, value)
    @ccall libzbar.zbar_parse_config(config_string::Ptr{Cchar}, symbology::Ptr{zbar_symbol_type_t}, config::Ptr{zbar_config_t}, value::Ptr{Cint})::Cint
end

function zbar_fourcc_parse(format)
    @ccall libzbar.zbar_fourcc_parse(format::Ptr{Cchar})::Culong
end

function _zbar_error_spew(object, verbosity)
    @ccall libzbar._zbar_error_spew(object::Ptr{Cvoid}, verbosity::Cint)::Cint
end

function _zbar_error_string(object, verbosity)
    @ccall libzbar._zbar_error_string(object::Ptr{Cvoid}, verbosity::Cint)::Ptr{Cchar}
end

function _zbar_get_error_code(object)
    @ccall libzbar._zbar_get_error_code(object::Ptr{Cvoid})::zbar_error_t
end

mutable struct zbar_symbol_s end

const zbar_symbol_t = zbar_symbol_s

mutable struct zbar_symbol_set_s end

const zbar_symbol_set_t = zbar_symbol_set_s

function zbar_symbol_ref(symbol, refs)
    @ccall libzbar.zbar_symbol_ref(symbol::Ptr{zbar_symbol_t}, refs::Cint)::Cvoid
end

function zbar_symbol_get_type(symbol)
    @ccall libzbar.zbar_symbol_get_type(symbol::Ptr{zbar_symbol_t})::zbar_symbol_type_t
end

function zbar_symbol_get_configs(symbol)
    @ccall libzbar.zbar_symbol_get_configs(symbol::Ptr{zbar_symbol_t})::Cuint
end

function zbar_symbol_get_modifiers(symbol)
    @ccall libzbar.zbar_symbol_get_modifiers(symbol::Ptr{zbar_symbol_t})::Cuint
end

function zbar_symbol_get_data(symbol)
    @ccall libzbar.zbar_symbol_get_data(symbol::Ptr{zbar_symbol_t})::Ptr{Cchar}
end

function zbar_symbol_get_data_length(symbol)
    @ccall libzbar.zbar_symbol_get_data_length(symbol::Ptr{zbar_symbol_t})::Cuint
end

function zbar_symbol_get_quality(symbol)
    @ccall libzbar.zbar_symbol_get_quality(symbol::Ptr{zbar_symbol_t})::Cint
end

function zbar_symbol_get_count(symbol)
    @ccall libzbar.zbar_symbol_get_count(symbol::Ptr{zbar_symbol_t})::Cint
end

function zbar_symbol_get_loc_size(symbol)
    @ccall libzbar.zbar_symbol_get_loc_size(symbol::Ptr{zbar_symbol_t})::Cuint
end

function zbar_symbol_get_loc_x(symbol, index)
    @ccall libzbar.zbar_symbol_get_loc_x(symbol::Ptr{zbar_symbol_t}, index::Cuint)::Cint
end

function zbar_symbol_get_loc_y(symbol, index)
    @ccall libzbar.zbar_symbol_get_loc_y(symbol::Ptr{zbar_symbol_t}, index::Cuint)::Cint
end

function zbar_symbol_get_orientation(symbol)
    @ccall libzbar.zbar_symbol_get_orientation(symbol::Ptr{zbar_symbol_t})::zbar_orientation_t
end

function zbar_symbol_next(symbol)
    @ccall libzbar.zbar_symbol_next(symbol::Ptr{zbar_symbol_t})::Ptr{zbar_symbol_t}
end

function zbar_symbol_get_components(symbol)
    @ccall libzbar.zbar_symbol_get_components(symbol::Ptr{zbar_symbol_t})::Ptr{zbar_symbol_set_t}
end

function zbar_symbol_first_component(symbol)
    @ccall libzbar.zbar_symbol_first_component(symbol::Ptr{zbar_symbol_t})::Ptr{zbar_symbol_t}
end

function zbar_symbol_xml(symbol, buffer, buflen)
    @ccall libzbar.zbar_symbol_xml(symbol::Ptr{zbar_symbol_t}, buffer::Ptr{Ptr{Cchar}}, buflen::Ptr{Cuint})::Ptr{Cchar}
end

function zbar_symbol_set_ref(symbols, refs)
    @ccall libzbar.zbar_symbol_set_ref(symbols::Ptr{zbar_symbol_set_t}, refs::Cint)::Cvoid
end

function zbar_symbol_set_get_size(symbols)
    @ccall libzbar.zbar_symbol_set_get_size(symbols::Ptr{zbar_symbol_set_t})::Cint
end

function zbar_symbol_set_first_symbol(symbols)
    @ccall libzbar.zbar_symbol_set_first_symbol(symbols::Ptr{zbar_symbol_set_t})::Ptr{zbar_symbol_t}
end

function zbar_symbol_set_first_unfiltered(symbols)
    @ccall libzbar.zbar_symbol_set_first_unfiltered(symbols::Ptr{zbar_symbol_set_t})::Ptr{zbar_symbol_t}
end

mutable struct zbar_image_s end

const zbar_image_t = zbar_image_s

# typedef void ( zbar_image_cleanup_handler_t ) ( zbar_image_t * image )
const zbar_image_cleanup_handler_t = Cvoid

# typedef void ( zbar_image_data_handler_t ) ( zbar_image_t * image , const void * userdata )
const zbar_image_data_handler_t = Cvoid

function zbar_image_create()
    @ccall libzbar.zbar_image_create()::Ptr{zbar_image_t}
end

function zbar_image_destroy(image)
    @ccall libzbar.zbar_image_destroy(image::Ptr{zbar_image_t})::Cvoid
end

function zbar_image_ref(image, refs)
    @ccall libzbar.zbar_image_ref(image::Ptr{zbar_image_t}, refs::Cint)::Cvoid
end

function zbar_image_convert(image, format)
    @ccall libzbar.zbar_image_convert(image::Ptr{zbar_image_t}, format::Culong)::Ptr{zbar_image_t}
end

function zbar_image_convert_resize(image, format, width, height)
    @ccall libzbar.zbar_image_convert_resize(image::Ptr{zbar_image_t}, format::Culong, width::Cuint, height::Cuint)::Ptr{zbar_image_t}
end

function zbar_image_get_format(image)
    @ccall libzbar.zbar_image_get_format(image::Ptr{zbar_image_t})::Culong
end

function zbar_image_get_sequence(image)
    @ccall libzbar.zbar_image_get_sequence(image::Ptr{zbar_image_t})::Cuint
end

function zbar_image_get_width(image)
    @ccall libzbar.zbar_image_get_width(image::Ptr{zbar_image_t})::Cuint
end

function zbar_image_get_height(image)
    @ccall libzbar.zbar_image_get_height(image::Ptr{zbar_image_t})::Cuint
end

function zbar_image_get_size(image, width, height)
    @ccall libzbar.zbar_image_get_size(image::Ptr{zbar_image_t}, width::Ptr{Cuint}, height::Ptr{Cuint})::Cvoid
end

function zbar_image_get_crop(image, x, y, width, height)
    @ccall libzbar.zbar_image_get_crop(image::Ptr{zbar_image_t}, x::Ptr{Cuint}, y::Ptr{Cuint}, width::Ptr{Cuint}, height::Ptr{Cuint})::Cvoid
end

function zbar_image_get_data(image)
    @ccall libzbar.zbar_image_get_data(image::Ptr{zbar_image_t})::Ptr{Cvoid}
end

function zbar_image_get_data_length(img)
    @ccall libzbar.zbar_image_get_data_length(img::Ptr{zbar_image_t})::Culong
end

function zbar_image_get_symbols(image)
    @ccall libzbar.zbar_image_get_symbols(image::Ptr{zbar_image_t})::Ptr{zbar_symbol_set_t}
end

function zbar_image_set_symbols(image, symbols)
    @ccall libzbar.zbar_image_set_symbols(image::Ptr{zbar_image_t}, symbols::Ptr{zbar_symbol_set_t})::Cvoid
end

function zbar_image_first_symbol(image)
    @ccall libzbar.zbar_image_first_symbol(image::Ptr{zbar_image_t})::Ptr{zbar_symbol_t}
end

function zbar_image_set_format(image, format)
    @ccall libzbar.zbar_image_set_format(image::Ptr{zbar_image_t}, format::Culong)::Cvoid
end

function zbar_image_set_sequence(image, sequence_num)
    @ccall libzbar.zbar_image_set_sequence(image::Ptr{zbar_image_t}, sequence_num::Cuint)::Cvoid
end

function zbar_image_set_size(image, width, height)
    @ccall libzbar.zbar_image_set_size(image::Ptr{zbar_image_t}, width::Cuint, height::Cuint)::Cvoid
end

function zbar_image_set_crop(image, x, y, width, height)
    @ccall libzbar.zbar_image_set_crop(image::Ptr{zbar_image_t}, x::Cuint, y::Cuint, width::Cuint, height::Cuint)::Cvoid
end

function zbar_image_set_data(image, data, data_byte_length, cleanup_hndlr)
    @ccall libzbar.zbar_image_set_data(image::Ptr{zbar_image_t}, data::Ptr{Cvoid}, data_byte_length::Culong, cleanup_hndlr::Ptr{Cvoid})::Cvoid
end

function zbar_image_free_data(image)
    @ccall libzbar.zbar_image_free_data(image::Ptr{zbar_image_t})::Cvoid
end

function zbar_image_set_userdata(image, userdata)
    @ccall libzbar.zbar_image_set_userdata(image::Ptr{zbar_image_t}, userdata::Ptr{Cvoid})::Cvoid
end

function zbar_image_get_userdata(image)
    @ccall libzbar.zbar_image_get_userdata(image::Ptr{zbar_image_t})::Ptr{Cvoid}
end

function zbar_image_write(image, filebase)
    @ccall libzbar.zbar_image_write(image::Ptr{zbar_image_t}, filebase::Ptr{Cchar})::Cint
end

function zbar_image_read(filename)
    @ccall libzbar.zbar_image_read(filename::Ptr{Cchar})::Ptr{zbar_image_t}
end

mutable struct zbar_processor_s end

const zbar_processor_t = zbar_processor_s

function zbar_processor_create(threaded)
    @ccall libzbar.zbar_processor_create(threaded::Cint)::Ptr{zbar_processor_t}
end

function zbar_processor_destroy(processor)
    @ccall libzbar.zbar_processor_destroy(processor::Ptr{zbar_processor_t})::Cvoid
end

function zbar_processor_init(processor, video_device, enable_display)
    @ccall libzbar.zbar_processor_init(processor::Ptr{zbar_processor_t}, video_device::Ptr{Cchar}, enable_display::Cint)::Cint
end

function zbar_processor_request_size(processor, width, height)
    @ccall libzbar.zbar_processor_request_size(processor::Ptr{zbar_processor_t}, width::Cuint, height::Cuint)::Cint
end

function zbar_processor_request_interface(processor, version)
    @ccall libzbar.zbar_processor_request_interface(processor::Ptr{zbar_processor_t}, version::Cint)::Cint
end

function zbar_processor_request_iomode(video, iomode)
    @ccall libzbar.zbar_processor_request_iomode(video::Ptr{zbar_processor_t}, iomode::Cint)::Cint
end

function zbar_processor_force_format(processor, input_format, output_format)
    @ccall libzbar.zbar_processor_force_format(processor::Ptr{zbar_processor_t}, input_format::Culong, output_format::Culong)::Cint
end

function zbar_processor_set_data_handler(processor, handler, userdata)
    @ccall libzbar.zbar_processor_set_data_handler(processor::Ptr{zbar_processor_t}, handler::Ptr{Cvoid}, userdata::Ptr{Cvoid})::Ptr{Cvoid}
end

function zbar_processor_set_userdata(processor, userdata)
    @ccall libzbar.zbar_processor_set_userdata(processor::Ptr{zbar_processor_t}, userdata::Ptr{Cvoid})::Cvoid
end

function zbar_processor_get_userdata(processor)
    @ccall libzbar.zbar_processor_get_userdata(processor::Ptr{zbar_processor_t})::Ptr{Cvoid}
end

function zbar_processor_set_config(processor, symbology, config, value)
    @ccall libzbar.zbar_processor_set_config(processor::Ptr{zbar_processor_t}, symbology::zbar_symbol_type_t, config::zbar_config_t, value::Cint)::Cint
end

function zbar_processor_set_control(processor, control_name, value)
    @ccall libzbar.zbar_processor_set_control(processor::Ptr{zbar_processor_t}, control_name::Ptr{Cchar}, value::Cint)::Cint
end

function zbar_processor_get_control(processor, control_name, value)
    @ccall libzbar.zbar_processor_get_control(processor::Ptr{zbar_processor_t}, control_name::Ptr{Cchar}, value::Ptr{Cint})::Cint
end

function zbar_processor_parse_config(processor, config_string)
    @ccall libzbar.zbar_processor_parse_config(processor::Ptr{zbar_processor_t}, config_string::Ptr{Cchar})::Cint
end

function zbar_processor_is_visible(processor)
    @ccall libzbar.zbar_processor_is_visible(processor::Ptr{zbar_processor_t})::Cint
end

function zbar_processor_set_visible(processor, visible)
    @ccall libzbar.zbar_processor_set_visible(processor::Ptr{zbar_processor_t}, visible::Cint)::Cint
end

function zbar_processor_set_active(processor, active)
    @ccall libzbar.zbar_processor_set_active(processor::Ptr{zbar_processor_t}, active::Cint)::Cint
end

function zbar_processor_get_results(processor)
    @ccall libzbar.zbar_processor_get_results(processor::Ptr{zbar_processor_t})::Ptr{zbar_symbol_set_t}
end

function zbar_processor_user_wait(processor, timeout)
    @ccall libzbar.zbar_processor_user_wait(processor::Ptr{zbar_processor_t}, timeout::Cint)::Cint
end

function zbar_process_one(processor, timeout)
    @ccall libzbar.zbar_process_one(processor::Ptr{zbar_processor_t}, timeout::Cint)::Cint
end

function zbar_process_image(processor, image)
    @ccall libzbar.zbar_process_image(processor::Ptr{zbar_processor_t}, image::Ptr{zbar_image_t})::Cint
end

function zbar_processor_request_dbus(proc, req_dbus_enabled)
    @ccall libzbar.zbar_processor_request_dbus(proc::Ptr{zbar_processor_t}, req_dbus_enabled::Cint)::Cint
end

function zbar_processor_error_spew(processor, verbosity)
    @ccall libzbar.zbar_processor_error_spew(processor::Ptr{zbar_processor_t}, verbosity::Cint)::Cint
end

function zbar_processor_error_string(processor, verbosity)
    @ccall libzbar.zbar_processor_error_string(processor::Ptr{zbar_processor_t}, verbosity::Cint)::Ptr{Cchar}
end

function zbar_processor_get_error_code(processor)
    @ccall libzbar.zbar_processor_get_error_code(processor::Ptr{zbar_processor_t})::zbar_error_t
end

mutable struct zbar_video_s end

const zbar_video_t = zbar_video_s

function zbar_video_create()
    @ccall libzbar.zbar_video_create()::Ptr{zbar_video_t}
end

function zbar_video_destroy(video)
    @ccall libzbar.zbar_video_destroy(video::Ptr{zbar_video_t})::Cvoid
end

function zbar_video_open(video, device)
    @ccall libzbar.zbar_video_open(video::Ptr{zbar_video_t}, device::Ptr{Cchar})::Cint
end

function zbar_video_get_fd(video)
    @ccall libzbar.zbar_video_get_fd(video::Ptr{zbar_video_t})::Cint
end

function zbar_video_request_size(video, width, height)
    @ccall libzbar.zbar_video_request_size(video::Ptr{zbar_video_t}, width::Cuint, height::Cuint)::Cint
end

function zbar_video_request_interface(video, version)
    @ccall libzbar.zbar_video_request_interface(video::Ptr{zbar_video_t}, version::Cint)::Cint
end

function zbar_video_request_iomode(video, iomode)
    @ccall libzbar.zbar_video_request_iomode(video::Ptr{zbar_video_t}, iomode::Cint)::Cint
end

function zbar_video_get_width(video)
    @ccall libzbar.zbar_video_get_width(video::Ptr{zbar_video_t})::Cint
end

function zbar_video_get_height(video)
    @ccall libzbar.zbar_video_get_height(video::Ptr{zbar_video_t})::Cint
end

function zbar_video_init(video, format)
    @ccall libzbar.zbar_video_init(video::Ptr{zbar_video_t}, format::Culong)::Cint
end

function zbar_video_enable(video, enable)
    @ccall libzbar.zbar_video_enable(video::Ptr{zbar_video_t}, enable::Cint)::Cint
end

function zbar_video_next_image(video)
    @ccall libzbar.zbar_video_next_image(video::Ptr{zbar_video_t})::Ptr{zbar_image_t}
end

function zbar_video_set_control(video, control_name, value)
    @ccall libzbar.zbar_video_set_control(video::Ptr{zbar_video_t}, control_name::Ptr{Cchar}, value::Cint)::Cint
end

function zbar_video_get_control(video, control_name, value)
    @ccall libzbar.zbar_video_get_control(video::Ptr{zbar_video_t}, control_name::Ptr{Cchar}, value::Ptr{Cint})::Cint
end

function zbar_video_get_controls(video, index)
    @ccall libzbar.zbar_video_get_controls(video::Ptr{zbar_video_t}, index::Cint)::Ptr{video_controls_s}
end

function zbar_video_get_resolutions(vdo, index)
    @ccall libzbar.zbar_video_get_resolutions(vdo::Ptr{zbar_video_t}, index::Cint)::Ptr{video_resolution_s}
end

function zbar_video_error_spew(video, verbosity)
    @ccall libzbar.zbar_video_error_spew(video::Ptr{zbar_video_t}, verbosity::Cint)::Cint
end

function zbar_video_error_string(video, verbosity)
    @ccall libzbar.zbar_video_error_string(video::Ptr{zbar_video_t}, verbosity::Cint)::Ptr{Cchar}
end

function zbar_video_get_error_code(video)
    @ccall libzbar.zbar_video_get_error_code(video::Ptr{zbar_video_t})::zbar_error_t
end

mutable struct zbar_window_s end

const zbar_window_t = zbar_window_s

function zbar_window_create()
    @ccall libzbar.zbar_window_create()::Ptr{zbar_window_t}
end

function zbar_window_destroy(window)
    @ccall libzbar.zbar_window_destroy(window::Ptr{zbar_window_t})::Cvoid
end

function zbar_window_attach(window, x11_display_w32_hwnd, x11_drawable)
    @ccall libzbar.zbar_window_attach(window::Ptr{zbar_window_t}, x11_display_w32_hwnd::Ptr{Cvoid}, x11_drawable::Culong)::Cint
end

function zbar_window_set_overlay(window, level)
    @ccall libzbar.zbar_window_set_overlay(window::Ptr{zbar_window_t}, level::Cint)::Cvoid
end

function zbar_window_get_overlay(window)
    @ccall libzbar.zbar_window_get_overlay(window::Ptr{zbar_window_t})::Cint
end

function zbar_window_draw(window, image)
    @ccall libzbar.zbar_window_draw(window::Ptr{zbar_window_t}, image::Ptr{zbar_image_t})::Cint
end

function zbar_window_redraw(window)
    @ccall libzbar.zbar_window_redraw(window::Ptr{zbar_window_t})::Cint
end

function zbar_window_resize(window, width, height)
    @ccall libzbar.zbar_window_resize(window::Ptr{zbar_window_t}, width::Cuint, height::Cuint)::Cint
end

function zbar_window_error_spew(window, verbosity)
    @ccall libzbar.zbar_window_error_spew(window::Ptr{zbar_window_t}, verbosity::Cint)::Cint
end

function zbar_window_error_string(window, verbosity)
    @ccall libzbar.zbar_window_error_string(window::Ptr{zbar_window_t}, verbosity::Cint)::Ptr{Cchar}
end

function zbar_window_get_error_code(window)
    @ccall libzbar.zbar_window_get_error_code(window::Ptr{zbar_window_t})::zbar_error_t
end

function zbar_negotiate_format(video, window)
    @ccall libzbar.zbar_negotiate_format(video::Ptr{zbar_video_t}, window::Ptr{zbar_window_t})::Cint
end

mutable struct zbar_image_scanner_s end

const zbar_image_scanner_t = zbar_image_scanner_s

function zbar_image_scanner_create()
    @ccall libzbar.zbar_image_scanner_create()::Ptr{zbar_image_scanner_t}
end

function zbar_image_scanner_destroy(scanner)
    @ccall libzbar.zbar_image_scanner_destroy(scanner::Ptr{zbar_image_scanner_t})::Cvoid
end

function zbar_image_scanner_set_data_handler(scanner, handler, userdata)
    @ccall libzbar.zbar_image_scanner_set_data_handler(scanner::Ptr{zbar_image_scanner_t}, handler::Ptr{Cvoid}, userdata::Ptr{Cvoid})::Ptr{Cvoid}
end

function zbar_image_scanner_request_dbus(scanner, req_dbus_enabled)
    @ccall libzbar.zbar_image_scanner_request_dbus(scanner::Ptr{zbar_image_scanner_t}, req_dbus_enabled::Cint)::Cint
end

function zbar_image_scanner_set_config(scanner, symbology, config, value)
    @ccall libzbar.zbar_image_scanner_set_config(scanner::Ptr{zbar_image_scanner_t}, symbology::zbar_symbol_type_t, config::zbar_config_t, value::Cint)::Cint
end

function zbar_image_scanner_get_config(scanner, symbology, config, value)
    @ccall libzbar.zbar_image_scanner_get_config(scanner::Ptr{zbar_image_scanner_t}, symbology::zbar_symbol_type_t, config::zbar_config_t, value::Ptr{Cint})::Cint
end

function zbar_image_scanner_parse_config(scanner, config_string)
    @ccall libzbar.zbar_image_scanner_parse_config(scanner::Ptr{zbar_image_scanner_t}, config_string::Ptr{Cchar})::Cint
end

function zbar_image_scanner_enable_cache(scanner, enable)
    @ccall libzbar.zbar_image_scanner_enable_cache(scanner::Ptr{zbar_image_scanner_t}, enable::Cint)::Cvoid
end

function zbar_image_scanner_recycle_image(scanner, image)
    @ccall libzbar.zbar_image_scanner_recycle_image(scanner::Ptr{zbar_image_scanner_t}, image::Ptr{zbar_image_t})::Cvoid
end

function zbar_image_scanner_get_results(scanner)
    @ccall libzbar.zbar_image_scanner_get_results(scanner::Ptr{zbar_image_scanner_t})::Ptr{zbar_symbol_set_t}
end

function zbar_scan_image(scanner, image)
    @ccall libzbar.zbar_scan_image(scanner::Ptr{zbar_image_scanner_t}, image::Ptr{zbar_image_t})::Cint
end

mutable struct zbar_decoder_s end

const zbar_decoder_t = zbar_decoder_s

# typedef void ( zbar_decoder_handler_t ) ( zbar_decoder_t * decoder )
const zbar_decoder_handler_t = Cvoid

function zbar_decoder_create()
    @ccall libzbar.zbar_decoder_create()::Ptr{zbar_decoder_t}
end

function zbar_decoder_destroy(decoder)
    @ccall libzbar.zbar_decoder_destroy(decoder::Ptr{zbar_decoder_t})::Cvoid
end

function zbar_decoder_set_config(decoder, symbology, config, value)
    @ccall libzbar.zbar_decoder_set_config(decoder::Ptr{zbar_decoder_t}, symbology::zbar_symbol_type_t, config::zbar_config_t, value::Cint)::Cint
end

function zbar_decoder_get_config(decoder, symbology, config, value)
    @ccall libzbar.zbar_decoder_get_config(decoder::Ptr{zbar_decoder_t}, symbology::zbar_symbol_type_t, config::zbar_config_t, value::Ptr{Cint})::Cint
end

function zbar_decoder_parse_config(decoder, config_string)
    @ccall libzbar.zbar_decoder_parse_config(decoder::Ptr{zbar_decoder_t}, config_string::Ptr{Cchar})::Cint
end

function zbar_decoder_get_configs(decoder, symbology)
    @ccall libzbar.zbar_decoder_get_configs(decoder::Ptr{zbar_decoder_t}, symbology::zbar_symbol_type_t)::Cuint
end

function zbar_decoder_reset(decoder)
    @ccall libzbar.zbar_decoder_reset(decoder::Ptr{zbar_decoder_t})::Cvoid
end

function zbar_decoder_new_scan(decoder)
    @ccall libzbar.zbar_decoder_new_scan(decoder::Ptr{zbar_decoder_t})::Cvoid
end

function zbar_decode_width(decoder, width)
    @ccall libzbar.zbar_decode_width(decoder::Ptr{zbar_decoder_t}, width::Cuint)::zbar_symbol_type_t
end

function zbar_decoder_get_color(decoder)
    @ccall libzbar.zbar_decoder_get_color(decoder::Ptr{zbar_decoder_t})::zbar_color_t
end

function zbar_decoder_get_data(decoder)
    @ccall libzbar.zbar_decoder_get_data(decoder::Ptr{zbar_decoder_t})::Ptr{Cchar}
end

function zbar_decoder_get_data_length(decoder)
    @ccall libzbar.zbar_decoder_get_data_length(decoder::Ptr{zbar_decoder_t})::Cuint
end

function zbar_decoder_get_type(decoder)
    @ccall libzbar.zbar_decoder_get_type(decoder::Ptr{zbar_decoder_t})::zbar_symbol_type_t
end

function zbar_decoder_get_modifiers(decoder)
    @ccall libzbar.zbar_decoder_get_modifiers(decoder::Ptr{zbar_decoder_t})::Cuint
end

function zbar_decoder_get_direction(decoder)
    @ccall libzbar.zbar_decoder_get_direction(decoder::Ptr{zbar_decoder_t})::Cint
end

function zbar_decoder_set_handler(decoder, handler)
    @ccall libzbar.zbar_decoder_set_handler(decoder::Ptr{zbar_decoder_t}, handler::Ptr{Cvoid})::Ptr{Cvoid}
end

function zbar_decoder_set_userdata(decoder, userdata)
    @ccall libzbar.zbar_decoder_set_userdata(decoder::Ptr{zbar_decoder_t}, userdata::Ptr{Cvoid})::Cvoid
end

function zbar_decoder_get_userdata(decoder)
    @ccall libzbar.zbar_decoder_get_userdata(decoder::Ptr{zbar_decoder_t})::Ptr{Cvoid}
end

mutable struct zbar_scanner_s end

const zbar_scanner_t = zbar_scanner_s

function zbar_scanner_create(decoder)
    @ccall libzbar.zbar_scanner_create(decoder::Ptr{zbar_decoder_t})::Ptr{zbar_scanner_t}
end

function zbar_scanner_destroy(scanner)
    @ccall libzbar.zbar_scanner_destroy(scanner::Ptr{zbar_scanner_t})::Cvoid
end

function zbar_scanner_reset(scanner)
    @ccall libzbar.zbar_scanner_reset(scanner::Ptr{zbar_scanner_t})::zbar_symbol_type_t
end

function zbar_scanner_new_scan(scanner)
    @ccall libzbar.zbar_scanner_new_scan(scanner::Ptr{zbar_scanner_t})::zbar_symbol_type_t
end

function zbar_scanner_flush(scanner)
    @ccall libzbar.zbar_scanner_flush(scanner::Ptr{zbar_scanner_t})::zbar_symbol_type_t
end

function zbar_scan_y(scanner, y)
    @ccall libzbar.zbar_scan_y(scanner::Ptr{zbar_scanner_t}, y::Cint)::zbar_symbol_type_t
end

function zbar_scan_rgb24(scanner, rgb)
    @ccall libzbar.zbar_scan_rgb24(scanner::Ptr{zbar_scanner_t}, rgb::Ptr{Cuchar})::zbar_symbol_type_t
end

function zbar_scanner_get_width(scanner)
    @ccall libzbar.zbar_scanner_get_width(scanner::Ptr{zbar_scanner_t})::Cuint
end

function zbar_scanner_get_edge(scn, offset, prec)
    @ccall libzbar.zbar_scanner_get_edge(scn::Ptr{zbar_scanner_t}, offset::Cuint, prec::Cint)::Cuint
end

function zbar_scanner_get_color(scanner)
    @ccall libzbar.zbar_scanner_get_color(scanner::Ptr{zbar_scanner_t})::zbar_color_t
end

# export symbols
for sym in filter(s -> startswith("$s", "zbar_"), names(@__MODULE__, all = true))
    @eval export $sym
end

end # module
