swt_markers_allMarkers = [];
swt_markers_allMarkers_params = [];
swt_markers_DisableLoc = false;

swt_markers_getChannel = {
	(swt_markers_allMarkers_params select (swt_markers_allMarkers find _this)) select 1;
};

swt_markers_createMarker = {
	private ["_mark","_params"];
	_params = _this;
	_mark = _params select 0;
	_Chan  = _params select 1;
	_Text  = _params select 2;
	_Pos   = _params select 3;
	_Type  = _params select 4;
	_Color = _params select 5;
	_Dir   = _params select 6;
	_Scale = _params select 7;
	_Name  = _params select 8;

	swt_markers_allMarkers pushBack _mark;
	swt_markers_allMarkers_params pushBack _params;

	_mark = createMarkerLocal [_mark,_Pos];

	_mark setMarkerColorLocal (swt_cfgMarkerColors_names select _Color);
	_mark setMarkerDirLocal _Dir;

	if (_Type == -2) then {
		_mark setMarkerSizeLocal [_Scale select 0,_Scale select 1];
		_mark setMarkerBrushLocal "Solid";
		_mark setMarkerShapeLocal "RECTANGLE";
	} else {
		if (_Type == -3) then {
		    _mark setMarkerSizeLocal [_Scale select 0,_Scale select 1];
			_mark setMarkerBrushLocal "Solid";
			_mark setMarkerShapeLocal "ELLIPSE";
		} else {
			_mark setMarkerTypeLocal (swt_cfgMarkers_names select _Type);
			_mark setMarkerTextLocal _Text;
			_mark setMarkerSizeLocal [_Scale,_Scale];
		};
	};
};

swt_markers_sys_sendMark = compile preprocessFileLineNumbers '\swt_markers_a3\Logic\sendMark.sqf';

swt_markers_logicClient_create = {
	if (swt_markers_DisableLoc) exitWith {diag_log "SWT MARKERS: MARKERS DISABLED"};
	_this call swt_markers_createMarker;
	["CREATE", _this] call swt_markers_log;
};

swt_markers_logicClient_del = {
	_mark = _this select 0;
	if (_mark in swt_markers_allMarkers) then {
		_player = _this select 1;
		deleteMarkerLocal _mark;
		_paramsOut = [];
		//Modifying local data
		{
			if (_x select 0 == _mark) exitWith {
				_paramsOut = swt_markers_allMarkers_params deleteAt _forEachIndex;
			};
		} forEach swt_markers_allMarkers_params;

		swt_markers_allMarkers deleteAt (swt_markers_allMarkers find _mark);
		["DEL", [name _player, _paramsOut]] call swt_markers_log;
	};
};

swt_markers_logicClient_dir = {
	if (swt_markers_DisableLoc) exitWith {diag_log "SWT MARKERS: MARKERS DISABLED"};
	_mark = _this select 0;
	if (_mark in swt_markers_allMarkers) then {
		_dir = _this select 1;
		_player = _this select 2;
		_mark setMarkerDirLocal _dir;
		_paramsOut = [];
		{
			if (_x select 0 == _mark) exitWith {
				_x set [6,_dir];
				_paramsOut = _x;
			};
		} forEach swt_markers_allMarkers_params;
		["DIR", [name _player, _paramsOut]] call swt_markers_log;
	};
};

swt_markers_logicClient_pos = {
	if (swt_markers_DisableLoc) exitWith {diag_log "SWT MARKERS: MARKERS DISABLED"};
	_mark = _this select 0;
	if (_mark in swt_markers_allMarkers) then {
		_pos = _this select 1;
		_player = _this select 2;
		_mark setMarkerPosLocal _pos;
		_paramsOut = [];
		{
			if (_x select 0 == _mark) exitWith {
				_x set [3,_pos];
				_paramsOut = _x;
			};
		} forEach swt_markers_allMarkers_params;
		["POS", [name _player, _paramsOut]] call swt_markers_log;
	};
};

swt_markers_logicClient_load = {
	_player = _this select 0;
	if (swt_markers_DisableLoc) exitWith {diag_log "SWT MARKERS: MARKERS DISABLED"};

	{
		_x call swt_markers_createMarker;
	} forEach (_this select 1);
	["LOAD", [name _player, count (_this select 1)]] call swt_markers_log;
};

swt_markers_clear_map = {
	{
		deleteMarkerLocal _x;
	} forEach swt_markers_allMarkers;
	swt_markers_allMarkers = [];
	swt_markers_allMarkers_params = [];
};

swt_markers_DisableLoc_fnc = {
	disableSerialization;
	_ctrl = _this;
	swt_markers_DisableLoc = !swt_markers_DisableLoc;
	if (swt_markers_DisableLoc) then {
		_ctrl ctrlSetText localize "STR_SWT_M_ENABLE";
	} else {
		_ctrl ctrlSetText localize "STR_SWT_M_DISABLE";
	};
};

0 spawn {
	"swt_markers_send_mark"  addPublicVariableEventHandler {
		(_this select 1) call swt_markers_logicClient_create;
	};
	"swt_markers_send_del" addPublicVariableEventHandler {
		(_this select 1) call swt_markers_logicClient_del;
	};
	"swt_markers_send_dir" addPublicVariableEventHandler {
		(_this select 1) call swt_markers_logicClient_dir;
	};
	"swt_markers_send_pos" addPublicVariableEventHandler {
		(_this select 1) call swt_markers_logicClient_pos;
	};
	"swt_markers_send_JIP" addPublicVariableEventHandler {
		_markers = _this select 1;
		{
			_x call swt_markers_createMarker;
		} forEach (_markers);
	};

	"swt_markers_send_load" addPublicVariableEventHandler {
		(_this select 1) call swt_markers_logicClient_load;
	};

	waitUntil {!isNull player};
	swt_markers_sys_req_markers = player;
	publicVariableServer "swt_markers_sys_req_markers";
	if (swt_markers_logging) then {
		player createDiarySubject ["SwtMarkersLog","SWT Markers"];
	};
};
