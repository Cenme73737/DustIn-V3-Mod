import funkin.backend.assets.Paths;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

FlxG.set_drawFramerate(1000);
FlxG.set_updateFramerate(1000);
function update(elapsed:Float) {
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
    if (FlxG.save.data.decf == 0 || FlxG.save.data.decf == null) {
        FlxG.save.data.decf = 14;
    }
    if (FlxG.save.data.brspeed == 0 || FlxG.save.data.brspeed == null) {
        FlxG.save.data.brspeed = 4;
    }
    if (FlxG.save.data.brold == true) {
        FlxG.save.data.brfix = true;
    }
    if (FlxG.save.data.brfix == false) {
        FlxG.save.data.brold = false;
    }
    if (FlxG.save.data.modVersion.indexOf("Stable") == -1) {
        FlxG.save.data.specialwarning = false;
    }
}
function postcreate() {
    FlxG.save.data.opp ??= false;
    FlxG.save.data.coop ??= false;
    if (FlxG.save.data.decf == 0) {
        FlxG.save.data.decf = 14;
    }
    if (FlxG.save.data.brspeed == 0) {
        FlxG.save.data.brspeed = 4;
    }
    FlxG.save.data.decf ??= 14;
    FlxG.save.data.hudvis ??= true;
    FlxG.save.data.brfix ??= true;
    FlxG.save.data.brold ??= false;
    FlxG.save.data.brspeed ??= 4;

    if (FlxG.save.data.fulls == null){
        FlxG.save.data.fulls = false;
    }
    FlxG.save.data.smdev ??= "disabled";
    FlxG.save.data.pushhealth ??= "disabled";
    FlxG.save.data.unlocksong ??= false;
    FlxG.save.data.specialwarning ??= false;
}
function create() {
    FlxG.save.data.opp ??= false;
    FlxG.save.data.coop ??= false;
    if (FlxG.save.data.decf == 0) {
        FlxG.save.data.decf = 14;
    }
    if (FlxG.save.data.brspeed == 0) {
        FlxG.save.data.brspeed = 4;
    }
    FlxG.save.data.decf ??= 14;
    FlxG.save.data.hudvis ??= true;
    FlxG.save.data.brfix ??= true;
    FlxG.save.data.brold ??= false;
    FlxG.save.data.brspeed ??= 4;

    if (FlxG.save.data.fulls == null){
        FlxG.save.data.fulls = false;
    }
    FlxG.save.data.smdev ??= "disabled";
    FlxG.save.data.pushhealth ??= "disabled";
    FlxG.save.data.unlocksong ??= false;
    FlxG.save.data.specialwarning ??= false;
}