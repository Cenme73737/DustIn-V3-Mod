import funkin.ui.FunkinText;
import flixel.tweens.FlxTweenType;
import flixel.util.FlxColor;
import funkin.backend.system.RotatingSpriteGroup;
import flixel.text.FlxTextBorderStyle;
import funkin.game.ComboRating;

public static var HUDcam:HudCamera;
var botText:FunkinText;
var colorTween:FlxTween;
var currentColorIndex:Int = 0;

function onDadHit()  {
    if (!FlxG.save.data.opp || FlxG.save.data.pushhealth == "disabled") return;
    if (FlxG.save.data.pushhealth == "enabled"){
        if (health <= 1.9) health += 0.01;
    }else if (FlxG.save.data.pushhealth == "hard"){
        if (health <= 1.9) health += 0.03;
    }else if (FlxG.save.data.pushhealth == "endied"){
        health += 0.005;
    }else if (FlxG.save.data.pushhealth == "harddied"){
        health += 0.01;
    }
}
