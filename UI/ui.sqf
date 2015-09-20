#define	colorGlobalChannel [1,0,0,1]
#define	colorSideChannel [0.196*1.4, 0.592*1.4, 0.706*1.4, 1]
#define	colorCommandChannel [0.8275*1.4, 0.8196*1.4, 0.1961*1.4, 1]
#define	colorGroupChannel [208/255, 240/255, 192/255, 1]
#define	colorVehicleChannel [0.863*1.4, 0.584*1.4, 0.0*1.4, 1]
#define	colorDirectChannel [1, 1, 1, 1]
#define	colorPlayerChannel [0.8, 0.7, 1, 1]
#define GR_W (((safezoneW/safezoneH) min 1.2)/40)
#define GR_H ((((safezoneW/safezoneH) min 1.2)/1.2)/25)

swt_markers_disable = false;
swt_markers_load_enabled = true;
swt_markers_load_enabled_for = true;
swt_markers_load_enabled_when = true;
swt_markers_bis_markers = false;
sweetk_s = 1;
swt_markers_time = 0;
swt_markers_MapTime = 0;
swt_markers_fast_text_N = false;
swt_markers_fast_text_G = false;
swt_markers_fast_text_T = false;
swt_markers_shiftState =  false;
swt_markers_ctrlState =   false;
swt_markers_altState =    false;
swt_markers_channel = localize "str_channel_group";
swt_markers_delayCoeff = 25;

if (isNil "swt_markers_pos_m") then {swt_markers_pos_m = [0,0]};

call compile preprocessfilelinenumbers '\swt_markers_a3\UI\MapHandlers.sqf';
call compile preprocessfilelinenumbers '\swt_markers_a3\UI\DisplayHandlers.sqf';

swt_markers_available_channels = [localize "str_channel_global",localize "str_channel_side",localize "str_channel_command",localize "str_channel_group",localize "str_channel_vehicle",localize "str_channel_direct"];
swt_markers_unavailable_channels = getArray (missionconfigfile >> "disableChannels");
_arr = swt_markers_available_channels;
swt_markers_available_channels = [];
{
	if !(_forEachIndex in swt_markers_unavailable_channels) then {
		swt_markers_available_channels pushBack _x;
	};
} forEach _arr;

swt_markers_getColorChannel = {
	_channel = _this select 0;
	_tag = _this select 1;
	_channel = switch (_channel) do {
		case "S": {format ["<%2 color='#46D3FF'>%1</%2>", localize "str_channel_side", _tag]};
	    case "C": {format ["<%2 color='#FFFF46'>%1</%2>", localize "str_channel_command", _tag]};
	    case "GL": {format ["<%2 color='#E34234'>%1</%2>", localize "str_channel_global", _tag]};
	    case "V": {format ["<%2 color='#FFD000'>%1</%2>", localize "str_channel_vehicle", _tag]};
	    case "GR": {format ["<%2 color='#D0F0C0'>%1</%2>", localize "str_channel_group", _tag]};
	    case "D": {format ["<%2 color='#FFFFFF'>%1</%2>", localize "str_channel_direct", _tag]};
	};
	_channel;
};

swt_markers_getColorName = {
	_name = _this select 0;
	_tag = _this select 1;
	{
		if (name _x == _name) exitWith {
			_name = switch (side _x) do {
				case west: {format ["<%2 color='#6495ED'>%1</%2>", _name, _tag]};
				case east: {format ["<%2 color='#E34234'>%1</%2>", _name, _tag]};
				case resistance: {format ["<%2 color='#50C878'>%1</%2>", _name, _tag]};
				case civilian: {format ["<%2 color='#FFED00'>%1</%2>", _name, _tag]};
			};
		};
	} forEach (playableUnits+switchableUnits);
	_name;
};

swt_markers_log = {
	_addzero = {
		if (_this<10) then {
			"0" + str _this;
		} else {
			str _this;
		};
	};
	_getFormatedTime = {
		_time =  _this;
		_hour = floor(abs(_time)/3600);
		_minute = floor(abs(_time)/60)%60;
		_second = round(abs(_time)%60);
		format ["%1:%2:%3: ", _hour call _addzero, _minute call _addzero, _second call _addzero];
	};

	_action = _this select 0;
	_params = _this select 1;
	if (swt_markers_logging) then {
		if !(player diarySubjectExists "SwtMarkersLog") then {
			player createDiarySubject ["SwtMarkersLog","SWT Markers"];
		};

		_sep = "<img image='#(argb,8,8,3)color(1,1,1,0.1)' height='2' width='512' />";
		_text = "";

		switch (_action) do {
		    case "CREATE": {
		    	_mark = _params select 0;
		    	_Chan = _params select 1;
				_Chan = [_Chan,"font"] call swt_markers_getColorChannel;
		    	_Type = _params select 4;
		    	_Name = _params select 8;
		    	_colorname = [_Name,"font"] call swt_markers_getColorName;
				_text = format [(time call _getFormatedTime) + (localize "STR_SWT_M_MARKCREATED") + _sep,
				 			_colorname,
							_mark,
							_Chan,
							(if (_Type==-2) then {toLower(localize "STR_SWT_M_LINE")} else {if (_Type==-3) then {toLower(localize "STR_SWT_M_ELLIPSE")} else {toLower(localize "STR_SWT_M_MARKER")}})
						];
		    };
		    case "DEL": {
		    	_Name  = _params select 0;
		    	_colorname = [_Name,"font"] call swt_markers_getColorName;
		    	_markParams = _params select 1;
		    	_mark = _markParams select 0;
		    	_owner = [(_markParams select 8),"font"] call swt_markers_getColorName;
				_Type = _markParams select 4;
		    	_text = format [(time call _getFormatedTime) + (localize "STR_SWT_M_MARKDELETED") + _sep,
				 			_colorname,
							_owner,
							_mark,
							(if (_Type==-2) then {toLower(localize "STR_SWT_M_LINE")} else {if (_Type==-3) then {toLower(localize "STR_SWT_M_ELLIPSE")} else {toLower(localize "STR_SWT_M_MARKER")}})
						];
		    };
		    case "DIR": {
		    	_Name  = _params select 0;
		    	_colorname = [_Name,"font"] call swt_markers_getColorName;
		    	_markParams = _params select 1;
		    	_mark = _markParams select 0;
		    	_owner = [(_markParams select 8),"font"] call swt_markers_getColorName;
				_Type = _markParams select 4;
		    	_text = format [(time call _getFormatedTime) + (localize "STR_SWT_M_MARKDIR") + "<font color='#F88379'><marker name='%3'>%4</marker></font>" + _sep,
				 			_colorname,
							_owner,
							_mark,
							(if (_Type==-2) then {toLower(localize "STR_SWT_M_LINE")} else {if (_Type==-3) then {toLower(localize "STR_SWT_M_ELLIPSE")} else {toLower(localize "STR_SWT_M_MARKER")}})
						];
		    };
			case "POS": {
		    	_Name  = _params select 0;
		    	_colorname = [_Name,"font"] call swt_markers_getColorName;
		    	_markParams = _params select 1;
		    	_mark = _markParams select 0;
		    	_owner = [(_markParams select 8),"font"] call swt_markers_getColorName;
				_Type = _markParams select 4;
		    	_text = format [(time call _getFormatedTime) + (localize "STR_SWT_M_MARKPOS") + "<font color='#F88379'><marker name='%3'>%4</marker></font>" + _sep,
				 			_colorname,
							_owner,
							_mark,
							(if (_Type==-2) then {toLower(localize "STR_SWT_M_LINE")} else {if (_Type==-3) then {toLower(localize "STR_SWT_M_ELLIPSE")} else {toLower(localize "STR_SWT_M_MARKER")}})
						];
		    };
		    case "LOAD": {
		    	_Name  = _params select 0;
		    	_colorname = [_Name,"font"] call swt_markers_getColorName;
		    	_count = _params select 1;
		    	_text = format [(time call _getFormatedTime) + (localize "STR_SWT_M_MARKLOAD") + _sep, _colorname, _count];
		    };
		};
		player createDiaryRecord ["SwtMarkersLog", ["Log", _text]];
	};
};

swt_markers_showInfo = {
	_addzero = {
		if (_this<10) then {
			"0" + str _this;
		} else {
			str _this;
		};
	};
	_getFormatedTime = {
		_time =  _this;

		_hour = floor(abs(_time)/3600);
		_minute = floor(abs(_time)/60)%60;
		_second = round(abs(_time)%60);

		_daytime = (swt_markers_daytime * 3600) + _time;
		_hourN = floor(abs(_daytime)/3600);
		_minuteN = floor(abs(_daytime)/60)%60;
		_secondN = round(abs(_daytime)%60);
		format ["%1:%2:%3 (%4:%5:%6)",_hour call _addzero, _minute call _addzero, _second call _addzero, _hourN call _addzero, _minuteN call _addzero, _secondN call _addzero];
	};

	_ctrl_info = _display displayCtrl 228;
	_find = false;
	{
		_pos = getMarkerPos (_x select 0);
		_pos = (_this select 0) ctrlMapWorldToScreen _pos;
		if (([_pos,swt_markers_pos_m] call bis_fnc_distance2D) < 0.025) exitWith {
			_find = true;
			if (swt_markers_hold) then {
				_mark = _x select 0;
				_id = + toArray (_mark);
				_id deleteRange [0,6];
				_id = toString (_id);
				_name = _x select 8;
				_channel = _x select 1;
				_channel = [_channel,"t"] call swt_markers_getColorChannel;
				_time = _x select 9;
				_colorname = [_name,"t"] call swt_markers_getColorName;
				_Type = _x select 4;
				_ctrl_info ctrlSetStructuredText parseText format ["<t size='0.8'>\
<t align='center' color='#F88379'>%1 ID: %2" + (if (!isNil {_x select 10}) then {localize "STR_SWT_M_INFOLOADED"} else {""}) + "</t><br/>" + (localize "STR_SWT_M_INFOWIN") + (_time call _getFormatedTime) + "</t>",
				(if (_Type==-2) then {localize "STR_SWT_M_LINE"} else {if (_Type==-3) then {localize "STR_SWT_M_ELLIPSE"} else {localize "STR_SWT_M_MARKER"}}), _id, _colorname, _channel];

				_ctrl_pos = ctrlPosition _ctrl_info;
				if ((markerText _mark) == "") then {
					_ctrl_info ctrlSetPosition [(_pos select 0) - (0.05)/2 + 0.07, (_pos select 1) - (_ctrl_pos select 3)/2, _ctrl_pos select 2, _ctrl_pos select 3];
				} else {
					_ctrl_info ctrlSetPosition [(_pos select 0) + (0.05)/2 - 0.07 - (_ctrl_pos select 2), (_pos select 1) - (_ctrl_pos select 3)/2, _ctrl_pos select 2, _ctrl_pos select 3];
				};
				_ctrl_info ctrlCommit 0;
				_ctrl_info ctrlShow true;
			};
		};
	} forEach swt_markers_allMarkers_params;
	if (!_find) then {
		_ctrl_info ctrlShow false;
		swt_markers_hold = false;
		swt_markers_MapTime = 0;
	};
};

swt_markers_fast_text = {
	disableSerialization;
	_ctrl = _this select 0;
	_action = _this select 1;
	ctrlSetFocus ((ctrlParent _ctrl) displayCtrl 203);
	switch (_action) do {
	    case "N": {
	    	if (isNil {_this select 2}) then {swt_markers_fast_text_N = !swt_markers_fast_text_N};
	    	if (swt_markers_fast_text_N) then {
	    		_ctrl ctrlSetTextColor [1,1,1,1];
	  		} else {
	  			_ctrl ctrlSetTextColor [1,1,1,0.25];
	  		};
		};

	    case "G": {
	     	if (isNil {_this select 2}) then {swt_markers_fast_text_G = !swt_markers_fast_text_G};
	    	if (swt_markers_fast_text_G) then {
	    		_ctrl ctrlSetTextColor [1,1,1,1];
	  		} else {
	  			_ctrl ctrlSetTextColor [1,1,1,0.25];
	  		};
	    };

	    case "T": {
	     	if (isNil {_this select 2}) then {swt_markers_fast_text_T = !swt_markers_fast_text_T};
	    	if (swt_markers_fast_text_T) then {
	    		_ctrl ctrlSetTextColor [1,1,1,1];
	  		} else {
	  			_ctrl ctrlSetTextColor [1,1,1,0.25];
	  		};
	    };
	};

};

swt_markers_setChannel = {
	private ["_display","_text","_control"];
	disableSerialization;
	_display = _this select 0;

	_text = _this select 1;
	_control = _display displayCtrl 1100;
	_control ctrlsetstructuredtext parsetext format ["<t size='0.8'>%1</t>","Description:"];
	if (_text == "") then {_text = localize "str_channel_group"};
	_control = _display displayCtrl 1100;
	_control ctrlsetstructuredtext parsetext format ["<t size='0.8'>%1</t>",_text];

	switch (_text) do {
		case (localize "str_channel_side"): {_control ctrlSetTextColor colorSideChannel;};
		case (localize "str_channel_command"): {_control ctrlSetTextColor colorCommandChannel;};
		case (localize "str_channel_direct"): {_control ctrlSetTextColor [1,1,1,1]};
		case (localize "str_channel_global"): {_control ctrlSetTextColor colorGlobalChannel;};
		case (localize "str_channel_vehicle"): {_control ctrlSetTextColor colorVehicleChannel;};
		case (localize "str_channel_group"): {_control ctrlSetTextColor colorGroupChannel;};
	};

};

swt_markers_set_butt = {
	private ["_display"];
	disableSerialization;
	_display = ctrlparent (_this select 0);
	_combo_color = [2100,2101,2102,2103,2104,2105];
	_combo_icon = [2106,2107,2108,2109,2110,2111];
	ctrlSetFocus (_display displayCtrl 203);

	if (isnil "RscDisplayInsertMarker_set_butt") then {
		{
			(_display displayCtrl _x) ctrlShow true;
			(_display displayCtrl _x) ctrlSetFade 0;
			(_display displayCtrl _x) ctrlCommit 0.2;
		} forEach (_combo_color+_combo_icon+[228]);
		_display call swt_markers_load_comboboxes;
		RscDisplayInsertMarker_set_butt = true;
	} else {
		{
			(_display displayCtrl _x) ctrlSetFade 1;
			(_display displayCtrl _x) ctrlCommit 0.2;
		} forEach (_combo_color+_combo_icon+[228,1104]);
		waitUntil {ctrlCommitted (_display displayCtrl 2111)};
		{(_display displayCtrl _x) ctrlShow false} forEach (_combo_color+_combo_icon+[228,1104]);
		RscDisplayInsertMarker_set_butt = nil;
		swt_markers_adv_set = nil;
	};
};

swt_markers_adv_set_butt = {
	private ["_display"];
	disableSerialization;
	_display = ctrlparent (_this select 0);
	ctrlSetFocus (_display displayCtrl 203);
	if (isnil "swt_markers_adv_set") then {
		swt_markers_adv_set = true;
		(_display displayCtrl 229) cbSetChecked swt_markers_show_butt;
		(_display displayCtrl 231) cbSetChecked swt_markers_show_icon;
		(_display displayCtrl 233) cbSetChecked swt_markers_show_color;
		(_display displayCtrl 235) cbSetChecked swt_markers_show_lb;
		(_display displayCtrl 237) cbSetChecked swt_markers_save_text;
		(_display displayCtrl 239) cbSetChecked swt_markers_save_mode;
		(_display displayCtrl 241) cbSetChecked swt_markers_show_info;
		(_display displayCtrl 243) cbSetChecked swt_markers_show_back;
		(_display displayCtrl 245) cbSetChecked swt_markers_save_mark;
		(_display displayCtrl 247) cbSetChecked swt_markers_logging;
		(_display displayCtrl 249) cbSetChecked swt_markers_mark_info;
		if (swt_markers_DisableLoc) then {
			(_display displayCtrl 350) ctrlSetText (localize "STR_SWT_M_ENABLE");
		} else {
			(_display displayCtrl 350) ctrlSetText (localize "STR_SWT_M_DISABLE");
		};
		(_display displayCtrl 451) ctrlSetText swt_markers_fast_text_T_saved;
		(_display displayCtrl 1104) ctrlShow true;
		(_display displayCtrl 1104) ctrlSetFade 0;
		(_display displayCtrl 1104) ctrlCommit 0.2;
	} else {
		swt_markers_adv_set = nil;
		(_display displayCtrl 1104) ctrlSetFade 1;
		(_display displayCtrl 1104) ctrlCommit 0.2;
		waitUntil {ctrlCommitted (_display displayCtrl 1104)};
		(_display displayCtrl 1104) ctrlShow false;
	};
};

swt_markers_lb_sel = {
	disableSerialization;
	_num = ctrlIDC (_this select 0) - 2100; //TODO: FIX ME PLS
	ctrlSetFocus (_display displayCtrl 203);
	switch (_num < 6) do {
	    case true: {
	    	_class = (_this select 0) lbData (_this select 1);
	    	if (_class == "" or {_class == (swt_marker_color_slot_params select _num)}) exitWith {};
	    	swt_marker_color_slot_params set [_num,_class];
	    	profileNamespace setVariable ["swt_marker_color_slot_params", swt_marker_color_slot_params];
	    	saveProfileNamespace;
	    	_slot_color = getArray (configFile >> "CfgMarkerColors" >> _class >> "color");

			{
				if (typeName _x != "SCALAR") then {
					_slot_color set [_forEachIndex, call compile _x];
	    		};
	  		} forEach _slot_color;
	  		((ctrlParent (_this select 0)) displayCtrl (1200+_num)) ctrlSetTextColor [_slot_color select 0, _slot_color select 1, _slot_color select 2, 0.6];
			((ctrlParent (_this select 0)) displayCtrl (1200+_num)) ctrlSetActiveColor _slot_color;
	    };

	    case false: { //icon
	     	_class = (_this select 0) lbData (_this select 1);
	     	if (_class == "" or {_class == (swt_marker_icon_slot_params select (_num-6))}) exitWith {};
	     	swt_marker_icon_slot_params set [_num-6,_class];
	    	profileNamespace setVariable ["swt_marker_icon_slot_params", swt_marker_icon_slot_params];
	    	saveProfileNamespace;
	    	_slot_icon = getText (configFile >> "CfgMarkers" >> _class >> "icon");
	    	((ctrlParent (_this select 0)) displayCtrl (1300+_num-6)) ctrlSetText _slot_icon;
	    	((ctrlParent (_this select 0)) displayCtrl (1400+_num-6)) ctrlSetText _slot_icon;
	    };
	};
};

swt_markers_lb_sel_adv = {
	disableSerialization;
	ctrlSetFocus ((ctrlParent (_this select 0)) displayCtrl 203);
	switch (ctrlIDC (_this select 0)) do {
	    case 15000: {
			_class = (_this select 0) lbData (_this select 1);
			swt_markers_mark_color = _class;
			swt_marker_color_arr = getArray (configFile >> "CfgMarkerColors" >> swt_markers_mark_color >> "color");
			{
				if (typeName _x != "SCALAR") then {
		        	swt_marker_color_arr set [_forEachIndex, call compile _x];
		    	};
		    } forEach swt_marker_color_arr;
		    ((ctrlParent (_this select 0)) displayCtrl 204) ctrlSetTextColor swt_marker_color_arr;
		    {
		    	((ctrlParent (_this select 0)) displayCtrl _x) ctrlSetTextColor swt_marker_color_arr;
			} forEach _controls_icon_pic;
	    };

	    case 15001: {
			_class = (_this select 0) lbData (_this select 1);
			swt_markers_mark_type = _class;
			swt_pic = getText (configFile >> "cfgMarkers" >> swt_markers_mark_type >> "icon");
			((ctrlParent (_this select 0)) displayCtrl 204) ctrlSetText swt_pic;
	    };
	};
};


swt_markers_profileNil = {
	_version = 2;
	if (isNil {profileNamespace getVariable "swt_markers_params_version"}) then {
		profileNamespace setVariable ["swt_markers_params_version", _version];
		saveProfileNamespace;
		call swt_def;
	};
	if ((profileNamespace getVariable "swt_markers_params_version") != _version) exitWith {
		systemChat (localize "STR_SWT_M_MESS_OLD");
		profileNamespace setVariable ["swt_markers_params_version", _version];
		saveProfileNamespace;
		call swt_def;
	};

	swt_marker_color_slot_params = [] + (call compile (str (profileNamespace getVariable "swt_marker_color_slot_params")));
	swt_marker_icon_slot_params = [] + (call compile (str (profileNamespace getVariable "swt_marker_icon_slot_params")));
	swt_marker_settings_params = [] + (call compile (str (profileNamespace getVariable "swt_marker_settings_params")));
	swt_markers_show_butt = swt_marker_settings_params select 0;
	swt_markers_show_icon = swt_marker_settings_params select 1;
	swt_markers_show_color = swt_marker_settings_params select 2;
	swt_markers_show_lb = swt_marker_settings_params select 3;
	swt_markers_save_mode = swt_marker_settings_params select 4;
	swt_markers_save_text = swt_marker_settings_params select 5;
	swt_markers_show_info = swt_marker_settings_params select 6;
	swt_markers_show_back = swt_marker_settings_params select 7;
	swt_markers_save_mark = swt_marker_settings_params select 8;
	swt_markers_fast_text_T_saved = swt_marker_settings_params select 9;
	swt_markers_logging = swt_marker_settings_params select 10;
	swt_markers_mark_info = swt_marker_settings_params select 11;

	swt_cfgMarkerColors = "true" configClasses (configfile >> "CfgMarkerColors");
	swt_cfgMarkers = "getNumber (_x >> 'scope') > 0 && !(getText (_x >> 'markerClass') in ['NATO_Sizes','Locations','Flags'])" configClasses (configfile >> "CfgMarkers");
	if (isNil {swt_cfgMarkerColors_names}) then {
		swt_cfgMarkerColors_names = [];
		{swt_cfgMarkerColors_names pushBack (configName _x)} forEach swt_cfgMarkerColors;
	};

	if (isNil {swt_cfgMarkers_names}) then {
		swt_cfgMarkers_names = [];
		{swt_cfgMarkers_names pushBack (configName _x)} forEach swt_cfgMarkers;
	};

	swt_markers_text = "";
	swt_markers_loaded = false;

	if (isNil "swt_markers_mark_type") then {
		swt_markers_mark_type = swt_marker_icon_slot_params select 0;
		swt_pic = getText (configFile >> "cfgMarkers" >> swt_markers_mark_type >> "icon");
	};

	if (isNil "swt_markers_mark_color") then {
		swt_markers_mark_color = swt_marker_color_slot_params select 0;
		swt_marker_color_arr = getArray (configFile >> "CfgMarkerColors" >> swt_markers_mark_color >> "color");
		{
			if (typeName _x != "SCALAR") then {
				swt_marker_color_arr set [_forEachIndex, call compile _x];
			};
	    } forEach swt_marker_color_arr;
	};
};

swt_def = {
	systemChat (localize "STR_SWT_M_MESS_DEF");
	profileNamespace setVariable ["swt_marker_color_slot_params", ["ColorBlue","ColorRed","ColorGreen","ColorBlack","ColorWhite","ColorYellow"]];
	profileNamespace setVariable ["swt_marker_icon_slot_params", ["mil_dot","o_inf","o_armor","hd_pickup","hd_warning","hd_unknown"]];
	profileNamespace setVariable ["swt_marker_settings_params", [false,true,true,false,true,false,true,true,true,"",true, true]];
	saveProfileNamespace;
	call swt_markers_profileNil;
};

swt_markers_load_comboboxes = {
	disableSerialization;
	private ['_display'];
	_display = _this;
	_combo_color = [2100,2101,2102,2103,2104,2105];
	_combo_icon = [2106,2107,2108,2109,2110,2111];

	{
		_marker	= _x;
		_scope = getNumber (_marker >> "scope");
		_pic = getText (_marker >> "icon");
		_name = getText (_marker >> "name");

		{
			_index = (_display displayCtrl _x) lbAdd _name;
			(_display displayCtrl _x) lbSetPicture [_index, _pic];
			(_display displayCtrl _x) lbSetData [_index, configName _marker];
			if ((configName _marker) isEqualTo (swt_marker_icon_slot_params select _forEachIndex)) then {
				(_display displayCtrl _x) lbSetCurSel _index;
			};
		} forEach _combo_icon;
	} forEach swt_cfgMarkers;

	{
		_color_type	= _x;
		_swt_markers_mark_color = getArray (_color_type >> "color");
		_name = getText (_color_type >> "name");

		{
			if (typeName _x != "SCALAR") then {
				_swt_markers_mark_color set [_forEachIndex, call compile _x];
			};
		} forEach _swt_markers_mark_color;

		{
			_index = (_display displayCtrl _x) lbAdd _name;
			(_display displayCtrl _x) lbSetPicture [_index, format["#(argb,8,8,3)color(%1,%2,%3,%4)", _swt_markers_mark_color select 0, _swt_markers_mark_color select 1, _swt_markers_mark_color select 2, _swt_markers_mark_color select 3]];
			(_display displayCtrl _x) lbSetData [_index, configName _color_type];
			if ((configName _color_type) isEqualTo (swt_marker_color_slot_params select _forEachIndex)) then {
				(_display displayCtrl _x) lbSetCurSel _index;
			};

		} forEach _combo_color;
	} forEach swt_cfgMarkerColors;
};

swt_markers_setIcon = {
	disableSerialization;
	ctrlSetFocus ((ctrlParent (_this select 0)) displayCtrl 203);
	_num = (_this select 1);
	swt_markers_mark_type = swt_marker_icon_slot_params select _num;
	swt_pic = (ctrlText (_this select 0));
	((ctrlParent (_this select 0)) displayCtrl 204) ctrlSetText swt_pic;
};

swt_markers_setColor = {
	_controls_icon_pic = [1400,1401,1402,1403,1404,1405];
	_num = (_this select 1);
	swt_markers_mark_color = swt_marker_color_slot_params select _num;
	ctrlSetFocus ((ctrlParent (_this select 0)) displayCtrl 203);
	swt_marker_color_arr = getArray (configFile >> "CfgMarkerColors" >> swt_markers_mark_color >> "color");
	{
	    if (typeName _x != "SCALAR") then {
	        swt_marker_color_arr set [_forEachIndex, call compile _x];
	    };
	} forEach swt_marker_color_arr;

	{
		((ctrlParent (_this select 0)) displayCtrl _x) ctrlSetTextColor swt_marker_color_arr;
	} forEach _controls_icon_pic+[204];
};

swt_markers_changeIcon = {
	private ['_control','_curr_num','_dir'];
	disableSerialization;
	_display = _this select 0;
	_control = _display displayCtrl 204;
	_dir = _this select 1;
	_curr_num = swt_marker_icon_slot_params find swt_markers_mark_type;
	switch (_dir) do {
	    case 'UP': {
	    	_curr_num = _curr_num+1;
	    	if (_curr_num>((count swt_marker_icon_slot_params) - 1)) then {_curr_num = 0};
	    };

	    case 'DOWN': {
	     	_curr_num = _curr_num-1;
	     	if (_curr_num<0) then {_curr_num = (count swt_marker_icon_slot_params) - 1};
	    };
	};
	swt_markers_mark_type = swt_marker_icon_slot_params select _curr_num;
	swt_pic = getText (configFile >> "cfgMarkers" >> swt_markers_mark_type >> "icon");
	_control ctrlSetText swt_pic;
};

swt_markers_changeColor = {
	private ['_control','_curr_num','_dir'];
	disableSerialization;
	_display = _this select 0;
	_control = _display displayCtrl 204;
	_dir = _this select 1;
	_curr_num = swt_marker_color_slot_params find swt_markers_mark_color;
	switch (_dir) do {
	    case 'UP': {
	    	_curr_num = _curr_num+1;
	    	if (_curr_num>((count swt_marker_color_slot_params) - 1)) then {_curr_num = 0};
	    };

	    case 'DOWN': {
	     	_curr_num = _curr_num-1;
	     	if (_curr_num<0) then {_curr_num = (count swt_marker_color_slot_params) - 1};
	    };
	};
	swt_markers_mark_color = swt_marker_color_slot_params select _curr_num;
	swt_marker_color_arr = getArray (configFile >> "CfgMarkerColors" >> swt_markers_mark_color >> "color");
	{
		if (typeName _x != "SCALAR") then {
        	swt_marker_color_arr set [_forEachIndex, call compile _x];
    	};
    } forEach swt_marker_color_arr;
    _control ctrlSetTextColor swt_marker_color_arr;
    {(_display displayCtrl _x) ctrlSetTextColor swt_marker_color_arr} forEach _controls_icon_pic;
};

swt_markers_changeChannel = {
	private ['_curr_num','_dir'];
	_dir = _this select 1;
	_curr_num = swt_markers_available_channels find swt_markers_channel;
	switch (_dir) do {
	    case 'UP': {
	    	_curr_num = _curr_num+1;
	    	if (_curr_num>((count swt_markers_available_channels) - 1)) then {_curr_num = 0};
	    };

	    case 'DOWN': {
	     	_curr_num = _curr_num-1;
	     	if (_curr_num<0) then {_curr_num = (count swt_markers_available_channels) - 1};
	    };
	};
	swt_markers_channel = swt_markers_available_channels select _curr_num;
	[(_this select 0),swt_markers_channel] call swt_markers_setChannel;
};



swt_markers_click_chann = {
	disableSerialization;
	_display = ctrlParent (_this select 0);
	ctrlSetFocus (_display displayCtrl 203);
	[_display, 'UP'] call swt_markers_changeChannel;
};

swt_get_mark_param = {
	_mark = _this;
	_markerType  = markerType _mark;
	_markerColor = markerColor _mark;
	_markerPos   = markerPos _mark;
	_markerText  = markerText _mark;
	_markerDir   = markerDir _mark;
	_markerSize  = markerSize _mark;
	_markerAlpha = markerAlpha _mark;

	[_mark,[_markerType,_markerColor,_markerPos,_markerText,_markerDir,_markerSize,_markerAlpha]];
};

swt_markers_cb_butt = compile preprocessFileLineNumbers '\swt_markers_a3\UI\checkBoxesSett.sqf';


swt_str_Replace = {
	private ["_str","_old","_new","_out","_tmp","_jm","_la","_lo","_ln","_j","_arr"];
	_str = _this select 0;
	_arr = toArray _str;
	_la = count _arr;
	_old = _this select 1;
	_new = _this select 2;
	_lo = count (toArray _old);
	_ln = count (toArray _new);
	_out = "";
	{
		_tmp = "";
		if (_forEachIndex <= _la -_lo) then {
			for "_j" from _forEachIndex to ( _forEachIndex + _lo - 1) do {
				_tmp = _tmp + toString ([_arr select _j]);
			};
		};
		if (_tmp == _old) then {
			_out = _out + _new;
			_forEachIndex = _forEachIndex + _lo - 1;
		} else {
			_out = _out + toString ([_arr select _forEachIndex]);
		};
	} forEach _arr;
	_out
};

swt_markers_fnc_save_markers = {
	private ["_arr"];
	_arr = + swt_markers_allMarkers_params;
	_arr_copy = [];
	{
		_tmp = + _x;
		_tmp deleteRange [0,2];
		_tmp deleteRange [6,count _tmp - 1];
		_arr_copy pushBack (+ _tmp);
	} forEach _arr;
	if (_this isEqualTo "CLIP") then {copyToClipboard str _arr_copy} else {profileNamespace setVariable ["swt_markers_save_arr", _arr_copy]};
	saveProfileNamespace;
	systemChat format [localize "STR_SWT_M_MESS_SAVEDMARKS", count _arr_copy];
};

swt_markers_fnc_load_markers = {
	if (swt_markers_load_enabled and(((swt_markers_load_enabled_for) and (((leader player == player) or (((effectiveCommander (vehicle player)) == player) and (vehicle player != player))))) or (!swt_markers_load_enabled_for))and((swt_markers_load_enabled_when)or((!swt_markers_load_enabled_when)and!(time>0)))) then {
		private ["_arr"];
		_arr =  (if (isNil {_this select 1}) then {[] + (profileNamespace getVariable "swt_markers_save_arr")} else {call compile ("[]+" + ([(_this select 1),";",""] call swt_str_Replace) + "+[]")});
		if !(_arr isEqualTo []) then {
			if (count _arr > 500) exitWith {systemChat (format [localize "STR_SWT_M_MESS_CANTLOAD", count _arr, 500]);};
			_copy_arr = [];
			{
				_copy_arr pushBack (["",""] + _x);
			} forEach _arr;
			swt_markers_sys_load = [player, _copy_arr];
			publicVariableServer "swt_markers_sys_load";
			if (isServer && !isMultiplayer) then {swt_markers_sys_load call swt_markers_logicServer_load;};
			((_this select 0) select 0) ctrlEnable false;
			swt_markers_loaded = true;
		} else {
			systemChat (localize "STR_SWT_M_MESS_NOMARKS");
		};
	} else {systemChat (localize "STR_SWT_M_MESS_CANTDO")};
};


swt_markers_scale = {
	disableSerialization;
	_pos = ctrlPosition (_display displayCtrl 204);

	_c_x = (_pos select 0) + ((_pos select 2)/2);
	_c_y = (_pos select 1) + ((_pos select 3)/2);
	_new_h = (0.0666667*sweetk_s) ;
	_new_w = (0.05*sweetk_s) ;
	_new_x = _c_x -(_new_w/2) ;
	_new_y = _c_y -(_new_h/2) ;

	(_display displayCtrl 204) ctrlSetPosition [
		_new_x,
		_new_y,
		_new_w,
		_new_h
	];
	(_display displayCtrl 204) ctrlCommit 0;
};


swt_markers_info_buttons = {
	disableSerialization;
	private ["_pos","_act","_control","_display"];
	_control = _this select 0;
	_display = ctrlParent (_this select 0);
	_act = _this select 1;
	//ctrlSetFocus (_display displayCtrl 203);
	switch (_act) do {
	    case 'info': {
	    	_pos = ctrlPosition (_display displayCtrl 1101);
	    	(_display displayCtrl 1101) ctrlSetPosition [_pos select 0, _pos select 1, _pos select 2, 25 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)];
	    	(_display displayCtrl 1101) ctrlCommit 0;
	    	(_display displayCtrl 1101) ctrlsetstructuredtext parsetext format [
	    			localize "STR_SWT_M_INFOTXT",
					"#F88379"
				];
	    };

	     case 'sett': {
	     	_pos = ctrlPosition (_display displayCtrl 1101);
	    	(_display displayCtrl 1101) ctrlSetPosition [_pos select 0, _pos select 1, _pos select 2, 20 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)];
	    	(_display displayCtrl 1101) ctrlCommit 0;
	    	(_display displayCtrl 1101) ctrlsetstructuredtext parsetext format [
					localize "STR_SWT_M_SETTXT",
					"#F88379"
				];
	    };

	     case 'author': {
	     	_pos = ctrlPosition (_display displayCtrl 1101);
	    	(_display displayCtrl 1101) ctrlSetPosition [_pos select 0, _pos select 1, _pos select 2, 10 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)];
	    	(_display displayCtrl 1101) ctrlCommit 0;
	    	(_display displayCtrl 1101) ctrlsetstructuredtext parsetext format [
					localize "STR_SWT_M_ATXT",
					"#F88379","http://goo.gl/AcloSD","http://goo.gl/rc5eKA"
				];
	    };
	};
};
