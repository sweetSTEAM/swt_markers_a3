#define GR_W (((safezoneW/safezoneH) min 1.2)/40)
#define GR_H ((((safezoneW/safezoneH) min 1.2)/1.2)/25)

class swt_RscControlsGroup_adv: swt_RscControlsGroup
{
	idc = 1104;
	x = 0;
	y = 0;
	w = 25 * GR_W;
	h = 20 * GR_H;
	class controls {
		class adv_background: RscText {
			idc = 822;
			x = 0;
			y = 0;
			w = (21.1) * GR_W;
			h = ((3.5*0.9)+(4.5*0.9)+(7.5*0.9) + 2.5 * 0.9 + 0.15) * GR_H;
			colorBackground[] = {0,0,0,0.7};
			text = "";
		};
		//-----------------------------------------------------------------------------------------------------
		class first_block: RscText {
			style = 64 + 2;
			x = 0.15 * GR_W;
			y = 0 * GR_H;
			text = $STR_SWT_M_SHOW_BUTTONS;
			w = (9.7) * GR_W;
			h = (3.5*0.9) * GR_H;
			SizeEx = 0.8 * GR_H;
			colorText[] = {248/255,131/255,121/255,1};
		};
		//////////
		class cb_show_butt: swt_RscCheckBox {
			idc = 229;
			y = (0.9)* GR_H;
			onButtonClick = "[_this,'SHOW OK'] spawn swt_markers_cb_butt";
		};
		class text_show_butt : swt_RscStructuredText {
			idc = 230;
			text = $STR_SWT_M_OKCAN;
			y = (0.9) * GR_H;
		};
		//////////////
		class cb_show_info: swt_RscCheckBox {
			idc = 241;
			x = (0.3) * GR_W;
			y = (2*0.9) * GR_H;
			onButtonClick = "[_this,'SHOW INFO'] spawn swt_markers_cb_butt";
		};
		class text_show_info : swt_RscStructuredText {
			idc = 242;
			text = INFO;
			y = (2*0.9) * GR_H;
		};
		//-----------------------------------------------------------------------------------------------------
		class Second_block: first_block {
			x = 0.15 * GR_W;
			y = (3.5*0.9) * GR_H;
			text = $STR_SWT_M_CHOOSE;
			h = (4.5*0.9) * GR_H;
		};
		//////////
		class cb_show_icon: swt_RscCheckBox {
			idc = 231;
			y = (3.5*0.9+0.9) * GR_H;
			onButtonClick = "[_this,'SHOW ICON'] spawn swt_markers_cb_butt";
		};
		class text_show_icon: swt_RscStructuredText {
			idc = 232;
			text = $STR_SWT_M_ICONS;
			y = (3.5*0.9+0.9) * GR_H;
		};
		/////////
		class cb_show_color: swt_RscCheckBox {
			idc = 233;
			y = (3.5*0.9+2*0.9) * GR_H;
			onButtonClick = "[_this,'SHOW COLOR'] spawn swt_markers_cb_butt";
		};
		class text_show_color: swt_RscStructuredText {
			idc = 234;
			text = $STR_SWT_M_COLORS;
			y = (3.5*0.9+2*0.9) * GR_H;
		};
		////////////
		class cb_show_lb: swt_RscCheckBox {
			idc = 235;
			y = (3.5*0.9+3*0.9) * GR_H;
			onButtonClick = "[_this,'SHOW LB'] spawn swt_markers_cb_butt";
		};
		class text_show_lb: swt_RscStructuredText {
			idc = 236;
			text = $STR_SWT_M_ADVL;
			y = (3.5*0.9+3*0.9) * GR_H;
		};
		//-----------------------------------------------------------------------------------------------------
		class third_block: first_block {
			style = 64 + 2;
			x = 0.15 * GR_W;
			y = ((3.5*0.9)+(4.5*0.9)) * GR_H;
			text = $STR_SWT_M_F;
			h = (7.5*0.9) * GR_H;
			SizeEx = 0.8 * GR_H;
		};
		/////////////
		class cb_save_text: swt_RscCheckBox {
			idc = 237;
			y = ((3.5*0.9)+(4.5*0.9) + 0.9) * GR_H;
			onButtonClick = "[_this,'SAVE TEXT'] spawn swt_markers_cb_butt";
		};
		class text_save_text: swt_RscStructuredText {
			idc = 238;
			text = $STR_SWT_M_SAVET;
			y = ((3.5*0.9)+(4.5*0.9) + 0.9) * GR_H;
		};
		////////////
		class cb_save_mark: swt_RscCheckBox {
			idc = 245;
			y = ((3.5*0.9)+(4.5*0.9) + 2*0.9) * GR_H;
			onButtonClick = "[_this,'SAVE MARK'] spawn swt_markers_cb_butt";
		};
		class text_save_mark: swt_RscStructuredText {
			idc = 246;
			text = $STR_SWT_M_SAVEM;
			y = ((3.5*0.9)+(4.5*0.9) + 2*0.9) * GR_H;
		};
		////////////
		class cb_fast_load: swt_RscCheckBox {
			idc = 239;
			y = ((3.5*0.9)+(4.5*0.9)+3*0.9)* ((((safezoneW/safezoneH) min 1.2) / 1.2) / 25);
			onButtonClick = "[_this,'FAST LOAD'] spawn swt_markers_cb_butt";
		};
		class text_fast_load: swt_RscStructuredText {
			idc = 240;
			text = $STR_SWT_M_FASTL;
			y = ((3.5*0.9)+(4.5*0.9)+3*0.9) * GR_H;
		};
		////////////
		class cb_show_back: swt_RscCheckBox {
			idc = 243;
			y = ((3.5*0.9)+(4.5*0.9) + 4*0.9) * GR_H;
			onButtonClick = "[_this,'SHOW BACK'] spawn swt_markers_cb_butt";
		};
		class text_show_back: swt_RscStructuredText {
			idc = 244;
			text = $STR_SWT_M_BACKGROUND;
			y = ((3.5*0.9)+(4.5*0.9) + 4*0.9) * GR_H;
		};
		////////////
		class cb_log: swt_RscCheckBox {
			idc = 247;
			y = ((3.5*0.9)+(4.5*0.9) + 5*0.9) * GR_H;
			onButtonClick = "[_this,'LOG'] spawn swt_markers_cb_butt";
		};
		class text_log: swt_RscStructuredText {
			idc = 248;
			text = $STR_SWT_M_LOG;
			y = ((3.5*0.9)+(4.5*0.9) + 5*0.9) * GR_H;
		};
		////////////
		class cb_markinfo: swt_RscCheckBox {
			idc = 249;
			y = ((3.5*0.9)+(4.5*0.9) + 6*0.9) * GR_H;
			onButtonClick = "[_this,'MARK INFO'] spawn swt_markers_cb_butt";
		};
		class text_markimfo: swt_RscStructuredText {
			idc = 250;
			text = $STR_SWT_M_MARKINFO;
			y = ((3.5*0.9)+(4.5*0.9) + 6*0.9) * GR_H;
		};
		//-----------------------------------------------------------------------------------------------------
		class swt_text_saved: first_block {
			idc = -1;
			text = $STR_SWT_M_SAVEDTEXT;
			x = 0.3 * GR_W;
			y = ((3.5*0.9)+(4.5*0.9)+(7.5*0.9)) * GR_H;
			h = 2.5 * 0.9 * GR_H;
		};
		class swt_edit_saved: RscEdit {
			idc = 551;
			text = "";
			x = 0.45 * GR_W;
			y = ((3.5*0.9)+(4.5*0.9)+(7.5*0.9) + 0.9) * GR_H;
			w = 9.2 * GR_W;
			h = 1 * GR_H;
			onKeyUp = "swt_markers_fast_text_T_saved = ctrlText (_this select 0);swt_marker_settings_params set [9, swt_markers_fast_text_T_saved]; profileNamespace setVariable ['swt_marker_settings_params', swt_marker_settings_params];saveProfileNamespace;";
			color[] = {1,1,1,1};
		};
		//-----------------------------------------------------------------------------------------------------


		class swt_text_markersmap: first_block {
			idc = 650;
			text = $STR_SWT_M_SAVEDM;
			x = 10.2 * GR_W;
			y = 0 * GR_H;
			w = 10.8 * GR_W;
			h = (9 + 9*0.15) * GR_H;
		};



		class swt_text_markerspr: first_block {
			idc = 651;
			text = $STR_SWT_M_INPROF;
			x = 10.4 * GR_W;
			y = 1 * GR_H;
			w = 10.4 * GR_W;
			h = (4+4*0.15) * GR_H;
		};
		class swt_ButtonSAVE: swt_RscButtonMenu {
			idc = 347;
			text = $STR_SWT_M_SAVE;
			x = 10.6 * GR_W;
			y = 2 * GR_H;
			size = 0.85 * (GR_H * 1);
			OnButtonClick = "_this call swt_markers_fnc_save_markers";
		};
		class swt_ButtonLOAD: swt_ButtonSAVE {
			idc = 348;
			text = $STR_SWT_M_LOAD;
			y = (3 + 1*0.15) * GR_H;
			OnButtonClick = "[_this] call swt_markers_fnc_load_markers";
		};
		class swt_ButtonUnload: swt_ButtonSAVE {
			idc = 346;
			text = $STR_SWT_M_UNLOAD;
			y = (4 + 2*0.15) * GR_H;
			OnButtonClick = "profileNamespace setVariable ['swt_markers_save_arr',[]]; saveProfileNamespace;";
		};



		class swt_text_clip: first_block {
			idc = 652;
			text = $STR_SWT_M_CLIP;
			x = 10.4 * GR_W;
			y = (5 + 3*0.15) * GR_H;
			w = 10.4 * GR_W;
			h = (4+4*0.15) * GR_H;
		};
		class swt_ButtonSaveClp: swt_ButtonSAVE {
			idc = 351;
			text = $STR_SWT_M_SAVE;
			y = (6 + 3*0.15) * GR_H;
			OnButtonClick = "'CLIP' call swt_markers_fnc_save_markers";
		};
		class swt_Edit: RscEdit {
			idc =  653;
			text = $STR_SWT_M_ENTERARRAY;
			x = 10.6 * GR_W;
			y = (7 + 4*0.15) * GR_H;
			w = 10 * GR_W;
			h = 1 * GR_H;
			size = 0.85*(GR_H * 1);
		};
		class swt_ButtonClpLoad: swt_ButtonSAVE {
			idc = 654;
			text = "$STR_SWT_M_LOAD";
			y = (8 + 5*0.15) * GR_H;
			OnButtonClick = "[_this,ctrlText ((ctrlParent (_this select 0)) displayCtrl 653)] call swt_markers_fnc_load_markers";
		};

		class swt_Buttondef: swt_ButtonSAVE {
			idc = 345;
			text = $STR_SWT_M_DEF;
			y = (9 + 10*0.15) * GR_H;
			colorBackground[] = {0.957, 0, 0, 0.8};
			color[] = {0,0,0,1};
			OnButtonClick = "call swt_def; (ctrlParent (_this select 0)) closeDisplay 0;";

		};
		class swt_ButtonClear: swt_ButtonSAVE {
			idc = 349;
			text = $STR_SWT_M_CLEARMAP;
			y = (10 + 11*0.15) * GR_H;
			colorBackground[] = {0.957, 0, 0, 0.8};
			color[] = {0,0,0,1};
			OnButtonClick = "call swt_markers_clear_map";

		};
		class swt_ButtonDisable : swt_ButtonSAVE {
			idc = 350;
			text = $STR_SWT_M_DISABLE;
			y = (11 + 12*0.15) * GR_H;
			colorBackground[] = {0.957, 0, 0, 0.8};
			color[] = {0,0,0,1};
			OnButtonClick = "(_this select 0) call swt_markers_DisableLoc_fnc";
		};
	};
};
