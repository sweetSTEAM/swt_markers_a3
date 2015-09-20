

swt_markers_MapMouseUp = {
	if (_this select 1 == 0) then {
		if !(isNil "swt_mark_to_change_dir") then {
			_dir = + swt_markers_direction;
			_mark = swt_mark_to_change_dir;
			swt_markers_sys_change_mark = ["DIR", player, _mark, _mark call swt_markers_getChannel, _dir];
			if (!isMultiplayer) then {swt_markers_sys_change_mark call swt_markers_logicServer_change_mark};
			publicVariableServer "swt_markers_sys_change_mark";
			swt_mark_to_change_dir = nil;
			swt_markers_direction = nil;
		};
		if !(isNil "swt_markers_line_params_world") then {
			deleteMarkerLocal "SWT_MARKERS LOCAL LINE";
			deleteMarkerLocal "SWT_MARKERS LOCAL INFO";

			if !((swt_markers_line_params_world select 0) isEqualTo (swt_markers_line_params_world select 1)) then
			{
				_coords = + swt_markers_line_params_world;
				["line", _coords] call swt_markers_sys_sendMark;
			};
			swt_markers_line_params_world = nil;
		};
		if !(isNil "swt_markers_ellipse") then {
			deleteMarkerLocal "SWT_MARKERS LOCAL ELLIPSE";
			deleteMarkerLocal "SWT_MARKERS LOCAL INFO";
			if !((swt_markers_ellipse select 0) isEqualTo (swt_markers_ellipse select 1)) then
			{
				_coords = + swt_markers_ellipse;
				["ellipse",_coords] call swt_markers_sys_sendMark;
			};
			swt_markers_ellipse = nil;
		};
		if !(isNil "swt_mark_to_change_pos") then {
			_coords = + swt_markers_position;
			_mark = swt_mark_to_change_pos;
			swt_markers_sys_change_mark = ["POS", player, _mark, _mark call swt_markers_getChannel, _coords];
			if (!isMultiplayer) then {swt_markers_sys_change_mark call swt_markers_logicServer_change_mark};
			publicVariableServer "swt_markers_sys_change_mark";
			swt_mark_to_change_pos = nil;
			swt_markers_position = nil;
		};
	};
};

swt_markers_MapMouseDown = {
	disableSerialization;
    _ctrl = _this select 0;
    _display = ctrlParent _ctrl;
    _dikCode = _this select 1;
    _pos_click1 = _this select 2;
    _pos_click2 = _this select 3;
    _pos_click = [_pos_click1,_pos_click2];
    _shift = _this select 4;
    _ctrlKey = _this select 5;
    _alt = _this select 6;
    if (!_shift and !_alt and _ctrlKey and ((_this select 1) == 0)) then {
    	["fast",[]] call swt_markers_sys_sendMark;
    } else {
		if (!_shift and !_ctrlKey and _alt and ((_this select 1) == 0)) then {
			{
				_pos = getMarkerPos _x;
				_pos = _ctrl ctrlMapWorldToScreen _pos;
				if (([_pos,_pos_click] call bis_fnc_distance2D) < 0.025) exitWith {
					if (name player == ((swt_markers_allMarkers_params select _forEachIndex) select 8)) then {
						swt_mark_to_change_dir = _x;
						swt_markers_direction = markerDir _x;
					} else {
						systemChat (localize "STR_SWT_M_MESS_CANTCHANGE");
					};
				};
			} forEach swt_markers_allMarkers;
		} else {
			if (!_shift and _ctrlKey and _alt and ((_this select 1) == 0)) then {
		    	swt_markers_line_params_world = [(_display displayCtrl 51) ctrlMapScreenToWorld _pos_click,(_display displayCtrl 51) ctrlMapScreenToWorld _pos_click,0,5,0];
		    	createMarkerLocal ["SWT_MARKERS LOCAL LINE", (_display displayCtrl 51) ctrlMapScreenToWorld _pos_click];
				createMarkerLocal ["SWT_MARKERS LOCAL INFO", (_display displayCtrl 51) ctrlMapScreenToWorld _pos_click];
				"SWT_MARKERS LOCAL INFO" setMarkerShapeLocal "ICON";
				"SWT_MARKERS LOCAL INFO" setMarkerTypeLocal "hd_dot";
				"SWT_MARKERS LOCAL INFO" setMarkerSizeLocal [0,0];
				"SWT_MARKERS LOCAL INFO" setMarkerColorLocal swt_markers_mark_color;

		    	"SWT_MARKERS LOCAL LINE" setMarkerShapeLocal "RECTANGLE";
		    	"SWT_MARKERS LOCAL LINE" setMarkerBrushLocal "Solid";
		    	"SWT_MARKERS LOCAL LINE" setMarkerColorLocal swt_markers_mark_color;
		    	"SWT_MARKERS LOCAL LINE" setMarkerSizeLocal [swt_markers_line_params_world select 3,0];
		    } else {
				if (_shift and !_ctrlKey and _alt and ((_this select 1) == 0)) then {
			    	swt_markers_ellipse = [(_display displayCtrl 51) ctrlMapScreenToWorld _pos_click,(_display displayCtrl 51) ctrlMapScreenToWorld _pos_click];
			    	createMarkerLocal ["SWT_MARKERS LOCAL ELLIPSE", (_display displayCtrl 51) ctrlMapScreenToWorld _pos_click];
					createMarkerLocal ["SWT_MARKERS LOCAL INFO", (_display displayCtrl 51) ctrlMapScreenToWorld _pos_click];
					"SWT_MARKERS LOCAL INFO" setMarkerShapeLocal "ICON";
					"SWT_MARKERS LOCAL INFO" setMarkerTypeLocal "hd_dot";
					"SWT_MARKERS LOCAL INFO" setMarkerSizeLocal [0,0];
					"SWT_MARKERS LOCAL INFO" setMarkerColorLocal swt_markers_mark_color;

			    	"SWT_MARKERS LOCAL ELLIPSE" setMarkerShapeLocal "ELLIPSE";
			    	"SWT_MARKERS LOCAL ELLIPSE" setMarkerBrushLocal "Solid";
			    	"SWT_MARKERS LOCAL ELLIPSE" setMarkerColorLocal swt_markers_mark_color;
			    	"SWT_MARKERS LOCAL ELLIPSE" setMarkerSizeLocal [0,0];
			    } else {
					if (_shift and _ctrlKey and !_alt and ((_this select 1) == 0)) then {
						_pos = (_display displayCtrl 51) ctrlMapScreenToWorld _pos_click;
						_roads = _pos nearRoads 50;
						_min = _roads select 0;
						if (isNil {_min}) exitWith {hint "SWT MARKERS: ROAD NOT FOUND"};
						{
							if (_x distance _pos < _min distance _pos) then {_min = _x};
						} forEach _roads;
						["road", getPosATL _min] call swt_markers_sys_sendMark;
					} else {
						if ((_this select 1) == 0) then {
							{
								_pos = getMarkerPos _x;
								_pos = _ctrl ctrlMapWorldToScreen _pos;
								if (([_pos,_pos_click] call bis_fnc_distance2D) < 0.025) exitWith {
									if (name player == ((swt_markers_allMarkers_params select _forEachIndex) select 8)) then {
										swt_mark_to_change_pos = _x;
										swt_markers_position = getMarkerPos _x;
									} else {
										systemChat (localize "STR_SWT_M_MESS_CANTCHANGE");
									};
								};
							} forEach swt_markers_allMarkers;
						};
					};
				};
			};
		};
	};
};

swt_markers_MapMouseMoving = {
	disableSerialization;
	_display = ctrlParent (_this select 0);
	swt_markers_display_coord = [_this select 1, _this select 2];
	swt_markers_pos_m = [_this select 1, _this select 2];
	if !(isNil "swt_mark_to_change_dir") then {
		disableSerialization;
		_ctrl = _this select 0;
		_pos_click = swt_markers_pos_m;
		_pos = getMarkerPos swt_mark_to_change_dir;
		_pos = (_ctrl) ctrlMapWorldToScreen _pos;
		swt_markers_direction =  [_pos,_pos_click] call BIS_fnc_dirTo;
		swt_markers_direction = - swt_markers_direction + 180;
		if ((markerShape swt_mark_to_change_dir == "ELLIPSE")and((markerSize swt_mark_to_change_dir) select 0 > (markerSize swt_mark_to_change_dir) select 1)) then {swt_markers_direction = swt_markers_direction + 90};
		swt_mark_to_change_dir setMarkerDirLocal swt_markers_direction;
	} else {
		if !(isNil "swt_markers_line_params_world") then {
			swt_markers_line_params_world set [1,(_this select 0) ctrlMapScreenToWorld swt_markers_pos_m];
			_direction = [swt_markers_line_params_world select 0,swt_markers_line_params_world select 1] call BIS_fnc_dirTo;
			"SWT_MARKERS LOCAL LINE" setMarkerPosLocal [(((swt_markers_line_params_world select 0) select 0) + ((swt_markers_line_params_world select 1) select 0))/2,(((swt_markers_line_params_world select 0) select 1) + ((swt_markers_line_params_world select 1) select 1))/2];
			"SWT_MARKERS LOCAL INFO" setMarkerPosLocal [(((swt_markers_line_params_world select 0) select 0) + ((swt_markers_line_params_world select 1) select 0))/2,(((swt_markers_line_params_world select 0) select 1) + ((swt_markers_line_params_world select 1) select 1))/2];
			swt_markers_line_params_world set [2,_direction];
			swt_markers_line_params_world set [4, ((swt_markers_line_params_world select 0) distance (swt_markers_line_params_world select 1))/2];
			"SWT_MARKERS LOCAL LINE" setMarkerSizeLocal [swt_markers_line_params_world select 3,(((swt_markers_line_params_world select 0) distance (swt_markers_line_params_world select 1)))/2];
			"SWT_MARKERS LOCAL LINE" setMarkerDirLocal (_direction);
		} else {
			if !(isNil "swt_markers_ellipse") then {
				_pos = (_this select 0) ctrlMapScreenToWorld swt_markers_pos_m;
				if (abs((_pos select 0) - ((swt_markers_ellipse select 0) select 0)) < 2000 and abs((_pos select 1) - ((swt_markers_ellipse select 0) select 1)) < 2000) then {
					swt_markers_ellipse set [1, _pos];
					_size = [abs(((swt_markers_ellipse select 1) select 0) - ((swt_markers_ellipse select 0) select 0)),abs(((swt_markers_ellipse select 1) select 1) - ((swt_markers_ellipse select 0) select 1))];
					"SWT_MARKERS LOCAL ELLIPSE" setMarkerSizeLocal _size;
					"SWT_MARKERS LOCAL INFO" setMarkerTextLocal (format ["w: %1, h: %2", _size select 0, _size select 1]);
				};

			} else {
				// if !(isNil "swt_markers_roadMode") then {
					// _pos = (_display displayCtrl 51) ctrlMapScreenToWorld swt_markers_pos_m;
					// _roads = _pos nearRoads 50;
					// if (isNil {_roads select 0}) exitWith {hintSilent "Err"};
					// hintSilent "";
					// _min = _roads select 0;
					// {
					// 	if (_x distance _pos < _min distance _pos) then {_min = _x}
					// } forEach (_roads);
					// if (!(_min in swt_markers_roadMode) and ({_min in (roadsConnectedTo _x)} count swt_markers_roadMode == 0)) then {
					// 	swt_markers_roadMode pushBack _min;
					// 	["road",getPosATL _min] call swt_markers_sys_sendMark;
					// };
				// } else {
				if !(isNil "swt_mark_to_change_pos") then {
					swt_markers_position = (_display displayCtrl 51) ctrlMapScreenToWorld swt_markers_pos_m;
					swt_mark_to_change_pos setMarkerPosLocal swt_markers_position;
				};
				if (swt_markers_mark_info) then {call swt_markers_showInfo};
			};
		};
	};
};

swt_markers_hold = false;

swt_markers_MapMouseHold = {
	disableSerialization;
	_display = ctrlParent (_this select 0);
	if (swt_markers_MapTime == swt_markers_delayCoeff) then {
		swt_markers_MapTime = 0;
		swt_markers_hold = true;
		if (swt_markers_mark_info) then {call swt_markers_showInfo};
	} else {
		swt_markers_MapTime = swt_markers_MapTime + 1;
	};
};


swt_markers_MapKeyDown = {
	disableSerialization;
  	_display = _this select 0;
    _dikCode = _this select 1;
    _shift = _this select 2;
    _ctrlKey = _this select 3;
    _alt = _this select 4;
	if !(isNil "swt_markers_line_params_world") then {
		if ((_alt || _ctrlKey) && !(_alt && _ctrlKey)) then { //xor
			_thickness = swt_markers_line_params_world select 3;
			if (_alt) then {
				_thickness = _thickness + 5;
				if (_thickness <= 100) then {
					swt_markers_line_params_world set [3, _thickness];
					"SWT_MARKERS LOCAL INFO" setMarkerTextLocal format [localize "STR_SWT_M_THICKNESS", _thickness];
				};
			} else {
				if (_ctrlKey) then {
					_thickness = _thickness - 5;
					if (_thickness >= 5) then {
						swt_markers_line_params_world set [3, _thickness];
						"SWT_MARKERS LOCAL INFO" setMarkerTextLocal format [localize "STR_SWT_M_THICKNESS", _thickness];
					};
				};
			};
			"SWT_MARKERS LOCAL LINE" setMarkerSizeLocal [swt_markers_line_params_world select 3,(((swt_markers_line_params_world select 0) distance (swt_markers_line_params_world select 1)))/2];
			true
		};
	} else {
	    if (_dikCode == 211) then { //DEL
	    	if (swt_markers_DisableLoc) exitWith {diag_log "SWT MARKERS: DEL DISABLED";};
			{
				_pos = getMarkerPos _x;
				_pos = (_display displayCtrl 51) ctrlMapWorldToScreen _pos;
				if (([_pos,swt_markers_pos_m] call bis_fnc_distance2D) < 0.025) exitWith {
					swt_markers_sys_change_mark = ["DEL", player, _x, _x call swt_markers_getChannel];
					if (!isMultiplayer) then {swt_markers_sys_change_mark call swt_markers_logicServer_change_mark};
					publicVariableServer "swt_markers_sys_change_mark";
				};
			} forEach swt_markers_allMarkers;
		};
		false
	};
};
