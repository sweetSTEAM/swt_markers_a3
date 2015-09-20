disableSerialization;
_ctrl = ((_this select 0) select 0);
_display = ctrlParent _ctrl;
//ctrlSetFocus (_display displayCtrl 203);
_action = (_this select 1);
_controls_color = [1200,1201,1202,1203,1204,1205];
_controls_icon = [1300,1301,1302,1303,1304,1305];
_combo_color = [2100,2101,2102,2103,2104,2105];
_combo_icon = [2106,2107,2108,2109,2110,2111];
_controls_icon_pic = [1400,1401,1402,1403,1404,1405];

switch (_this select 1) do {
	case 'SHOW OK': {
		_show_coef = 2;
		if (swt_markers_show_info) then {_show_coef = 2} else {_show_coef = 1};
		_text = _display displayCtrl 203;
		_buttonOK = _display displayctrl 1;
		_buttonCancel = _display displayctrl 2;
		_pos = ctrlposition _text;
		_posX = (_pos select 0);
		_posY = _pos select 1;
		_posW = _pos select 2;
		_posH = _pos select 3;
		_pos set [0,_posX];
		if (isnil "RscDisplayInsertMarker_info") then {_pos set [1,_posY + _show_coef * _posH + 2 * 0.005]} else {_pos set [1,_posY + 10 * _posH + 3 * 0.005]};
		_pos set [2,_posW / 2 - 0.005];
		_pos set [3,_posH];

		_combo_color = [2100,2101,2102,2103,2104,2105];
		_combo_icon = [2106,2107,2108,2109,2110,2111];

		swt_markers_show_butt = !(swt_markers_show_butt);
		swt_marker_settings_params set [0,swt_markers_show_butt];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];

		_control_button = (_display displayCtrl 2400);
		_pos_control_button = (ctrlPosition _control_button);
		_butt_cor_pos = -1.1*(1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25));

		if (swt_markers_show_butt) then {_butt_cor_pos = 1.1*(1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))};
		{
			_control = (_display displayCtrl _x);
			_pos_control = (ctrlPosition _control);
			_control ctrlSetPosition [_pos_control select 0, (_pos_control select 1)+_butt_cor_pos, _pos_control select 2, _pos_control select 3];
			_control ctrlCommit 0.2;
		} forEach (_combo_color+_combo_icon+[1104,228]);

		if !(swt_markers_show_butt) then {
			{
				(_display displayCtrl _x) ctrlSetPosition [(ctrlPosition (_display displayCtrl _x)) select 0,(ctrlPosition (_display displayCtrl _x)) select 1,(ctrlPosition (_display displayCtrl _x)) select 2,0];
				(_display displayCtrl _x) ctrlCommit 0.2;
			} forEach [1,2];
		} else {
			_buttonOk ctrlsetposition _pos;
			_buttonOk ctrlcommit 0.2;
			_pos set [0,_posX + _posW / 2];
			_pos set [2,_posW / 2];
			_pos set [3,_posH];
			_buttonCancel ctrlsetposition _pos;
			_buttonCancel ctrlcommit 0.2;
		};
    };

    case 'SHOW ICON': {
		swt_markers_show_icon = !(swt_markers_show_icon);
		swt_marker_settings_params set [1,swt_markers_show_icon];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
		if (swt_markers_show_icon) then {
			{
				_control = _display displayCtrl _x;
				_control ctrlSetFade 1;
				_control ctrlCommit 0;
				_control ctrlShow true;
				_control ctrlSetFade 0;
				_control ctrlCommit 0.2;
			} forEach (_controls_icon+_controls_icon_pic);
		} else {
			{
				_control = _display displayCtrl _x;
				_control ctrlSetFade 1;
				_control ctrlCommit 0.2;
			} forEach (_controls_icon+_controls_icon_pic);

			{
				_control = _display displayCtrl _x;
				waitUntil {ctrlCommitted _control};
				_control ctrlShow false;
			} forEach (_controls_icon+_controls_icon_pic);
		};
    };

     case 'SHOW COLOR': {
		swt_markers_show_color = !(swt_markers_show_color);
		swt_marker_settings_params set [2,swt_markers_show_color];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
			if (swt_markers_show_color) then {
			{
				_control = _display displayCtrl _x;
				_control ctrlSetFade 1;
				_control ctrlCommit 0;
				_control ctrlShow true;
				_control ctrlSetFade 0;
				_control ctrlCommit 0.2;
			} forEach (_controls_color);
		} else {
			{
				_control = _display displayCtrl _x;
				_control ctrlSetFade 1;
				_control ctrlCommit 0.2;
			} forEach (_controls_color);

			{
				_control = _display displayCtrl _x;
				waitUntil {ctrlCommitted _control};
				_control ctrlShow false;
			} forEach (_controls_color);
		};
    };

    case 'SHOW LB': {
    	swt_markers_show_lb = !(swt_markers_show_lb);
		swt_marker_settings_params set [3,swt_markers_show_lb];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
		if (swt_markers_show_lb) then {
			{
				_control = _display displayCtrl _x;
				if (ctrlShown _control) exitWith {};
				_control ctrlSetFade 1; _control ctrlCommit 0;
				_control ctrlShow true;
				_control ctrlSetFade 0;
				_control ctrlCommit 0.2;
			} forEach [15000,15001];
		} else {
			{
				_control = _display displayCtrl _x;
				if !(ctrlShown _control) exitWith {};
				_control ctrlSetFade 1;
				_control ctrlCommit 0.2;
			} forEach [15000,15001];

			{
				_control = _display displayCtrl _x;
				waitUntil {ctrlCommitted _control};
				_control ctrlShow false;
				_control ctrlSetFade 0;
				_control ctrlCommit 0;
			} forEach [15000,15001];
		};
    };

    case 'FAST LOAD': {
    	swt_markers_save_mode = !swt_markers_save_mode;
    	swt_marker_settings_params set [4,swt_markers_save_mode];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
	};

	case 'SAVE TEXT': {
		swt_markers_save_text = !(swt_markers_save_text);
    	swt_marker_settings_params set [5,swt_markers_save_text];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
	};

	case 'SHOW INFO': {
		swt_markers_show_info = !(swt_markers_show_info);
    	swt_marker_settings_params set [6,swt_markers_show_info];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
		if (!isnil "RscDisplayInsertMarker_info") then {
			((findDisplay 54) displayctrl 2400) call swt_markers_infoAnim;
			uiSleep 0.25;
		};

		waitUntil {ctrlCommitted (_display displayCtrl 1)};
		_butt_cor_pos = -1.1*(1 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25));


		if (swt_markers_show_info) then {_butt_cor_pos = 1.1*(1 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25))};
		{
			_control = (_display displayCtrl _x);
			_pos_control = (ctrlPosition _control);
			_control ctrlSetPosition [_pos_control select 0, (_pos_control select 1)+_butt_cor_pos, _pos_control select 2, _pos_control select 3];
			_control ctrlCommit 0.2;
		} forEach (_combo_color+_combo_icon+[1104,228,1,2]);

		_pos = ctrlPosition (_display displayCtrl 2400);
		(_display displayCtrl 2400) ctrlSetPosition [_pos select 0,_pos select 1,_pos select 2, if (swt_markers_show_info) then {1 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)} else {0}];
		(_display displayCtrl 2400) ctrlCommit 0.2;
	};

	case 'SHOW BACK': {
		swt_markers_show_back = !(swt_markers_show_back);
    	swt_marker_settings_params set [7,swt_markers_show_back];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
		if (swt_markers_show_back) then {
			for "_i" from 0 to 40 do {
				uiSleep (0.2/40);
				(_display displayCtrl 1100) ctrlSetBackgroundColor [0,0,0,(_i/57)];
			};
		} else {
			for "_i" from 40 to 0 step -1 do {
				uiSleep (0.2/40);
				(_display displayCtrl 1100) ctrlSetBackgroundColor [0,0,0,(_i/57)];
			};
		};
	};

	case 'SAVE MARK': {
		swt_markers_save_mark = !(swt_markers_save_mark);
    	swt_marker_settings_params set [8,swt_markers_save_mark];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
	};

	case 'LOG': {
		swt_markers_logging = !(swt_markers_logging);
    	swt_marker_settings_params set [10,swt_markers_logging];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
	};

	case 'MARK INFO': {
		swt_markers_mark_info = !(swt_markers_mark_info);
    	swt_marker_settings_params set [11,swt_markers_mark_info];
		profileNamespace setVariable ["swt_marker_settings_params", swt_marker_settings_params];
		saveProfileNamespace;
		_displayMap = ({if !(isNull(findDisplay _x)) exitWith {findDisplay _x}} forEach [37,52,53,12]);
		(_displayMap displayCtrl 228) ctrlShow false;
	};
};
