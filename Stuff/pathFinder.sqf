

swt_markers_sys_create1 = {
    private ["_mark","_params"];
    _mark = (_this select 0) + str (random 1000);
    _params = _this select 1;

    _Text  = _params select 0;
    _Pos   = _params select 1;
    _Type  = _params select 2;
    _Color = _params select 3;

    _mark = createMarkerLocal [_mark,_Pos];
    _mark setMarkerTextLocal _Text;
    _mark setMarkerTypeLocal (swt_cfgMarkers_names select _Type);
    _mark setMarkerColorLocal (swt_cfgMarkerColors_names select _Color);
};

get_params = {
    private ["_data","_obj"];
    _obj = nearestObject [_this,"Logic"];
    _data = (_obj) getVariable "p_d";
    [_data,_obj];
};

findMin = {
    _arr = _this select 0;
    _min = 0;
    _min_f = 100000000;
    for "_i" from 0 to (count _arr)-1 do {
        _curr_d = ((_arr select _i) call get_params) select 0;
        if (_curr_d select 0 < _min_f) then {
                _min = _i;
                _min_f = _curr_d select 0;
        };
    };
    _min_cell = _arr select _min;
    _arr deleteAt _min;
    _min_cell;
};

path_to = {
    _curr_road = _this;
    _parent = (_curr_road call get_params) select 0 select 3;
    _path = [];
    diag_log ((_curr_road call get_params) select 0 select 1);
    while {!isNull _parent} do {
        _path pushBack _curr_road;
        _curr_road = (_curr_road call get_params) select 0 select 3;
        _parent = (_curr_road call get_params) select 0 select 3;
    };
    reverse _path;
    {
        [str _forEachIndex,["", (getPosATL _x),15,3]] call swt_markers_sys_create1;
    } forEach _path;
};

delete_objects = {
    {
        deleteVehicle _x;
    } forEach _this;
};

swt_markers_legendagy = {

    _this spawn {
        diag_log "SEARCH START -------------------------------------";
        tik = diag_tickTime;
        _rdischeck = 35;
        _first_pos = _this select 0;
        _second_pos = _this select 1;
        _start_road = (_first_pos nearRoads 20) select 0;
        _end_road = (_second_pos nearRoads 20) select 0;
        _done = false;
        _objs = [];
        _obj = "Logic" createVehicleLocal (getPosATL _start_road);
        _obj setVariable ["p_d", [0,0,0,objNull]];

        _black_roads = [];
        _open_roads = [_start_road];
        _count = 0;
        while {count _open_roads > 0} do {

            _curr_road = [_open_roads] call findMin;
            _count = _count + 1;
            [str _count,["", (getPosATL _curr_road),15,10]] call swt_markers_sys_create1;
            _black_roads pushBack _curr_road;
            if (_curr_road isEqualTo _end_road) exitWith {
                _done = true;
                _curr_road call path_to;
            };


            _roads = (roadsConnectedTo _curr_road) - _black_roads;

            _curr_params = (_curr_road call get_params) select 0;

	        {
	            _params = _x call get_params;
	            _g = (_x distance _curr_road) + (_curr_params select 1);
	            if (!(_x in _open_roads)) then {
                    _h = _x distance _end_road;
                    _obj = "Logic" createVehicleLocal (getPosATL _x);
                            _obj setVariable ["p_d", [_g + _h, _g, _h, _curr_road]];
                            _objs pushBack _obj;
                    _open_roads pushBack _x;
	            } else {
                    _obj = _params select 1;
                    _params = _params select 0;

                    if (_params select 1 > _g) then {
                            _h = _params select 2;
                            _params = [_g + _h, _g, _h, _curr_road];
                            _obj setVariable ["p_d", _params];
                    };
	            };
	        } forEach _roads;
        };
        hint str ("LENGTH: " + str ((_end_road call get_params) select 0 select 1));
        _objs call delete_objects;
        if (!_done) then {hint "ERROR"} else {};
    };
};


