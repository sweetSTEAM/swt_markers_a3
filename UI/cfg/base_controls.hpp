
class RscListBox;
class RscIGUIListBox;
class RscXListBox;
class RscStructuredText;
class RscButtonMenu;
class RscButton;
class RscPicture;
class RscText;
class RscEdit;
class RscActivePicture;
class RscToolbox;
class RscIGUIShortcutButton;
class RscShortcutButton;
class RscActiveText;
class ScrollBar;
class RscCombo;
class RscControlsGroup;
class RscButtonMenuOK;
class RscButtonMenuCancel;
class RscCheckBox;

class swt_RscButtonMenu : RscButtonMenu
{
	style = 0x02;
	w = 10 * GR_W;
	h = 1 *  GR_H;
};

class swt_RscStructuredText : RscStructuredText
{
	x = (0.9+0.3) * GR_W;
	y = 0;
	w = (10-0.9) *  GR_W;
	h = 0.9 * GR_H;
	size = (GR_H * 0.85);
	class Attributes {
		color = "#ffffff";
 	};

};

class swt_RscCheckBox : RscCheckBox
{
	idc = -1;
	type = 77;
	style = 0;
	checked = 0;
	x = 0.3 * GR_W;
	y = 0;
	w = 1 * GR_W;
	h = 1 * GR_H;
};


class swt_ScrollBar: ScrollBar {
	color[] = {0,0,0,0.7};
	colorActive[] = {0,0,0,0.7};
	colorDisabled[] = {0,0,0,0.7};
	arrowEmpty = "#(argb,8,8,3)color(0,0,0,0)";
	arrowFull = "#(argb,8,8,3)color(0,0,0,0)";
};

class swt_RscControlsGroup: RscControlsGroup {
	class VScrollbar: swt_ScrollBar
	{
		width = 0.021;
		autoScrollEnabled = 1;
	};
	class HScrollbar: swt_ScrollBar
	{
		height = 0;
	};
};

class swt_RscCombo: RscCombo
{
	colorSelect[] = {0,0,0,1};
	colorText[] = {1,1,1,1.0};
	colorBackground[] = {0,0,0,0.7};
	colorSelectBackground[] = {1,1,1,0.7};
	colorScrollbar[] = {1,0,0,1};
	wholeHeight = 0.45;
	colorActive[] = {1,0,0,1};
	colorDisabled[] = {1,1,1,0.25};
	class ComboScrollBar: ScrollBar
	{
		color[] = {1,1,1,0.5};
	};
};

class swt_RscActivePicture: RscActivePicture
{
	style = 48;
	color[] = {1,1,1,0.6};
	colorActive[] = {1,1,1,1};
	w = (10/6) * GR_W;
	h = 0.7 * GR_H;
};

class swt_RscButton
{
	type = 1;
	style = 2;
	x = 0;
	y = 0;
	w = 0;
	h = 0;
	shadow = 2;
	font = "PuristaMedium";
	sizeEx = (GR_H * 1);
	text = "";
	colorText[] = {0,0,0,0};
	colorBackground[] = {0,0,0,0};
	colorFocused[] = {0,0,0,0};
	colorBackgroundActive[] = {0,0,0,0};
	colorDisabled[] = {0,0,0,0};
	colorBackgroundDisabled[] = {0,0,0,0};

	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0;
	offsetPressedY = 0;
	colorShadow[] = {0,0,0,0};
	colorBorder[] = {0,0,0,0};
	borderSize = 0.0;
	soundEnter[] = {};
	soundPush[] = {};
	soundClick[] = {};
	soundEscape[] = {};
};
