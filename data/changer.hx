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
}
function postcreate() {
    FlxG.save.data.opp ??= false;
    FlxG.save.data.coop ??= false;
    FlxG.save.data.decf ??= 14;
    FlxG.save.data.hudvis ??= true;
    
    if (FlxG.save.data.fulls == null){
        FlxG.save.data.fulls = false;
    }
}