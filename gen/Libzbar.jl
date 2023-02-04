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
    ccall((:zbar_version, libzbar), Cint, (Ptr{Cuint}, Ptr{Cuint}, Ptr{Cuint}), major, minor, patch)
end

function zbar_set_verbosity(verbosity)
    ccall((:zbar_set_verbosity, libzbar), Cvoid, (Cint,), verbosity)
end

function zbar_increase_verbosity()
    ccall((:zbar_increase_verbosity, libzbar), Cvoid, ())
end

function zbar_get_symbol_name(sym)
    ccall((:zbar_get_symbol_name, libzbar), Ptr{Cchar}, (zbar_symbol_type_t,), sym)
end

function zbar_get_addon_name(sym)
    ccall((:zbar_get_addon_name, libzbar), Ptr{Cchar}, (zbar_symbol_type_t,), sym)
end

function zbar_get_config_name(config)
    ccall((:zbar_get_config_name, libzbar), Ptr{Cchar}, (zbar_config_t,), config)
end

function zbar_get_modifier_name(modifier)
    ccall((:zbar_get_modifier_name, libzbar), Ptr{Cchar}, (zbar_modifier_t,), modifier)
end

function zbar_get_orientation_name(orientation)
    ccall((:zbar_get_orientation_name, libzbar), Ptr{Cchar}, (zbar_orientation_t,), orientation)
end

function zbar_parse_config(config_string, symbology, config, value)
    ccall((:zbar_parse_config, libzbar), Cint, (Ptr{Cchar}, Ptr{zbar_symbol_type_t}, Ptr{zbar_config_t}, Ptr{Cint}), config_string, symbology, config, value)
end

function zbar_fourcc_parse(format)
    ccall((:zbar_fourcc_parse, libzbar), Culong, (Ptr{Cchar},), format)
end

function _zbar_error_spew(object, verbosity)
    ccall((:_zbar_error_spew, libzbar), Cint, (Ptr{Cvoid}, Cint), object, verbosity)
end

function _zbar_error_string(object, verbosity)
    ccall((:_zbar_error_string, libzbar), Ptr{Cchar}, (Ptr{Cvoid}, Cint), object, verbosity)
end

function _zbar_get_error_code(object)
    ccall((:_zbar_get_error_code, libzbar), zbar_error_t, (Ptr{Cvoid},), object)
end

mutable struct zbar_symbol_s end

const zbar_symbol_t = zbar_symbol_s

mutable struct zbar_symbol_set_s end

const zbar_symbol_set_t = zbar_symbol_set_s

function zbar_symbol_ref(symbol, refs)
    ccall((:zbar_symbol_ref, libzbar), Cvoid, (Ptr{zbar_symbol_t}, Cint), symbol, refs)
end

function zbar_symbol_get_type(symbol)
    ccall((:zbar_symbol_get_type, libzbar), zbar_symbol_type_t, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_get_configs(symbol)
    ccall((:zbar_symbol_get_configs, libzbar), Cuint, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_get_modifiers(symbol)
    ccall((:zbar_symbol_get_modifiers, libzbar), Cuint, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_get_data(symbol)
    ccall((:zbar_symbol_get_data, libzbar), Ptr{Cchar}, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_get_data_length(symbol)
    ccall((:zbar_symbol_get_data_length, libzbar), Cuint, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_get_quality(symbol)
    ccall((:zbar_symbol_get_quality, libzbar), Cint, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_get_count(symbol)
    ccall((:zbar_symbol_get_count, libzbar), Cint, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_get_loc_size(symbol)
    ccall((:zbar_symbol_get_loc_size, libzbar), Cuint, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_get_loc_x(symbol, index)
    ccall((:zbar_symbol_get_loc_x, libzbar), Cint, (Ptr{zbar_symbol_t}, Cuint), symbol, index)
end

function zbar_symbol_get_loc_y(symbol, index)
    ccall((:zbar_symbol_get_loc_y, libzbar), Cint, (Ptr{zbar_symbol_t}, Cuint), symbol, index)
end

function zbar_symbol_get_orientation(symbol)
    ccall((:zbar_symbol_get_orientation, libzbar), zbar_orientation_t, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_next(symbol)
    ccall((:zbar_symbol_next, libzbar), Ptr{zbar_symbol_t}, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_get_components(symbol)
    ccall((:zbar_symbol_get_components, libzbar), Ptr{zbar_symbol_set_t}, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_first_component(symbol)
    ccall((:zbar_symbol_first_component, libzbar), Ptr{zbar_symbol_t}, (Ptr{zbar_symbol_t},), symbol)
end

function zbar_symbol_xml(symbol, buffer, buflen)
    ccall((:zbar_symbol_xml, libzbar), Ptr{Cchar}, (Ptr{zbar_symbol_t}, Ptr{Ptr{Cchar}}, Ptr{Cuint}), symbol, buffer, buflen)
end

function zbar_symbol_set_ref(symbols, refs)
    ccall((:zbar_symbol_set_ref, libzbar), Cvoid, (Ptr{zbar_symbol_set_t}, Cint), symbols, refs)
end

function zbar_symbol_set_get_size(symbols)
    ccall((:zbar_symbol_set_get_size, libzbar), Cint, (Ptr{zbar_symbol_set_t},), symbols)
end

function zbar_symbol_set_first_symbol(symbols)
    ccall((:zbar_symbol_set_first_symbol, libzbar), Ptr{zbar_symbol_t}, (Ptr{zbar_symbol_set_t},), symbols)
end

function zbar_symbol_set_first_unfiltered(symbols)
    ccall((:zbar_symbol_set_first_unfiltered, libzbar), Ptr{zbar_symbol_t}, (Ptr{zbar_symbol_set_t},), symbols)
end

mutable struct zbar_image_s end

const zbar_image_t = zbar_image_s

# typedef void ( zbar_image_cleanup_handler_t ) ( zbar_image_t * image )
const zbar_image_cleanup_handler_t = Cvoid

# typedef void ( zbar_image_data_handler_t ) ( zbar_image_t * image , const void * userdata )
const zbar_image_data_handler_t = Cvoid

function zbar_image_create()
    ccall((:zbar_image_create, libzbar), Ptr{zbar_image_t}, ())
end

function zbar_image_destroy(image)
    ccall((:zbar_image_destroy, libzbar), Cvoid, (Ptr{zbar_image_t},), image)
end

function zbar_image_ref(image, refs)
    ccall((:zbar_image_ref, libzbar), Cvoid, (Ptr{zbar_image_t}, Cint), image, refs)
end

function zbar_image_convert(image, format)
    ccall((:zbar_image_convert, libzbar), Ptr{zbar_image_t}, (Ptr{zbar_image_t}, Culong), image, format)
end

function zbar_image_convert_resize(image, format, width, height)
    ccall((:zbar_image_convert_resize, libzbar), Ptr{zbar_image_t}, (Ptr{zbar_image_t}, Culong, Cuint, Cuint), image, format, width, height)
end

function zbar_image_get_format(image)
    ccall((:zbar_image_get_format, libzbar), Culong, (Ptr{zbar_image_t},), image)
end

function zbar_image_get_sequence(image)
    ccall((:zbar_image_get_sequence, libzbar), Cuint, (Ptr{zbar_image_t},), image)
end

function zbar_image_get_width(image)
    ccall((:zbar_image_get_width, libzbar), Cuint, (Ptr{zbar_image_t},), image)
end

function zbar_image_get_height(image)
    ccall((:zbar_image_get_height, libzbar), Cuint, (Ptr{zbar_image_t},), image)
end

function zbar_image_get_size(image, width, height)
    ccall((:zbar_image_get_size, libzbar), Cvoid, (Ptr{zbar_image_t}, Ptr{Cuint}, Ptr{Cuint}), image, width, height)
end

function zbar_image_get_crop(image, x, y, width, height)
    ccall((:zbar_image_get_crop, libzbar), Cvoid, (Ptr{zbar_image_t}, Ptr{Cuint}, Ptr{Cuint}, Ptr{Cuint}, Ptr{Cuint}), image, x, y, width, height)
end

function zbar_image_get_data(image)
    ccall((:zbar_image_get_data, libzbar), Ptr{Cvoid}, (Ptr{zbar_image_t},), image)
end

function zbar_image_get_data_length(img)
    ccall((:zbar_image_get_data_length, libzbar), Culong, (Ptr{zbar_image_t},), img)
end

function zbar_image_get_symbols(image)
    ccall((:zbar_image_get_symbols, libzbar), Ptr{zbar_symbol_set_t}, (Ptr{zbar_image_t},), image)
end

function zbar_image_set_symbols(image, symbols)
    ccall((:zbar_image_set_symbols, libzbar), Cvoid, (Ptr{zbar_image_t}, Ptr{zbar_symbol_set_t}), image, symbols)
end

function zbar_image_first_symbol(image)
    ccall((:zbar_image_first_symbol, libzbar), Ptr{zbar_symbol_t}, (Ptr{zbar_image_t},), image)
end

function zbar_image_set_format(image, format)
    ccall((:zbar_image_set_format, libzbar), Cvoid, (Ptr{zbar_image_t}, Culong), image, format)
end

function zbar_image_set_sequence(image, sequence_num)
    ccall((:zbar_image_set_sequence, libzbar), Cvoid, (Ptr{zbar_image_t}, Cuint), image, sequence_num)
end

function zbar_image_set_size(image, width, height)
    ccall((:zbar_image_set_size, libzbar), Cvoid, (Ptr{zbar_image_t}, Cuint, Cuint), image, width, height)
end

function zbar_image_set_crop(image, x, y, width, height)
    ccall((:zbar_image_set_crop, libzbar), Cvoid, (Ptr{zbar_image_t}, Cuint, Cuint, Cuint, Cuint), image, x, y, width, height)
end

function zbar_image_set_data(image, data, data_byte_length, cleanup_hndlr)
    ccall((:zbar_image_set_data, libzbar), Cvoid, (Ptr{zbar_image_t}, Ptr{Cvoid}, Culong, Ptr{Cvoid}), image, data, data_byte_length, cleanup_hndlr)
end

function zbar_image_free_data(image)
    ccall((:zbar_image_free_data, libzbar), Cvoid, (Ptr{zbar_image_t},), image)
end

function zbar_image_set_userdata(image, userdata)
    ccall((:zbar_image_set_userdata, libzbar), Cvoid, (Ptr{zbar_image_t}, Ptr{Cvoid}), image, userdata)
end

function zbar_image_get_userdata(image)
    ccall((:zbar_image_get_userdata, libzbar), Ptr{Cvoid}, (Ptr{zbar_image_t},), image)
end

function zbar_image_write(image, filebase)
    ccall((:zbar_image_write, libzbar), Cint, (Ptr{zbar_image_t}, Ptr{Cchar}), image, filebase)
end

function zbar_image_read(filename)
    ccall((:zbar_image_read, libzbar), Ptr{zbar_image_t}, (Ptr{Cchar},), filename)
end

mutable struct zbar_processor_s end

const zbar_processor_t = zbar_processor_s

function zbar_processor_create(threaded)
    ccall((:zbar_processor_create, libzbar), Ptr{zbar_processor_t}, (Cint,), threaded)
end

function zbar_processor_destroy(processor)
    ccall((:zbar_processor_destroy, libzbar), Cvoid, (Ptr{zbar_processor_t},), processor)
end

function zbar_processor_init(processor, video_device, enable_display)
    ccall((:zbar_processor_init, libzbar), Cint, (Ptr{zbar_processor_t}, Ptr{Cchar}, Cint), processor, video_device, enable_display)
end

function zbar_processor_request_size(processor, width, height)
    ccall((:zbar_processor_request_size, libzbar), Cint, (Ptr{zbar_processor_t}, Cuint, Cuint), processor, width, height)
end

function zbar_processor_request_interface(processor, version)
    ccall((:zbar_processor_request_interface, libzbar), Cint, (Ptr{zbar_processor_t}, Cint), processor, version)
end

function zbar_processor_request_iomode(video, iomode)
    ccall((:zbar_processor_request_iomode, libzbar), Cint, (Ptr{zbar_processor_t}, Cint), video, iomode)
end

function zbar_processor_force_format(processor, input_format, output_format)
    ccall((:zbar_processor_force_format, libzbar), Cint, (Ptr{zbar_processor_t}, Culong, Culong), processor, input_format, output_format)
end

function zbar_processor_set_data_handler(processor, handler, userdata)
    ccall((:zbar_processor_set_data_handler, libzbar), Ptr{Cvoid}, (Ptr{zbar_processor_t}, Ptr{Cvoid}, Ptr{Cvoid}), processor, handler, userdata)
end

function zbar_processor_set_userdata(processor, userdata)
    ccall((:zbar_processor_set_userdata, libzbar), Cvoid, (Ptr{zbar_processor_t}, Ptr{Cvoid}), processor, userdata)
end

function zbar_processor_get_userdata(processor)
    ccall((:zbar_processor_get_userdata, libzbar), Ptr{Cvoid}, (Ptr{zbar_processor_t},), processor)
end

function zbar_processor_set_config(processor, symbology, config, value)
    ccall((:zbar_processor_set_config, libzbar), Cint, (Ptr{zbar_processor_t}, zbar_symbol_type_t, zbar_config_t, Cint), processor, symbology, config, value)
end

function zbar_processor_set_control(processor, control_name, value)
    ccall((:zbar_processor_set_control, libzbar), Cint, (Ptr{zbar_processor_t}, Ptr{Cchar}, Cint), processor, control_name, value)
end

function zbar_processor_get_control(processor, control_name, value)
    ccall((:zbar_processor_get_control, libzbar), Cint, (Ptr{zbar_processor_t}, Ptr{Cchar}, Ptr{Cint}), processor, control_name, value)
end

function zbar_processor_parse_config(processor, config_string)
    ccall((:zbar_processor_parse_config, libzbar), Cint, (Ptr{zbar_processor_t}, Ptr{Cchar}), processor, config_string)
end

function zbar_processor_is_visible(processor)
    ccall((:zbar_processor_is_visible, libzbar), Cint, (Ptr{zbar_processor_t},), processor)
end

function zbar_processor_set_visible(processor, visible)
    ccall((:zbar_processor_set_visible, libzbar), Cint, (Ptr{zbar_processor_t}, Cint), processor, visible)
end

function zbar_processor_set_active(processor, active)
    ccall((:zbar_processor_set_active, libzbar), Cint, (Ptr{zbar_processor_t}, Cint), processor, active)
end

function zbar_processor_get_results(processor)
    ccall((:zbar_processor_get_results, libzbar), Ptr{zbar_symbol_set_t}, (Ptr{zbar_processor_t},), processor)
end

function zbar_processor_user_wait(processor, timeout)
    ccall((:zbar_processor_user_wait, libzbar), Cint, (Ptr{zbar_processor_t}, Cint), processor, timeout)
end

function zbar_process_one(processor, timeout)
    ccall((:zbar_process_one, libzbar), Cint, (Ptr{zbar_processor_t}, Cint), processor, timeout)
end

function zbar_process_image(processor, image)
    ccall((:zbar_process_image, libzbar), Cint, (Ptr{zbar_processor_t}, Ptr{zbar_image_t}), processor, image)
end

function zbar_processor_request_dbus(proc, req_dbus_enabled)
    ccall((:zbar_processor_request_dbus, libzbar), Cint, (Ptr{zbar_processor_t}, Cint), proc, req_dbus_enabled)
end

function zbar_processor_error_spew(processor, verbosity)
    ccall((:zbar_processor_error_spew, libzbar), Cint, (Ptr{zbar_processor_t}, Cint), processor, verbosity)
end

function zbar_processor_error_string(processor, verbosity)
    ccall((:zbar_processor_error_string, libzbar), Ptr{Cchar}, (Ptr{zbar_processor_t}, Cint), processor, verbosity)
end

function zbar_processor_get_error_code(processor)
    ccall((:zbar_processor_get_error_code, libzbar), zbar_error_t, (Ptr{zbar_processor_t},), processor)
end

mutable struct zbar_video_s end

const zbar_video_t = zbar_video_s

function zbar_video_create()
    ccall((:zbar_video_create, libzbar), Ptr{zbar_video_t}, ())
end

function zbar_video_destroy(video)
    ccall((:zbar_video_destroy, libzbar), Cvoid, (Ptr{zbar_video_t},), video)
end

function zbar_video_open(video, device)
    ccall((:zbar_video_open, libzbar), Cint, (Ptr{zbar_video_t}, Ptr{Cchar}), video, device)
end

function zbar_video_get_fd(video)
    ccall((:zbar_video_get_fd, libzbar), Cint, (Ptr{zbar_video_t},), video)
end

function zbar_video_request_size(video, width, height)
    ccall((:zbar_video_request_size, libzbar), Cint, (Ptr{zbar_video_t}, Cuint, Cuint), video, width, height)
end

function zbar_video_request_interface(video, version)
    ccall((:zbar_video_request_interface, libzbar), Cint, (Ptr{zbar_video_t}, Cint), video, version)
end

function zbar_video_request_iomode(video, iomode)
    ccall((:zbar_video_request_iomode, libzbar), Cint, (Ptr{zbar_video_t}, Cint), video, iomode)
end

function zbar_video_get_width(video)
    ccall((:zbar_video_get_width, libzbar), Cint, (Ptr{zbar_video_t},), video)
end

function zbar_video_get_height(video)
    ccall((:zbar_video_get_height, libzbar), Cint, (Ptr{zbar_video_t},), video)
end

function zbar_video_init(video, format)
    ccall((:zbar_video_init, libzbar), Cint, (Ptr{zbar_video_t}, Culong), video, format)
end

function zbar_video_enable(video, enable)
    ccall((:zbar_video_enable, libzbar), Cint, (Ptr{zbar_video_t}, Cint), video, enable)
end

function zbar_video_next_image(video)
    ccall((:zbar_video_next_image, libzbar), Ptr{zbar_image_t}, (Ptr{zbar_video_t},), video)
end

function zbar_video_set_control(video, control_name, value)
    ccall((:zbar_video_set_control, libzbar), Cint, (Ptr{zbar_video_t}, Ptr{Cchar}, Cint), video, control_name, value)
end

function zbar_video_get_control(video, control_name, value)
    ccall((:zbar_video_get_control, libzbar), Cint, (Ptr{zbar_video_t}, Ptr{Cchar}, Ptr{Cint}), video, control_name, value)
end

function zbar_video_get_controls(video, index)
    ccall((:zbar_video_get_controls, libzbar), Ptr{video_controls_s}, (Ptr{zbar_video_t}, Cint), video, index)
end

function zbar_video_get_resolutions(vdo, index)
    ccall((:zbar_video_get_resolutions, libzbar), Ptr{video_resolution_s}, (Ptr{zbar_video_t}, Cint), vdo, index)
end

function zbar_video_error_spew(video, verbosity)
    ccall((:zbar_video_error_spew, libzbar), Cint, (Ptr{zbar_video_t}, Cint), video, verbosity)
end

function zbar_video_error_string(video, verbosity)
    ccall((:zbar_video_error_string, libzbar), Ptr{Cchar}, (Ptr{zbar_video_t}, Cint), video, verbosity)
end

function zbar_video_get_error_code(video)
    ccall((:zbar_video_get_error_code, libzbar), zbar_error_t, (Ptr{zbar_video_t},), video)
end

mutable struct zbar_window_s end

const zbar_window_t = zbar_window_s

function zbar_window_create()
    ccall((:zbar_window_create, libzbar), Ptr{zbar_window_t}, ())
end

function zbar_window_destroy(window)
    ccall((:zbar_window_destroy, libzbar), Cvoid, (Ptr{zbar_window_t},), window)
end

function zbar_window_attach(window, x11_display_w32_hwnd, x11_drawable)
    ccall((:zbar_window_attach, libzbar), Cint, (Ptr{zbar_window_t}, Ptr{Cvoid}, Culong), window, x11_display_w32_hwnd, x11_drawable)
end

function zbar_window_set_overlay(window, level)
    ccall((:zbar_window_set_overlay, libzbar), Cvoid, (Ptr{zbar_window_t}, Cint), window, level)
end

function zbar_window_get_overlay(window)
    ccall((:zbar_window_get_overlay, libzbar), Cint, (Ptr{zbar_window_t},), window)
end

function zbar_window_draw(window, image)
    ccall((:zbar_window_draw, libzbar), Cint, (Ptr{zbar_window_t}, Ptr{zbar_image_t}), window, image)
end

function zbar_window_redraw(window)
    ccall((:zbar_window_redraw, libzbar), Cint, (Ptr{zbar_window_t},), window)
end

function zbar_window_resize(window, width, height)
    ccall((:zbar_window_resize, libzbar), Cint, (Ptr{zbar_window_t}, Cuint, Cuint), window, width, height)
end

function zbar_window_error_spew(window, verbosity)
    ccall((:zbar_window_error_spew, libzbar), Cint, (Ptr{zbar_window_t}, Cint), window, verbosity)
end

function zbar_window_error_string(window, verbosity)
    ccall((:zbar_window_error_string, libzbar), Ptr{Cchar}, (Ptr{zbar_window_t}, Cint), window, verbosity)
end

function zbar_window_get_error_code(window)
    ccall((:zbar_window_get_error_code, libzbar), zbar_error_t, (Ptr{zbar_window_t},), window)
end

function zbar_negotiate_format(video, window)
    ccall((:zbar_negotiate_format, libzbar), Cint, (Ptr{zbar_video_t}, Ptr{zbar_window_t}), video, window)
end

mutable struct zbar_image_scanner_s end

const zbar_image_scanner_t = zbar_image_scanner_s

function zbar_image_scanner_create()
    ccall((:zbar_image_scanner_create, libzbar), Ptr{zbar_image_scanner_t}, ())
end

function zbar_image_scanner_destroy(scanner)
    ccall((:zbar_image_scanner_destroy, libzbar), Cvoid, (Ptr{zbar_image_scanner_t},), scanner)
end

function zbar_image_scanner_set_data_handler(scanner, handler, userdata)
    ccall((:zbar_image_scanner_set_data_handler, libzbar), Ptr{Cvoid}, (Ptr{zbar_image_scanner_t}, Ptr{Cvoid}, Ptr{Cvoid}), scanner, handler, userdata)
end

function zbar_image_scanner_request_dbus(scanner, req_dbus_enabled)
    ccall((:zbar_image_scanner_request_dbus, libzbar), Cint, (Ptr{zbar_image_scanner_t}, Cint), scanner, req_dbus_enabled)
end

function zbar_image_scanner_set_config(scanner, symbology, config, value)
    ccall((:zbar_image_scanner_set_config, libzbar), Cint, (Ptr{zbar_image_scanner_t}, zbar_symbol_type_t, zbar_config_t, Cint), scanner, symbology, config, value)
end

function zbar_image_scanner_get_config(scanner, symbology, config, value)
    ccall((:zbar_image_scanner_get_config, libzbar), Cint, (Ptr{zbar_image_scanner_t}, zbar_symbol_type_t, zbar_config_t, Ptr{Cint}), scanner, symbology, config, value)
end

function zbar_image_scanner_parse_config(scanner, config_string)
    ccall((:zbar_image_scanner_parse_config, libzbar), Cint, (Ptr{zbar_image_scanner_t}, Ptr{Cchar}), scanner, config_string)
end

function zbar_image_scanner_enable_cache(scanner, enable)
    ccall((:zbar_image_scanner_enable_cache, libzbar), Cvoid, (Ptr{zbar_image_scanner_t}, Cint), scanner, enable)
end

function zbar_image_scanner_recycle_image(scanner, image)
    ccall((:zbar_image_scanner_recycle_image, libzbar), Cvoid, (Ptr{zbar_image_scanner_t}, Ptr{zbar_image_t}), scanner, image)
end

function zbar_image_scanner_get_results(scanner)
    ccall((:zbar_image_scanner_get_results, libzbar), Ptr{zbar_symbol_set_t}, (Ptr{zbar_image_scanner_t},), scanner)
end

function zbar_scan_image(scanner, image)
    ccall((:zbar_scan_image, libzbar), Cint, (Ptr{zbar_image_scanner_t}, Ptr{zbar_image_t}), scanner, image)
end

mutable struct zbar_decoder_s end

const zbar_decoder_t = zbar_decoder_s

# typedef void ( zbar_decoder_handler_t ) ( zbar_decoder_t * decoder )
const zbar_decoder_handler_t = Cvoid

function zbar_decoder_create()
    ccall((:zbar_decoder_create, libzbar), Ptr{zbar_decoder_t}, ())
end

function zbar_decoder_destroy(decoder)
    ccall((:zbar_decoder_destroy, libzbar), Cvoid, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_decoder_set_config(decoder, symbology, config, value)
    ccall((:zbar_decoder_set_config, libzbar), Cint, (Ptr{zbar_decoder_t}, zbar_symbol_type_t, zbar_config_t, Cint), decoder, symbology, config, value)
end

function zbar_decoder_get_config(decoder, symbology, config, value)
    ccall((:zbar_decoder_get_config, libzbar), Cint, (Ptr{zbar_decoder_t}, zbar_symbol_type_t, zbar_config_t, Ptr{Cint}), decoder, symbology, config, value)
end

function zbar_decoder_parse_config(decoder, config_string)
    ccall((:zbar_decoder_parse_config, libzbar), Cint, (Ptr{zbar_decoder_t}, Ptr{Cchar}), decoder, config_string)
end

function zbar_decoder_get_configs(decoder, symbology)
    ccall((:zbar_decoder_get_configs, libzbar), Cuint, (Ptr{zbar_decoder_t}, zbar_symbol_type_t), decoder, symbology)
end

function zbar_decoder_reset(decoder)
    ccall((:zbar_decoder_reset, libzbar), Cvoid, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_decoder_new_scan(decoder)
    ccall((:zbar_decoder_new_scan, libzbar), Cvoid, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_decode_width(decoder, width)
    ccall((:zbar_decode_width, libzbar), zbar_symbol_type_t, (Ptr{zbar_decoder_t}, Cuint), decoder, width)
end

function zbar_decoder_get_color(decoder)
    ccall((:zbar_decoder_get_color, libzbar), zbar_color_t, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_decoder_get_data(decoder)
    ccall((:zbar_decoder_get_data, libzbar), Ptr{Cchar}, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_decoder_get_data_length(decoder)
    ccall((:zbar_decoder_get_data_length, libzbar), Cuint, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_decoder_get_type(decoder)
    ccall((:zbar_decoder_get_type, libzbar), zbar_symbol_type_t, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_decoder_get_modifiers(decoder)
    ccall((:zbar_decoder_get_modifiers, libzbar), Cuint, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_decoder_get_direction(decoder)
    ccall((:zbar_decoder_get_direction, libzbar), Cint, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_decoder_set_handler(decoder, handler)
    ccall((:zbar_decoder_set_handler, libzbar), Ptr{Cvoid}, (Ptr{zbar_decoder_t}, Ptr{Cvoid}), decoder, handler)
end

function zbar_decoder_set_userdata(decoder, userdata)
    ccall((:zbar_decoder_set_userdata, libzbar), Cvoid, (Ptr{zbar_decoder_t}, Ptr{Cvoid}), decoder, userdata)
end

function zbar_decoder_get_userdata(decoder)
    ccall((:zbar_decoder_get_userdata, libzbar), Ptr{Cvoid}, (Ptr{zbar_decoder_t},), decoder)
end

mutable struct zbar_scanner_s end

const zbar_scanner_t = zbar_scanner_s

function zbar_scanner_create(decoder)
    ccall((:zbar_scanner_create, libzbar), Ptr{zbar_scanner_t}, (Ptr{zbar_decoder_t},), decoder)
end

function zbar_scanner_destroy(scanner)
    ccall((:zbar_scanner_destroy, libzbar), Cvoid, (Ptr{zbar_scanner_t},), scanner)
end

function zbar_scanner_reset(scanner)
    ccall((:zbar_scanner_reset, libzbar), zbar_symbol_type_t, (Ptr{zbar_scanner_t},), scanner)
end

function zbar_scanner_new_scan(scanner)
    ccall((:zbar_scanner_new_scan, libzbar), zbar_symbol_type_t, (Ptr{zbar_scanner_t},), scanner)
end

function zbar_scanner_flush(scanner)
    ccall((:zbar_scanner_flush, libzbar), zbar_symbol_type_t, (Ptr{zbar_scanner_t},), scanner)
end

function zbar_scan_y(scanner, y)
    ccall((:zbar_scan_y, libzbar), zbar_symbol_type_t, (Ptr{zbar_scanner_t}, Cint), scanner, y)
end

function zbar_scan_rgb24(scanner, rgb)
    ccall((:zbar_scan_rgb24, libzbar), zbar_symbol_type_t, (Ptr{zbar_scanner_t}, Ptr{Cuchar}), scanner, rgb)
end

function zbar_scanner_get_width(scanner)
    ccall((:zbar_scanner_get_width, libzbar), Cuint, (Ptr{zbar_scanner_t},), scanner)
end

function zbar_scanner_get_edge(scn, offset, prec)
    ccall((:zbar_scanner_get_edge, libzbar), Cuint, (Ptr{zbar_scanner_t}, Cuint, Cint), scn, offset, prec)
end

function zbar_scanner_get_color(scanner)
    ccall((:zbar_scanner_get_color, libzbar), zbar_color_t, (Ptr{zbar_scanner_t},), scanner)
end

end # module
