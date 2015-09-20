diag_log "SWT MARKERS SERVER VERSION 2 ARMA 3";
swt_markers_count = 0;
swt_markers_isPlayer_bug = [];
{
	missionNamespace setVariable ['swt_markers_logicServer_'+_x,[]];
} forEach ["S","S2","C","GL","V","GR","D"];

// callbacks: swt_markers_send_JIP  swt_markers_send_mark swt_markers_send_dir swt_markers_send_del swt_marker_send_load


swt_markers_logicServer_regMark = {
	private ["_mark"];

	_fnc_areFriendly = {
		private ["_sideA","_sideB"];

		_sideA = _this select 0;
		_sideB = _this select 1;
		if (_sideA in [civilian,sidelogic] || _sideB in [civilian,sidelogic]) then {
			true
		} else {
			private ["_conflictLimit"];
			_conflictLimit = 0.6;
			if	(_sideA getfriend _sideB >= _conflictLimit && _sideB getfriend _sideA >= _conflictLimit) then {true} else {false};
		};
	};

	_addToChannel = {
		private ["_mark"];
		_channelData = _this select 0;
		_channelData = missionNamespace getVariable ("swt_markers_logicServer_" + _channelData);
		_channelUnit = _this select 1;
		_mark = _this select 2;
		if (_channelData find _channelUnit == -1) then {
			_channelData pushBack _channelUnit;
			_channelData pushBack [_mark];
    	} else {
    		(_channelData select ((_channelData find _channelUnit) + 1)) pushBack _mark;
    	};
	};

	_player = _this select 0;
	_mark = _this select 1;
	_channel = _mark select 1;
	_mark pushBack time;
	swt_markers_count = swt_markers_count + 1;
	_mark set [0, "SWT_M#"+ str swt_markers_count]; // BAD
	swt_markers_send_mark = _mark;
	_cond = "";
	_units = [];

	switch (_channel) do {
	    case "S": {
	    	_cond = "(side _x == side _player)";
	    	[_channel, side _player, _mark] call _addToChannel;
	    	_units = (playableUnits+switchableUnits);
	    };
	    case "C": {
	    	_cond = "((((leader _x == _x) or (((effectiveCommander (vehicle _x)) == _x) and (vehicle _x != _x))) and (side _x == side _player)) or (_player == _x))";
	    	[_channel, side _player, _mark] call _addToChannel;
	    	_units = (playableUnits+switchableUnits);
	    };
	    case "GL": {
	    	_cond = "true";
	    	swt_markers_logicServer_GL pushBack _mark;
	    	_units = (playableUnits+switchableUnits);
	    };
	    case "V": {
	    	_cond = "(_x in vehicle _player)";
	    	[_channel, vehicle _player, _mark] call _addToChannel;
	    	_units = (playableUnits+switchableUnits);
	    };
	    case "GR": {
	    	_cond = "(group _x == group _player)";
	    	[_channel, group _player, _mark] call _addToChannel;
	    	_units = units group _player;
	    };
	    case "D": {
	    	_cond = "(_x distance _player < 15)";
	    	_units = (playableUnits+switchableUnits);
	    };
	};

	{
		if (isPlayer _x or {time==0 and {_player in swt_markers_isPlayer_bug}}) then {
			_cond_x = call compile _cond;
			if _cond_x then {
				(owner _x) publicVariableClient "swt_markers_send_mark";
				if (!isMultiplayer and {_x == player}) then {swt_markers_send_mark call swt_markers_logicClient_create};
			};
		};
	} forEach _units;
};

swt_markers_logicServer_req_markers = {
	_player = _this;
	if (!isPlayer _player) then {
		if (swt_markers_isPlayer_bug find _player == -1) then {
			swt_markers_isPlayer_bug pushBack _player;
		};
	};

	_addMarkers = {
		_channelUnit = _this;
		_num = _channelData find _channelUnit;
    	if (_num != -1) then {
    		swt_markers_send_JIP append (_channelData select (_num + 1));
    	};
	};

	swt_markers_send_JIP = [];
	{
		_channelData = missionNamespace getVariable ("swt_markers_logicServer_" + _x);
		if (!(_channelData isEqualTo [])) then {
			switch _x do {
			    case "S": {
			    	(side _player) call _addMarkers;
			    };
			    case "C": {
			    	if ((leader _player == _player) or (((effectiveCommander (vehicle _player)) == _player) and (vehicle _player != _player))) then {
			    		(side _player) call _addMarkers;
			    	};
			    };
			    case "GL": {
			    	swt_markers_send_JIP append _channelData;
			    };
			    case "V": {
				    if (vehicle _player != _player) then {
				    	(vehicle _player) call _addMarkers;
				    };
			    };
			    case "GR": {
			    	(group _player) call _addMarkers;

			    };
			    /*case "DIRECT": {

			    };*/
			};
		};
	} forEach ["S","S2","C","GL","V","GR"];
	(owner _player) publicVariableClient "swt_markers_send_JIP";
};

swt_markers_logicServer_change_mark = {
	//Only creator can change marker
	private ["_pos","_dir"];
	_processMarker = {
		_action = _this select 0;
		_markParams = _this select 1;
		_arr = _this select 2;
		_index = _this select 3;
		switch (toUpper _action) do {
		    case "DIR": {
		    	_markParams set [6,_dir];
		    };

		    case "DEL": {
		    	_arr deleteAt _index;
		    };

			case "POS": {
			    _markParams set [3,_pos];
			};
		};
	};

	_find_changeMarkers = {
		private ['_find'];
		_channelUnit = _this;
		_find = false;
		_num = _channelData find _channelUnit;
    	if (_num != -1) then {
    		{
    			if (_x select 0 == _mark_id) exitWith {
					[_action, _x, _channelData select (_num + 1), _forEachIndex] call _processMarker;
					_find = true;
				};
    		} forEach (_channelData select (_num + 1));
    	};

    	if (!_find) then {
    		for [{_i=1}, {_i<(count _channelData)&&!_find},{_i=_i+2}] do {
    			{
    				if (_x select 0 == _mark_id) exitWith {
						[_action, _x, (_channelData select _i), _forEachIndex] call _processMarker;
						_find = true;
					};
    			} forEach (_channelData select _i);
    		};
    	};
    	if (!_find) then {diag_log "CHANGE MARKER FAIL: CAN'T FIND DATA";};
	};

	_action = _this select 0;
	_player = _this select 1;
	_mark_id = _this select 2;
	_channel = _this select 3;
	_dir = 0;
	_pos = [];

	switch (_action) do {
	    case "DIR": {
	    	_dir = _this select 4;
	    	swt_markers_send_dir = [_mark_id,_dir,_player];
			publicVariable "swt_markers_send_dir";
			if (hasInterface) then {swt_markers_send_dir call swt_markers_logicClient_dir};
	    };

	     case "DEL": {
	    	swt_markers_send_del = [_mark_id,_player];
			publicVariable "swt_markers_send_del";
			if (hasInterface) then {swt_markers_send_del call swt_markers_logicClient_del};
	    };

		case "POS": {
			_pos = _this select 4;
		   swt_markers_send_pos = [_mark_id,_pos,_player];
		   publicVariable "swt_markers_send_pos";
		   if (hasInterface) then {swt_markers_send_pos call swt_markers_logicClient_pos};
	   };
	};


	_channelData = missionNamespace getVariable ("swt_markers_logicServer_" + _channel);

	if (!(_channelData isEqualTo [])) then {
		switch _channel do {
		    case "S": {
		    	(side _player) call _find_changeMarkers;
		    };
		    case "C": {
		    	(side _player) call _find_changeMarkers;
		    };
		    case "V": {
		    	(vehicle _player) call _find_changeMarkers;
		    };
		    case "GR": {
		    	(group _player) call _find_changeMarkers;
		    };
		    case "D": {
		    	//
		    };
		    case "GL": {
		    	{
					if (_x select 0 == _mark_id) exitWith {
						[_action, _x, _channelData, _forEachIndex] call _processMarker;
					};
				} forEach _channelData;
		    };
		};
	};
};

swt_markers_logicServer_load = {
	_player = _this select 0;
	_data = _this select 1;
	{
		swt_markers_count = swt_markers_count + 1;
		_x set [0, "SWT_M#"+ str swt_markers_count];
		_x set [1, "S"];
		_x pushBack (name _player);
		_x pushBack time;
		_x pushBack true; //means loaded
	} forEach _data;

	if (swt_markers_logicServer_S find (side _player) == -1) then {
		swt_markers_logicServer_S pushBack (side _player);
		swt_markers_logicServer_S pushBack _data;
	} else {
		(swt_markers_logicServer_S select ((swt_markers_logicServer_S find (side _player)) + 1)) append _data;
    };

    swt_markers_send_load = [_player, _data];
    {
    	if (isPlayer _x or {time==0 and {_player in swt_markers_isPlayer_bug}}) then {
	    	if (side _player == side _x) then {
	    		(owner _x) publicVariableClient "swt_markers_send_load";
	    		if (!isMultiplayer and {_x == player}) then {swt_markers_send_load call swt_markers_logicClient_load};
	     	};
     	};
	} forEach (playableUnits+switchableUnits);
};

0 spawn {
	swt_markers_daytime = daytime;
	publicVariable "swt_markers_daytime";

	 swt_cfgMarkerColors = "true" configClasses (configfile >> "CfgMarkerColors");
	 swt_cfgMarkerColors_names = [];
	 {swt_cfgMarkerColors_names pushBack (configName _x)} forEach swt_cfgMarkerColors;
	 if (count swt_cfgMarkerColors_names != 0) then {publicVariable "swt_cfgMarkerColors_names"};

	swt_cfgMarkers = "getNumber (_x >> 'scope') > 0 && !(getText (_x >> 'markerClass') in ['NATO_Sizes','Locations','Flags'])" configClasses (configfile >> "CfgMarkers");
	swt_cfgMarkers_names = [];
	{swt_cfgMarkers_names pushBack (configName _x)} forEach swt_cfgMarkers;
	if (count swt_cfgMarkers_names != 0) then {publicVariable "swt_cfgMarkers_names"};

	"swt_markers_sys_client_send" addPublicVariableEventHandler {
		(_this select 1) call swt_markers_logicServer_regMark;
	};

	"swt_markers_sys_req_markers" addPublicVariableEventHandler {
		(_this select 1) call swt_markers_logicServer_req_markers;
	};

	"swt_markers_sys_change_mark" addPublicVariableEventHandler {
		(_this select 1) call swt_markers_logicServer_change_mark;
	};

	"swt_markers_sys_load" addPublicVariableEventHandler {
		(_this select 1) call swt_markers_logicServer_load;
	};
};
