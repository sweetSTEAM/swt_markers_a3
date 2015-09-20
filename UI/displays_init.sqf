#define GR_W (((safezoneW/safezoneH) min 1.2)/40)
#define GR_H ((((safezoneW/safezoneH) min 1.2)/1.2)/25)

_addHandlers = {
	disableSerialization;
	_mapDisplay = _this;
	_control = _mapDisplay displayCtrl 51;
	_id0 = _control ctrlAddEventHandler ["MouseButtonDblClick", {
	_this spawn {
		if ((_this select 1) == 0) then {
			swt_markers_display_coord = [(_this select 2),(_this select 3)];
			(findDisplay 54) closeDisplay 2;
			(ctrlParent (_this select 0)) createDisplay "swt_RscDisplayInsertMarker";
		};
		true
	}
	}];
	_id1 = _control ctrlAddEventHandler ["MouseButtonDown", "_this call swt_markers_MapMouseDown"];
	_id2 = _control ctrlAddEventHandler ["MouseButtonUp", "_this call swt_markers_MapMouseUp"];
	_id3 = (_mapDisplay) displayAddEventHandler ["KeyDown", "_this call swt_markers_MapKeyDown"];
	_id4 = _control ctrlAddEventHandler ["MouseMoving", "_this call swt_markers_MapMouseMoving"];
	_id5 = _control ctrlAddEventHandler ["MouseHolding", "_this call swt_markers_MapMouseHold"];
	// _id6 = _control ctrlAddEventHandler ["MouseZChanged", "_this call swt_markers_MapMouseZ"];
	_ctrl = _mapDisplay ctrlCreate ["RscStructuredText", 228];
	_ctrl ctrlShow false;
	_ctrl ctrlSetBackgroundColor [0,0,0,0.7];
	_ctrl ctrlSetPosition [0, 0, 10.8*GR_W, 3.5*GR_H];
	_ctrl ctrlCommit 0;
};

disableSerialization;

waitUntil {(!isNull (findDisplay 12)) or (!isNull (findDisplay 37)) or (!isNull (findDisplay 52)) or (!isNull (findDisplay 53))};
_mapDisplay = ({if !(isNull (findDisplay _x)) exitWith {findDisplay _x}} forEach [37,52,53,12]);
if (_mapDisplay == (findDisplay 12)) then {
	_mapDisplay call _addHandlers;
} else {
	_mapDisplay call _addHandlers;
	sleep 1;
	waitUntil {(!isNull (findDisplay 12))};
	(findDisplay 12) call _addHandlers;
};
