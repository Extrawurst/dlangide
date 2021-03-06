module app;

import dlangui.all;
import std.stdio;
import std.conv;
import dlangide.ui.frame;
import dlangide.ui.commands;
import dlangide.workspace.workspace;


mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args) {


    // embed non-standard resources listed in views/resources.list into executable
    embeddedResourceList.addResources(embedResourcesFromList!("resources.list")());

    // you can override default hinting mode here
    //FontManager.hintingMode = HintingMode.Light;
    //FontManager.hintingMode = HintingMode.AutoHint;
    FontManager.hintingMode = HintingMode.Normal;
    //FontManager.hintingMode = HintingMode.Disabled;
    // you can override antialiasing setting here
    FontManager.minAnitialiasedFontSize = 0;
    /// set font gamma (1.0 is neutral, < 1.0 makes glyphs lighter, >1.0 makes glyphs bolder)
    FontManager.fontGamma = 0.8;
	version (USE_OPENGL) {
		// you can turn on subpixel font rendering (ClearType) here
		FontManager.subpixelRenderingMode = SubpixelRenderingMode.None; //
		FontManager.fontGamma = 0.8;
		FontManager.hintingMode = HintingMode.AutoHint;
	} else {
        version (USE_FREETYPE) {
            // you can turn on subpixel font rendering (ClearType) here
            FontManager.fontGamma = 0.8;
		    //FontManager.subpixelRenderingMode = SubpixelRenderingMode.BGR; //SubpixelRenderingMode.None; //
            FontManager.hintingMode = HintingMode.AutoHint;
        }
	}

    //import ddc.lexer.tokenizer;
    //runTokenizerTest();

    // create window
    Window window = Platform.instance.createWindow("Dlang IDE", null, WindowFlag.Resizable, 900, 700);
	
    IDEFrame frame = new IDEFrame(window);

    // create some widget to show in window
    window.windowIcon = drawableCache.getImage("dlangui-logo1");

    // open home screen tab
    frame.showHomeScreen();
    // for testing: load workspace at startup
    //frame.openFileOrWorkspace(appendPath(exePath, "../workspaces/sample1/sample1.dlangidews"));

    // show window
    window.show();

    //jsonTest();

    // run message loop
    return Platform.instance.enterMessageLoop();
}


unittest {
    void jsonTest() {
        import dlangui.core.settings;
        Setting s = new Setting();
        s["param1_ulong"] = cast(ulong)1543453u;
        s["param2_long"] = cast(long)-22934;
        s["param3_double"] = -39.123e-10;
        s["param4_string"] = "some string value";
        s["param5_bool_true"] = true;
        s["param6_bool_false"] = false;
        s["param7_null"] = new Setting();
        Setting a = new Setting();
        a[0] = cast(ulong)1u;
        a[1] = cast(long)-2;
        a[2] = 3.3;
        a[3] = "some string value";
        a[4] = true;
        a[5] = false;
        a[6] = new Setting();
        Setting mm = new Setting();
        mm["n"] = cast(ulong)5u;
        mm["name"] = "test";
        a[7] = mm;
        s["param8_array"] = a;
        Setting m = new Setting();
        m["aaa"] = "bbb";
        m["aaa2"] = cast(ulong)5u;
        m["aaa3"] = false;
        s["param9_object"] = m;
        string json = s.toJSON(true);
        s.save("test_file.json");

        Setting loaded = new Setting();
        loaded.load("test_file.json");
        string json2 = loaded.toJSON(true);
        loaded.save("test_file2.json");
    }

}