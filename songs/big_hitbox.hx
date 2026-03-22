import funkin.ui.FunkinText;
import flixel.tweens.FlxTweenType;
import flixel.util.FlxColor;
import funkin.backend.system.RotatingSpriteGroup;
import flixel.text.FlxTextBorderStyle;
import funkin.game.ComboRating;

public static var HUDcam:HudCamera;
var botText:FunkinText;
var bibEnabled:Bool = false;
var colorTween:FlxTween;
var currentColorIndex:Int = 0;

function postCreate() {
    if (FlxG.save.data.bib == null) {
        FlxG.save.data.bib = false;
        FlxG.save.flush();
    }
    
    bibEnabled = FlxG.save.data.bib;
}

function update() {
    if (bibEnabled) {
        hitWindow *= 2.5;
    }
}