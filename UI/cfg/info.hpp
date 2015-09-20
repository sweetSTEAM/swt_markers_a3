#define GR_W (((safezoneW/safezoneH) min 1.2)/40)
#define GR_H ((((safezoneW/safezoneH) min 1.2)/1.2)/25)

class swt_RscControlsGroup: swt_RscControlsGroup
{
	idc = 1103;
	x = 0;
	y = 0;
	w = 10 *  GR_W;
	h = 15 *  GR_H;
	class controls {
		class Info_butt_1 : swt_RscButtonMenu {
			idc = 2000;
			text = "Info";
			x = 0;
			y = 0;
			w = 3.33 *  GR_W;
			h = 1 *  GR_H;
			OnButtonClick = "[_this select 0,'info'] call swt_markers_info_buttons";
		};
		class Info_butt_2 : swt_RscButtonMenu {
			idc = 2001;
			text = "Sett";
			x = 3.33*  GR_W;
			y = 0;
			w = 3.33 *  GR_W;
			h = 1 *  GR_H;
			OnButtonClick = "[_this select 0,'sett'] call swt_markers_info_buttons";
		};
		class Info_butt_3 : swt_RscButtonMenu {
			idc = 2002;
			text = "Author";
			x = 6.66*  GR_W;
			y = 0;
			w = 3.33 *  GR_W;
			h = 1 *  GR_H;
			OnButtonClick = "[_this select 0,'author'] call swt_markers_info_buttons";
		};

		class Info_12 : RscStructuredText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = 1101;
			x = 0;
			y = 1 *  GR_H;
			w = 10 *  GR_W;
			h = 23.5 *  GR_H;
		};
	};
};