importScript("data/global_collision");
importScript("data/global_overworld");
importScript("data/global_saves");
importScript("data/global_utils");
importScript("data/global_window");
importScript("data/global_FPS");
importScript("data/changer");

import funkin.backend.utils.NativeAPI;
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import hxvlc.util.Handle;
import haxe.io.Path;
import funkin.graphics.FunkinSprite;
import flixel.FlxState;

import Type;
import Sys;

var customSprite:FunkinSprite = null;

function new() {
	
    Handle.init([]);

    load_save();

    initCustomSprite(
        "懒人汉化组",
        100,
        100,
        0.8
    );
}

function preStateCreate() {
	FlxG.game.setFilters([]);

    if (customSprite != null && FlxG.state != null) {
        FlxG.state.add(customSprite);
    }

    updateCustomSprite(
        375,
        -130,
        1
    );

    FlxG.save.data.modVersion = "1.2.4-Preview";// ← 这里修改版本号显示 Stable 或 Preview
    FlxG.save.data.gameVersion = "1.2.4";
}

function initCustomSprite(imgPath:String, initX:Float, initY:Float, initAlpha:Float) {
    if (Assets.exists(Paths.image(imgPath))) {
        customSprite = new FunkinSprite(0, 0, Paths.image(imgPath));
        customSprite.x = initX;
        customSprite.y = initY;
        customSprite.alpha = initAlpha;
        customSprite.scrollFactor.set(0, 0);
        customSprite.updateHitbox();
    } else {
        NativeAPI.showMessageBox('贴图加载失败', '请检查贴图路径：' + imgPath);
    }
}

function updateCustomSprite(newX:Float, newY:Float, newAlpha:Float) {
    if (customSprite != null) {
        customSprite.x = newX;
        customSprite.y = newY;
        customSprite.alpha = Math.max(0, Math.min(1, newAlpha));
    }
}

function removeCustomSprite() {
    if (customSprite != null && FlxG.state != null) {
        FlxG.state.remove(customSprite);
        customSprite = null;
    }
}

//LSVoiid：别看了我的史山代码。