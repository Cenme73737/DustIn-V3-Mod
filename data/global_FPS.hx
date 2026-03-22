import funkin.backend.system.framerate.CodenameBuildField;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.assets.Paths;
import openfl.text.TextFormat;

FlxG.set_drawFramerate(1000);
FlxG.set_updateFramerate(1000);

function postStateSwitch() {
    Framerate.fpsCounter.fpsNum.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 25, -1);
    Framerate.fpsCounter.fpsLabel.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 16, -1);
    Framerate.codenameBuildField.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 20, -1);
    Framerate.memoryCounter.memoryText.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 15, -1);
    Framerate.memoryCounter.memoryPeakText.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('DTM-Mono.ttf')), 15, -1);

    Framerate.fpsCounter.fpsNum.x = 0;
    Framerate.fpsCounter.fpsNum.y = 0;

    Framerate.fpsCounter.fpsLabel.x = 35;
    Framerate.fpsCounter.fpsLabel.y = 0;

    Framerate.codenameBuildField.x = 0;
    Framerate.codenameBuildField.y = 25;

    Framerate.fpsCounter.fpsLabel.text = "FPS";
    Framerate.codenameBuildField.text = "\n周五夜幕 尘埃落V3";
}

function update(elapsed:Float) {
    sectionCrochet = 240 / Conductor.bpm;
    if (FlxG.save.data.fulls == true && FlxG.fullscreen == false){
        FlxG.fullscreen = true;
    }
    if (FlxG.save.data.fulls == false && FlxG.fullscreen == true){      
        FlxG.fullscreen = false;
    }
}
//由：LSVoiid，原始由：橙子