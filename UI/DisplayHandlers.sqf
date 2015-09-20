swt_markers_onLoad = compile preprocessFileLineNumbers '\swt_markers_a3\UI\onLoad.sqf';
swt_markers_infoAnim = compile preprocessfilelinenumbers '\swt_markers_a3\UI\RscDisplayInsertMarker.sqf';


swt_markers_unLoad = {
	disableSerialization;
	swt_markers_load_done = nil;
	swt_markers_d_cl_but = nil;
	swt_markers_adv_set = nil;
	RscDisplayInsertMarker_info = nil;
	RscDisplayInsertMarker_set_butt = nil;
	swt_markers_text = ctrlText ((_this select 0) displayCtrl 203);
	if !(swt_markers_save_mark) then {
		swt_markers_mark_type = swt_marker_icon_slot_params select 0;
		swt_markers_mark_color = swt_marker_color_slot_params select 0;
		swt_pic = getText (configFile >> "cfgMarkers" >> swt_markers_mark_type >> "icon");
		swt_marker_color_arr = getArray (configFile >> "CfgMarkerColors" >> swt_markers_mark_color >> "color");
		{
			if (typeName _x != "SCALAR") then {
				swt_marker_color_arr set [_forEachIndex, call compile _x];
			};
	    } forEach swt_marker_color_arr;
	    sweetk_s = 1;
	};
	if !(swt_markers_save_mode) then {
		swt_markers_fast_text_G = false;
		swt_markers_fast_text_N = false;
		swt_markers_fast_text_T = false;
	};
};


swt_markers_DOWN = {

	private ["_display","_dikCode","_shiftState","_ctrlState","_altState","_control","_pic","_swt_markers_mark_color"];
	disableSerialization;
	_display =                  _this select 0;
	_dikCode =                  _this select 1;
	swt_markers_shiftState =               _this select 2;
	swt_markers_ctrlState =                _this select 3;
	swt_markers_altState =                 _this select 4;
	_control = (_display displayCtrl 204);
	_handled = false;
	if ((_dikCode == 0xC8) or (_dikCode == 0xD0)) then {
		_handled = true;
		if !(swt_markers_shiftState) then {

			switch (_dikCode) do {
			    case 0xD0: {
			    	[_display, 'DOWN'] call swt_markers_changeIcon;
			    };

			    case 0xC8: {
			     	[_display, 'UP'] call swt_markers_changeIcon;
			    };
			};

		} else {
			if ((_dikCode == 0xD0) or (_dikCode == 0xC8)) then {
				switch (_dikCode) do {
				    case 0xD0: {
				    	[_display, 'DOWN'] call swt_markers_changeColor;
				    };

				    case 0xC8: {
				     	[_display, 'UP'] call swt_markers_changeColor;
				    };
				};
			};
		};
	} else {
		if (((_dikCode == 0xCB) or (_dikCode == 0xCD)) and swt_markers_shiftState) then {
			switch (_dikCode) do {
			    case 0xCB: {
			    	[_display, 'DOWN'] call swt_markers_changeChannel;
			    };

			    case 0xCD: {
			     	[_display, 'UP'] call swt_markers_changeChannel;
			    };
			};
		} else {
			if (swt_markers_ctrlState) then {
				switch (_dikCode) do {
				    case 0x14: {
				    	[_display displayCtrl 901,"T"] call swt_markers_fast_text;
				    };

				    case 0x22: {
				     	[_display displayCtrl 903,"G"] call swt_markers_fast_text;
				    };

				    case 0x31: {
				     	[_display displayCtrl 902,"N"] call swt_markers_fast_text;
				    };
				};
			};
		};
	};
	_handled;
};

swt_markers_UP = {
	_shiftState =               _this select 2;
	_ctrlState =                _this select 3;
	_altState =                 _this select 4;
	_dikCode = _this select 1;
	if (_dikCode in [42,54]) then { //?
		swt_markers_shiftState = false;
	};
	if (_dikCode in [29,157]) then {
		swt_markers_ctrlState = false;
	};
	if (_dikCode in [56,184]) then {
		swt_markers_altState = false;
	};
	false
};


swt_markers_d_cl_pic = {
	disableSerialization;
	private ['_display','_pos_click'];
	_display = _this select 0;
	//ctrlSetFocus (_display displayCtrl 203);
	if ((diag_tickTime-swt_markers_time) < 0.3) then {
		swt_markers_time = diag_tickTime;
		_display = _this select 0;
    	//_dikCode = _this select 1;
   		_pos_click = [_this select 2, _this select 3];
    	_pos_to_chek = ctrlPosition (_display displayCtrl 204);
    	_pos_to_chek = [(_pos_to_chek select 0) + (_pos_to_chek select 2)/2,(_pos_to_chek select 1) + (_pos_to_chek select 3)/2];
    	if (([_pos_to_chek,_pos_click] call bis_fnc_distance2D) < ((ctrlPosition (_display displayCtrl 204)) select 3)/2) then {
			if (isNil "swt_markers_d_cl_but") then {
				((_this select 0) displayCtrl 15000) ctrlShow true;
				((_this select 0) displayCtrl 15001) ctrlShow true;
				swt_markers_d_cl_but = true;
			} else {
				((_this select 0) displayCtrl 15000) ctrlShow false;
				((_this select 0) displayCtrl 15001) ctrlShow false;
				swt_markers_d_cl_but = nil;
			};
		};
	} else {swt_markers_time = diag_tickTime};
};

swt_markers_MouseZ = {
	disableSerialization;
	_display = _this select 0;
	_coef = _this select 1;
	if (swt_markers_shiftState) then {
	  	if (_coef > 0) then {
	        if (sweetk_s < 1.3) then { //увеличиваем
	            sweetk_s = sweetk_s + 0.3;
	        };
	    } else {
	        if (sweetk_s > 0.7) then { //убавлееееениееее!
	            sweetk_s = sweetk_s - 0.3;
	        };
	    };
	    call swt_markers_scale;
	} else {
		if (swt_markers_ctrlState) then {
			if (_coef > 0) then {
				[_display, 'UP'] call swt_markers_changeChannel;
		    } else {
		    	[_display, 'DOWN'] call swt_markers_changeChannel;
		    };
		};
	};
};

swt_markers_editDOWN =  {
	disableSerialization;
	_display = ctrlParent (_this select 0);
	_dikCode = _this select 1;
	if (((_dikCode == 51) or (_dikCode == 52)) and swt_markers_ctrlState) then {
		(_this select 0) ctrlSetText swt_markers_tempText;
		switch (_dikCode) do {
		    case 51: {
		    	[_display, 'DOWN'] call swt_markers_changeChannel;
		    };

		    case 52: {
		     	[_display, 'UP'] call swt_markers_changeChannel;
		    };
		};
	} else {
		swt_markers_tempText = ctrlText (_this select 0);
	};
};
