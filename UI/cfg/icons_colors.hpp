#define GR_W (((safezoneW/safezoneH) min 1.2)/40)
#define GR_H ((((safezoneW/safezoneH) min 1.2)/1.2)/25)

class swt_color_1200: swt_RscActivePicture
{
	idc = 1200;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	w = (10/6) * GR_W;
	h = 0.7 * GR_H;
	OnButtonClick = "[_this select 0,0] call swt_markers_setColor";
};

class swt_color_1201: swt_RscActivePicture
{
	idc = 1201;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	w = (10/6) * GR_W;
	h = 0.7 * GR_H;
	OnButtonClick = "[_this select 0,1] call swt_markers_setColor";
};

class swt_color_1202: swt_RscActivePicture
{
	idc = 1202;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	w = (10/6) * GR_W;
	h = 0.7 * GR_H;
	OnButtonClick = "[_this select 0,2] call swt_markers_setColor";
};

class swt_color_1203: swt_RscActivePicture
{
	idc = 1203;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	w = (10/6) * GR_W;
	h = 0.7 * GR_H;
	OnButtonClick = "[_this select 0,3] call swt_markers_setColor";
};

class swt_color_1204: swt_RscActivePicture
{
	idc = 1204;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	w = (10/6) * GR_W;
	h = 0.7 * GR_H;
	OnButtonClick = "[_this select 0,4] call swt_markers_setColor";
};

class swt_color_1205: swt_RscActivePicture
{
	idc = 1205;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	w = (10/6) *  GR_W;
	h = 0.7 *  GR_H;
	OnButtonClick = "[_this select 0,5] call swt_markers_setColor";
};








//-------------------------------------------------------------------------------------------------






class swt_icon_1300: swt_RscButton
{
	idc = 1300;
	text = "";
	w = 0.05;
	h = 0.0666667;
	OnButtonClick = "[_this select 0,0] call swt_markers_setIcon";
};

class swt_icon_1301: swt_RscButton
{
	idc = 1301;
	text = "";
	w = 0.05;
	h = 0.0666667;
	OnButtonClick = "[_this select 0,1] call swt_markers_setIcon";
};

class swt_icon_1302: swt_RscButton
{
	idc = 1302;
	text = "";
	w = 0.05;
	h = 0.0666667;
	OnButtonClick = "[_this select 0,2] call swt_markers_setIcon";
};
class swt_icon_1303: swt_RscButton
{
	idc = 1303;
	text = "";
	w = 0.05;
	h = 0.0666667;
	OnButtonClick = "[_this select 0,3] call swt_markers_setIcon";
};
class swt_icon_1304: swt_RscButton
{
	idc = 1304;
	text = "";
	w = 0.05;
	h = 0.0666667;
	OnButtonClick = "[_this select 0,4] call swt_markers_setIcon";
};
class swt_icon_1305: swt_RscButton
{
	idc = 1305;
	text = "";
	w = 0.05;
	h = 0.0666667;
	OnButtonClick = "[_this select 0,5] call swt_markers_setIcon";
};










//-------------------------------------------------------------------------------------------------













class swt_icon_1400: RscPicture
{
	idc = 1400;
	text = "\A3\ui_f\data\map\markers\military\dot_CA.paa";
	w = 0.05;
	h = 0.0666667;
};
class swt_icon_1401: RscPicture
{
	idc = 1401;
	text = "\A3\ui_f\data\map\markers\nato\o_inf.paa";
	w = 0.05;
	h = 0.0666667;
};
class swt_icon_1402: RscPicture
{
	idc = 1402;
	text = "\A3\ui_f\data\map\markers\nato\o_armor.paa";
	w = 0.05;
	h = 0.0666667;
};
class swt_icon_1403: RscPicture
{
	idc = 1403;
	text = "\A3\ui_f\data\map\markers\handdrawn\pickup_CA.paa";
	w = 0.05;
	h = 0.0666667;
};
class swt_icon_1404: RscPicture
{
	idc = 1404;
	text = "\A3\ui_f\data\map\markers\handdrawn\warning_CA.paa";
	w = 0.05;
	h = 0.0666667;
};
class swt_icon_1405: RscPicture
{
	idc = 1405;
	text = "\A3\ui_f\data\map\markers\handdrawn\unknown_CA.paa";
	w = 0.05;
	h = 0.0666667;
};
