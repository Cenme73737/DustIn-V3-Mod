import funkin.backend.system.framerate.CodenameBuildField;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.assets.Paths;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

FlxG.set_drawFramerate(1000);
FlxG.set_updateFramerate(1000);

// 新增：静态彩色文本（位于窗口左上方，颜色随时间变化）
var rainbowText:TextField;
var hue:Float = 0;

function postStateSwitch() {
    Framerate.fpsCounter.fpsNum.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 25, -1);
    Framerate.fpsCounter.fpsLabel.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 16, -1);
    Framerate.codenameBuildField.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 20, -1);
    Framerate.memoryCounter.memoryText.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 15, -1);
    Framerate.memoryCounter.memoryPeakText.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 15, -1);

    Framerate.memoryCounter.memoryPeakText.y = 35;
    Framerate.memoryCounter.memoryText.y = 35;
    Framerate.fpsCounter.fpsNum.x = 0;
    Framerate.fpsCounter.fpsNum.y = 35;

    Framerate.fpsCounter.fpsLabel.x = 35;
    Framerate.fpsCounter.fpsLabel.y = 35;

    Framerate.codenameBuildField.x = 0;
    Framerate.codenameBuildField.y = 60;

    Framerate.fpsCounter.fpsLabel.text = "FPS";
    Framerate.codenameBuildField.text = "\n周五夜幕 尘埃落V3\n修改版1.2.3已生效";

    // 新增静态文本（避免与FPS计数器重叠，放在下方）
    if (rainbowText == null) {
        rainbowText = new TextField();
        rainbowText.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 25, -1);
        rainbowText.x = 0;
        rainbowText.y = 0;                    // 可自行调整Y值
        rainbowText.autoSize = TextFieldAutoSize.LEFT;
        rainbowText.selectable = false;
        rainbowText.text = "FND1.2.3-Preview\nGamePlay is not Final";     // ← 这里修改你想要显示的文字
        FlxG.stage.addChild(rainbowText);
        FlxG.stage.setChildIndex(rainbowText, FlxG.stage.numChildren - 1); // 确保在最上层
    }
}

function update(elapsed:Float) {
    sectionCrochet = 240 / Conductor.bpm;
    if (FlxG.save.data.fulls == true && FlxG.fullscreen == false){
        FlxG.fullscreen = true;
    }
    if (FlxG.save.data.fulls == false && FlxG.fullscreen == true){      
        FlxG.fullscreen = false;
    }
    if (FlxG.keys.justPressed.F11) {
        FlxG.save.data.fulls = !FlxG.save.data.fulls;
    }
    if (FlxG.save.data.opp == true) {
        FlxG.save.data.coop = false;
    }else if (FlxG.save.data.coop == true) {
        FlxG.save.data.opp = false;
    }

    // 新增：颜色随时间变化（彩虹效果）
    if (rainbowText != null) {
        hue += elapsed * 100;                  // 调节速度（200≈每秒转一圈多）
        while (hue >= 360) hue -= 360;
        var newColor:FlxColor = FlxColor.fromHSB(hue, 1.0, 1.0); // 饱和度1.0、亮度1.0，色彩鲜艳
        rainbowText.textColor = newColor;
    }
}
//由：LSVoiid，原始由：橙子