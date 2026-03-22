//

import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.MusicBeatState;

var newWarningFont:FlxText = null;
function postCreate() {

    FlxG.camera.flash(0xFF000000, .3);
    MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
    disclaimer.text = "该模组含有大量着色器(光影),设备弱爆了的别对此模组抱有希望\n\n你可以在设置菜单中调整性能选项:\n设置 ># 外观# > *高级 *\n(溅射功能请见设置 > #外观#)\n(全屏功能另见设置 > #外观#)\n以及大量 *强光闪烁* 如有不适请 _谨慎游玩_ !!!\n\n_按下 回车/鼠标左 键以继续_\n+此汉化由 懒人汉化组 制作 由 可恶的360 制作附加功能\n懒人汉化组 录视频也很带π+";
    disclaimer.applyMarkup(disclaimer.text, [
        new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF5D5D), "*"),
        new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF55DAFF), "#"),
        new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), "_"),
        new FlxTextFormatMarkerPair(new FlxTextFormat(0x5B56CA), "+")
    ]);
    disclaimer.font = Paths.font("8bit-jve.ttf");
    disclaimer.textField.antiAliasType = 0/*ADVANCED*/;
    disclaimer.textField.sharpness = 400/*MAX ON OPENFL*/;
    disclaimer.y += 15;

    newWarningFont = new FlxText(0, 170, FlxG.width, "警 告");
    newWarningFont.setFormat(Paths.font("pixel-comic.ttf"), 100, 0xFFFFFFFF);
    newWarningFont.borderStyle = FlxTextBorderStyle.OUTLINE;
    newWarningFont.borderSize = 2;
    newWarningFont.borderColor = 0xFF000000;
    newWarningFont.textField.antiAliasType = 0/*ADVANCED*/;
    newWarningFont.textField.sharpness = 400/*MAX ON OPENFL*/;
    newWarningFont.alignment = "center";
    add(newWarningFont);

    titleAlphabet.visible = false;

    var freakingLunarBro = new FunkinSprite().loadGraphic(Paths.image('menus/credits/sprites/Lunarcleint'));
    add(freakingLunarBro);
    freakingLunarBro.scale.set(12, 12);
    freakingLunarBro.updateHitbox();
    freakingLunarBro.screenCenter();
    freakingLunarBro.x -= 675;
    freakingLunarBro.alpha = 0;

    new FlxTimer().start(20, function() {
        FlxTween.tween(freakingLunarBro, {alpha: 0.075, x: freakingLunarBro.x + 25}, 10);
    });
}

var __timer:Float = 0;
function update(elapsed:Float) {
    __timer += elapsed;
    if (controls.ACCEPT || FlxG.mouse.justPressed) {
        FlxG.camera.visible = false;
        goToTitle();
    }

    if (FlxG.keys.justPressed.F)
        FlxG.save.data.fulls = !FlxG.save.data.fulls;
}

function destroy() {
    Framerate.debugMode = 0;
}
