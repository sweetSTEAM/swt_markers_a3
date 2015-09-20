#define GR_W (((safezoneW/safezoneH) min 1.2)/40)
#define GR_H ((((safezoneW/safezoneH) min 1.2)/1.2)/25)

//TODO: BASE classes and normal inheritance
//

class CfgPatches {
	class swt_markers {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"a3_ui_f"};
		author[]= {"swatSTEAM"};
	};
};

class CfgFunctions
{
	class swt_markers
	{
		class Init
		{
			file = "\swt_markers_a3";
			class init {
				preInit = 1;
			};
		};
	};
};

#include "\swt_markers_a3\UI\cfg\base_controls.hpp"

class RscDisplayChannel
{
	onLoad = "[_this select 0] spawn {swt_markers_channel = ctrlText ((_this select 0) displayCtrl 101)}";
};

class swt_RscDisplayInsertMarker {
	enableSimulation = 0;
	onLoad = "_this call swt_markers_onLoad";
	onUnload = "call swt_markers_unLoad";
	idd = 54;
	movingEnable = true;
	onKeyDown = "_this call swt_markers_DOWN";
	onKeyUp = "_this call swt_markers_UP";
	onMouseButtonDown = "_this call swt_markers_d_cl_pic";
	onMouseZChanged = "_this call swt_markers_MouseZ";

	class controlsBackground {
		class Description: RscStructuredText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = 1100;
			x = 0;
			y = 0;
			w = 10 * GR_W;
			h = 2 * GR_H;
		};
	};

	class controls {
		class swt_Text: RscEdit {
			idc = 203;
			x = 0;
			y = 0;
			w = 10 * GR_W;
			h = 1 * GR_H;
			onKeyDown = "_this call swt_markers_editDOWN";
		};
		class swt_Picture: RscPicture {
			idc = 204;
			moving = true;
			x = 0.259984;
			y = 0.4;
			w = 0.05;
			h = 0.0666667;
		};
		class ButtonMenuOK: RscButtonMenuOK
		{
			default = 1;
			idc = 1;
			x = 0;
			y = 0;
			w = 5 *  GR_W;
			h = 1 *  GR_H;
			OnButtonClick = "['mark',(ctrlParent (_this select 0))] call swt_markers_sys_sendMark; true";
		};

		class ButtonChannel: swt_RscButton {
			idc = 205;
			x = 0;
			y = 0;
			w = 7 * GR_W;
			h = 1 * GR_H;
			OnButtonClick = "_this call swt_markers_click_chann";
		};
		class ButtonMenuCancel: RscButtonMenuCancel
		{
			idc = 2;
			x = 0;
			y = 0;
			w = 5 *  GR_W;
			h = 1 *  GR_H;
		};

		class ButtonMenuInfo: swt_RscButtonMenu {
			idc = 2400;
			text = "$STR_A3_RscDisplayInsertMarker_ButtonMenuInfo";
			x = 0;
			y = 0;
			w = 10 *  GR_W;
			h = 1 *  GR_H;
			OnButtonClick = "(_this select 0) call swt_markers_infoAnim";
		};

		class Settings_butt: swt_RscActivePicture {
			idc = 900;
			text = "\a3\Ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_config_ca.paa";
			x = 0;
			y = 0;
			w = 0.75 *  GR_H;
			h = 1 *  GR_H;
			OnButtonClick = "_this spawn swt_markers_set_butt";
		};


		class add_group: RscActiveText {
			idc = 903;
			text = "G";
			color[] = {1,1,1,0.25};
			colorText[] = {1,1,1,0.25};
			colorActive[] = {0.8,0.8,0.8,0.5};
			x = 0;
			y = 0;
			w = 0.5 * GR_H;
			h = 1 * GR_H;
			sizeEx = 0.8 * GR_H;
			OnButtonClick = "[_this select 0,'G'] call swt_markers_fast_text";
		};
		class add_name: RscActiveText {
			idc = 902;
			text = "N";
			color[] = {1,1,1,0.25};
			colorText[] = {1,1,1,0.25};
			colorActive[] = {0.8,0.8,0.8,0.5};
			x = 0;
			y = 0;
			w = 0.5 * GR_H;
			h = 1 * GR_H;
			sizeEx = 0.8 * GR_H;
			OnButtonClick = "[_this select 0,'N'] call swt_markers_fast_text";
		};
		class add_text: RscActiveText {
			idc = 901;
			text = "T";
			color[] = {1,1,1,0.25};
			colorText[] = {1,1,1,0.25};
			colorActive[] = {0.8,0.8,0.8,0.5};
			x = 0;
			y = 0;
			w = 0.5 * GR_H;
			h = 1 *  GR_H;
			sizeEx = 0.8 * GR_H;
			OnButtonClick = "[_this select 0,'T'] call swt_markers_fast_text";
		};

		class RscListbox_15000_color: RscListbox
		{
			idc = 15000;
			x = 0;
			y = 0;
			w = 2 * GR_W;
			h = 10 * GR_H;
			onLBSelChanged = "_this call swt_markers_lb_sel_adv";
		};
		class RscListbox_15001_pic: RscListbox
		{
			idc = 15001;
			x = 0;
			y = 0;
			w = 2 * GR_W;
			h = 10 * GR_H;
			onLBSelChanged = "_this call swt_markers_lb_sel_adv";
		};


		#include "\swt_markers_a3\UI\cfg\info.hpp"
		#include "\swt_markers_a3\UI\cfg\icons_colors.hpp"
		#include "\swt_markers_a3\UI\cfg\combo_sett.hpp"

		class swt_ButtonAdv: swt_RscButtonMenu {
			idc = 228;
			text = "$STR_SWT_M_ADV";
			x = 0;
			y = 0;
			w = 10 *  GR_W;
			h = 1 *  GR_H;
			OnButtonClick = "_this spawn swt_markers_adv_set_butt";
		};

		#include "\swt_markers_a3\UI\cfg\swt_RscControlsGroup_adv.hpp"


	};
};

#include "\swt_markers_a3\Stuff\modules.hpp"
