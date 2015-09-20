private ['_display','_text','_picture','_buttonOK','_buttonCancel','_control','_pos'];

		disableSerialization;
		_display = ctrlparent _this;
		ctrlSetFocus (_display displayCtrl 203);
		_text = _display displayctrl 203;
		_picture = _display displayctrl 204;
		_buttonOK = _display displayctrl 1;
		_buttonCancel = _display displayctrl 2;
		_buttonInfo = _display displayctrl 2400;
		_description = _display displayctrl 1100;
		_title = _display displayctrl 1001;
		_info = _display displayctrl 1101;
		_combo_color = [2100,2101,2102,2103,2104,2105];
		_combo_icon = [2106,2107,2108,2109,2110,2111];
		_swt_info_group = _display displayctrl 1103;

		_posText = ctrlposition _text;
		_posTextY = _posText select 1;
		_posTextW = _posText select 2;
		_posTextH = _posText select 3;

		_animate = {
			disableSerialization;
			private ["_control","_dY","_dH","_borderCoef","_pos"];
			_control = _this select 0;
			_dY = _this select 1;
			_dH = _this select 2;
			_borderCoef = _this select 3;
			_pos = ctrlposition _control;
			_pos set [1,_posTextY + _dY * _posTextH + _borderCoef * 0.005];
			if (_this select 4) then {_pos set [3,_dH * _posTextH]};
			_control ctrlsetposition _pos;
			_control ctrlcommit _delay;
		};


		_delay = 0.2;

		if (isnil "RscDisplayInsertMarker_info") then {

			{
				_pos = ctrlPosition (_display displayCtrl _x);
				(_display displayCtrl _x) ctrlSetPosition [(_pos select 0)+1.1*((ctrlPosition (_display displayCtrl 203)) select 2),_pos select 1,_pos select 2,_pos select 3];
				(_display displayCtrl _x) ctrlCommit 0.2;
			} forEach (_combo_color+_combo_icon+[228,1104]);

			_buttonInfo ctrlsettext (localize 'STR_SWT_M_HIDEINFO');
			RscDisplayInsertMarker_info = true;

			//		Y H B
			_swt_info_group ctrlShow true;
			[_swt_info_group,		2,8,2,true] call _animate;
		//	[_info,		2,8,2] call _animate_info;
			//[_info,		2,7,2] call _animate;
			[_buttonOK,	10,1,3,false] call _animate;
			[_buttonCancel,	10,1,3,false] call _animate;
		} else {
			{
				_pos = ctrlPosition (_display displayCtrl _x);
				(_display displayCtrl _x) ctrlSetPosition [(_pos select 0)-1.1*((ctrlPosition (_display displayCtrl 203)) select 2),_pos select 1,_pos select 2,_pos select 3];
				(_display displayCtrl _x) ctrlCommit 0.2;
			} forEach (_combo_color+_combo_icon+[228,1104]);

			_buttonInfo ctrlsettext (localize 'STR_A3_RscDisplayInsertMarker_ButtonMenuInfo');
			RscDisplayInsertMarker_info = nil;

			[_swt_info_group,		2,0,2,true] call _animate;
			[_buttonOK,	2,1,2,false] call _animate;
			[_buttonCancel,	2,1,2,false] call _animate;
			//waitUntil {ctrlCommitted _swt_info_group};
			//_swt_info_group ctrlShow false;

		};