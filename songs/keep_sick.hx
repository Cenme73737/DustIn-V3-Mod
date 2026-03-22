import funkin.ui.FunkinText;
import flixel.tweens.FlxTweenType;
import flixel.util.FlxColor;
import funkin.backend.system.RotatingSpriteGroup;
import flixel.text.FlxTextBorderStyle;
import funkin.game.ComboRating;

public static var HUDcam:HudCamera;
var botText:FunkinText;
var ksEnabled:Bool = false;
var colorTween:FlxTween;
var currentColorIndex:Int = 0;

function postCreate() {
    if (FlxG.save.data.ks == null) {
        FlxG.save.data.ks = false;
        FlxG.save.flush();
    }
    
    ksEnabled = FlxG.save.data.ks;
}

function update() {
    if (ksEnabled) {
        hitWindow = 10.0;
    }
}