#define SWT_W 0.025
#define SWT_H 0.02
disableSerialization;
_display = (_this select 0);


_text = _display displayctrl 203;
_picture = _display displayctrl 204;
_buttonOK = _display displayctrl 1;
_buttonCancel = _display displayctrl 2;
_buttonInfo = _display displayctrl 2400;
_description = _display displayctrl 1100;
_channButt = _display displayctrl 205;
_info = _display displayctrl 1101;
_swt_info_group = _display displayctrl 1103;
_combo_color = [2100,2101,2102,2103,2104,2105];
_combo_icon = [2106,2107,2108,2109,2110,2111];
_controls_color = [1200,1201,1202,1203,1204,1205];
_controls_icon = [1300,1301,1302,1303,1304,1305];
_controls_icon_pic = [1400,1401,1402,1403,1404,1405];
_all = [2100,2101,2102,2103,2104,2105,2106,2107,2108,2109,2110,2111,1200,1201,1202,1203,1204,1205,1300,1301,1302,1303,1304,1305,1400,1401,1402,1403,1404,1405,15000,15001,900,1103,1104,2400,228,1100];
swt_markers_shiftState =               false;
swt_markers_ctrlState =                false;
swt_markers_altState =                 false;
ctrlSetFocus _text;
//Скрываем
{(_display displayCtrl _x) ctrlShow false} forEach [1104, 1103];
{
	(_display displayCtrl _x) ctrlShow false; (_display displayCtrl _x) ctrlSetFade 1;
	(_display displayCtrl _x) ctrlCommit 0;
} forEach (_combo_color+_combo_icon+[228]);

//Базовые контролы
_picture ctrlSetPosition [(swt_markers_display_coord select 0) - ((ctrlPosition _picture) select 2)/2,(swt_markers_display_coord select 1)-((ctrlPosition _picture) select 3)/2,(ctrlPosition _picture) select 2, (ctrlPosition _picture) select 3];
_picture ctrlCommit 0;
_text ctrlSetPosition [(swt_markers_display_coord select 0) - ((ctrlPosition _picture) select 2)/2 + 0.07, (swt_markers_display_coord select 1)-((ctrlPosition _text) select 3)/2, (ctrlPosition _text) select 2, (ctrlPosition _text) select 3];
(_text) ctrlCommit 0;

_pos = ctrlposition _text;
_posX = _pos select 0;
_posY = _pos select 1;
_posW = _pos select 2;
_posH = _pos select 3;
_pos set [1,_posY - 1*_posH];
_pos set [3,2*_posH];
_description ctrlsetposition _pos;
_description ctrlcommit 0;
_channButt ctrlsetposition [_pos select 0, _pos select 1, 0.7*_posW,_posH];
_channButt ctrlcommit 0;
[_info,'info'] call swt_markers_info_buttons;
_pos set [1,_posY + 2 * _posH + 0.01];
_pos set [3,0];
_swt_info_group ctrlsetposition [_pos select 0, _pos select 1, ((ctrlPosition _swt_info_group) select 2)+0.69 * 			(			((safezoneW / safezoneH) min 1.2) / 40), 0];
_swt_info_group ctrlcommit 0;
_swt_info_group ctrlShow true;
_pos set [1,_posY + 1 * _posH + 0.005];
_pos set [3,0];
_show_coef = 2;
if (swt_markers_show_info) then {_pos set [3,_posH];_show_coef = 2} else {_show_coef = 1};
_buttonInfo ctrlsetposition _pos;
_buttonInfo ctrlcommit 0;
_buttonInfo ctrlShow true;
_pos set [1,_posY + _show_coef * _posH + 2 * 0.005];
_pos set [2,_posW / 2 - 0.005];
//_pos set [3,0];
//if (swt_markers_show_butt) then {_pos set [3,_posH]};
_buttonOk ctrlsetposition _pos;
_buttonOk ctrlcommit 0;
_pos set [0,_posX + _posW / 2];
//_pos set [1,_posY + _show_coef * _posH + 2 * 0.005];
_pos set [2,_posW / 2];
_buttonCancel ctrlsetposition _pos;
_buttonCancel ctrlcommit 0;

call swt_markers_scale;

if (swt_markers_save_text) then {_text ctrlSetText swt_markers_text};
if !(swt_markers_show_butt) then {
	{
		(_display displayCtrl _x) ctrlSetPosition [(ctrlPosition (_display displayCtrl _x)) select 0,(ctrlPosition (_display displayCtrl _x)) select 1,(ctrlPosition (_display displayCtrl _x)) select 2,0];
		(_display displayCtrl _x) ctrlCommit 0;
	} forEach [1,2];
};
if !(swt_markers_show_back) then {
	_description ctrlSetBackgroundColor [0,0,0,0];
};



[_display,swt_markers_channel] call swt_markers_setChannel;

_picture ctrlSetText swt_pic;
_picture ctrlSetTextColor swt_marker_color_arr;

_pos_control_base = ctrlposition (_description);
//КРИВО, ПЕРЕДЕЛАТЬ В ГРУППЫ И СЕЙВЗОНЫ!

_w_color = (ctrlPosition (_display displayCtrl 1200)) select 2;
_h_color = (ctrlPosition (_display displayCtrl 1200)) select 3;

_w_icon = (ctrlPosition (_display displayCtrl 1300)) select 2;
_h_icon = (ctrlPosition (_display displayCtrl 1300)) select 3;
//if ((_w_color) == 0) exitWith {};
_coef_h_color = (_h_color/_w_color);
_coef_h_icon = (_h_icon/_w_icon);

{
	_control = _display displayCtrl _x;
	_pos = ctrlPosition _control;
	_control ctrlSetPosition [((_pos_control_base select 0) + (((_pos_control_base select 2)/6) * _forEachIndex)), (_pos_control_base select 1) - (_pos select 3), _pos select 2, _pos select 3];
	_control ctrlCommit 0;
	_swt_markers_mark_color = getArray (configFile >> "CfgMarkerColors" >> (swt_marker_color_slot_params select _forEachIndex) >> "color");

	{
		if (typeName _x != "SCALAR") then {
        	_swt_markers_mark_color set [_forEachIndex, call compile _x];
    	};
    } forEach _swt_markers_mark_color;
	_control ctrlSetTextColor [_swt_markers_mark_color select 0, _swt_markers_mark_color select 1, _swt_markers_mark_color select 2, 0.6];
	_control ctrlSetActiveColor _swt_markers_mark_color;
	if !(swt_markers_show_color) then {_control ctrlShow false};
} forEach _controls_color;

{
	_control = _display displayCtrl _x;
	_control ctrlSetPosition [((_pos_control_base select 0) + (((_pos_control_base select 2)/6) * _forEachIndex)), (_pos_control_base select 1) - (_pos select 3) - 0.2*(_pos_control_base select 3) - (_coef_h_icon * ((_pos_control_base select 2)/6)), ((_pos_control_base select 2)/6), (_coef_h_icon * ((_pos_control_base select 2)/6))];
	if (!isNil "swt_marker_color_arr") then {_control ctrlSetTextColor swt_marker_color_arr};
	_control ctrlCommit 0;
	_pic = getText (configFile >> "cfgMarkers" >> (swt_marker_icon_slot_params select _forEachIndex) >> "icon");
	_control ctrlSetText _pic;
	if !(swt_markers_show_icon) then {_control ctrlShow false};
} forEach _controls_icon_pic;

{
	_control = _display displayCtrl _x;
	_control ctrlSetPosition [((_pos_control_base select 0) + (((_pos_control_base select 2)/6) * _forEachIndex)), (_pos_control_base select 1) - (_pos select 3) - 0.2*(_pos_control_base select 3) - (_coef_h_icon * ((_pos_control_base select 2)/6)), ((_pos_control_base select 2)/6), (_coef_h_icon * ((_pos_control_base select 2)/6))];
	_control ctrlCommit 0;
	_pic = getText (configFile >> "cfgMarkers" >> (swt_marker_icon_slot_params select _forEachIndex) >> "icon");
	_control ctrlSetText _pic;
	if !(swt_markers_show_icon) then {_control ctrlShow false};
} forEach _controls_icon;

{
	_control = _display displayCtrl _x;
	_control_pos = ctrlPosition _control;
	_control ctrlSetPosition [(_pos_control_base select 0) + (_pos_control_base select 2) - (_control_pos select 2)*(_forEachIndex+1),(_pos_control_base select 1),_control_pos select 2,_control_pos select 3];
	_control ctrlCommit 0;
} forEach [901,902,903];

if (swt_markers_save_mode) then {
	[_display displayCtrl 901,"T",true] call swt_markers_fast_text;
	[_display displayCtrl 903,"G",true] call swt_markers_fast_text;
	[_display displayCtrl 902,"N",true] call swt_markers_fast_text;
};
_control_pic_pos = ctrlPosition _picture;
{
	_control = (_display displayCtrl _x);
	_control_pos = ctrlPosition _control;
	_control ctrlSetPosition [(_control_pic_pos select 0) - ((3*(((safezoneW / safezoneH) min 1.2) / 40))*(_forEachIndex+1)), (_control_pic_pos select 1) + (_control_pic_pos select 3)/2 - (_control_pos select 3)/2,(_control_pos select 2),(_control_pos select 3)];
	_control ctrlCommit 0;
	if !(swt_markers_show_lb) then {_control ctrlShow false};
} forEach [15001,15000];





//Перемещаем контролы настроек
_pos_control_button = (ctrlPosition _buttonInfo);
_butt_cor_pos = 0;
if (swt_markers_show_butt) then {_butt_cor_pos = 1.1*(1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))};
{
	_control = (_display displayCtrl _x);
	_pos_control = (ctrlPosition _control);
	_control ctrlSetPosition [(_pos_control_button select 0) + (_pos_control_button select 2)/2 + (_pos_control_button select 2)*0.02, (_pos_control_button select 1) + (_pos_control_button select 3)*1 + (0.3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)) + (_pos_control select 3)*_forEachIndex + _butt_cor_pos,_pos_control select 2, _pos_control select 3];
	_control ctrlCommit 0;
} forEach _combo_icon;

{
	_control = (_display displayCtrl _x);
	_pos_control = (ctrlPosition _control);
	_control ctrlSetPosition [(_pos_control_button select 0) + (_pos_control_button select 2)/2 - (_pos_control_button select 2)*0.02 - (_pos_control select 2), (_pos_control_button select 1) + (_pos_control_button select 3)*1+(0.3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)) + (_pos_control select 3)*_forEachIndex + _butt_cor_pos,_pos_control select 2, _pos_control select 3];
	_control ctrlCommit 0;
} forEach _combo_color;

_control = _display displayCtrl 228;
_pos = ctrlPosition _control;
_control ctrlSetPosition [(_pos_control_button select 0), (_pos_control_button select 1) + (_pos_control_button select 3)*1 + (0.6 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)) + ((ctrlPosition (_display displayCtrl 2111)) select 3)*6 + _butt_cor_pos,_pos select 2,_pos select 3];
_control ctrlCommit 0;

_control = _display displayCtrl 1104;
_pos = ctrlPosition (_display displayCtrl 228);
_control ctrlSetPosition [_pos select 0, (_pos select 1) + (_pos select 3)*1.3, (ctrlPosition _control) select 2,(ctrlPosition _control) select 3];
_control ctrlCommit 0;

_control = _display displayCtrl 900;
_pos = ctrlPosition _control;
_control ctrlSetPosition [(ctrlPosition (_text) select 0) + (ctrlPosition (_text) select 2),(ctrlPosition (_text) select 1),_pos select 2,_pos select 3];
_control ctrlCommit 0;





{
	_color_type	= (configfile >> "CfgMarkerColors" >> _x);
	_swt_markers_mark_color = getArray (_color_type >> "color");

  	{
  		if (typeName _x != "SCALAR") then {
			_swt_markers_mark_color set [_forEachIndex, call compile _x];
		};
	} forEach _swt_markers_mark_color;
	_index = (_display displayCtrl 15000) lbAdd "";
	(_display displayCtrl 15000) lbSetValue [_index, _forEachIndex];
	(_display displayCtrl 15000) lbSetPicture [_index, format["#(argb,8,8,3)color(%1,%2,%3,%4)", _swt_markers_mark_color select 0, _swt_markers_mark_color select 1, _swt_markers_mark_color select 2, _swt_markers_mark_color select 3]];
	(_display displayCtrl 15000) lbSetData [_index, configName _color_type];
} forEach swt_marker_color_slot_params;

{
	_color_type	= _x;
	if !((configName _x) in swt_marker_color_slot_params) then {
		_swt_markers_mark_color = getArray (_color_type >> "color");

	  	{
	  		if (typeName _x != "SCALAR") then {
				_swt_markers_mark_color set [_forEachIndex, call compile _x];
			};
		} forEach _swt_markers_mark_color;
		_index = (_display displayCtrl 15000) lbAdd "";
		(_display displayCtrl 15000) lbSetValue [_index, _forEachIndex];
		(_display displayCtrl 15000) lbSetPicture [_index, format["#(argb,8,8,3)color(%1,%2,%3,%4)", _swt_markers_mark_color select 0, _swt_markers_mark_color select 1, _swt_markers_mark_color select 2, _swt_markers_mark_color select 3]];
		(_display displayCtrl 15000) lbSetData [_index, configName _color_type];
	};
} forEach swt_cfgMarkerColors;

{
	_marker	= (configfile >> "CfgMarkers" >> _x);
	_pic = getText (_marker >> "icon");
	_index = (_display displayCtrl 15001) lbAdd "";
	(_display displayCtrl 15001) lbSetValue [_index, _forEachIndex];
	(_display displayCtrl 15001) lbSetPicture [_index, _pic];
	(_display displayCtrl 15001) lbSetData [_index, configName _marker];
} forEach swt_marker_icon_slot_params;

{
	_marker	= _x;
	if !((configName _marker) in swt_marker_icon_slot_params) then {
		_pic = getText (_marker >> "icon");
		_index = (_display displayCtrl 15001) lbAdd "";
		(_display displayCtrl 15001) lbSetValue [_index, _forEachIndex];
		(_display displayCtrl 15001) lbSetPicture [_index, _pic];
		(_display displayCtrl 15001) lbSetData [_index, configName _marker];
	};
} forEach swt_cfgMarkers;


swt_markers_tempText = ctrlText (_text);
