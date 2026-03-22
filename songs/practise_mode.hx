import funkin.ui.FunkinText;
import flixel.tweens.FlxTweenType;
import flixel.util.FlxColor;

public static var HUDcam:HudCamera;
var botText:FunkinText;
var preEnabled:Bool = false;
var colorTween:FlxTween;
var currentColorIndex:Int = 0;

function postCreate() {
    if (FlxG.save.data.pre == null) {
        FlxG.save.data.pre = false;
        FlxG.save.flush();
    }
    
    preEnabled = FlxG.save.data.pre;
    
    if (preEnabled) {
        setupPre();
    }
}

function setupPre() {
    canDie = canDadDie = false;
}