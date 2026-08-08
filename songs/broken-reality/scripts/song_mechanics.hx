import flixel.util.FlxSort;

var normalStrumPoses:Array<Array<Array<Int>>> = [];
var arrowSine:Bool = false;

var strumsOffsets:Array = [for (i in 0...4) [0,0]];

var drainTimer:Float = 0;
var drainEnabled:Bool = true;
public var drainAmount:Float = 1.2;

public var pluey:Float = 0;
public var hudOffY:Float = 0;
function update(elapsed:Float) {
    if (!FlxG.save.data.mechanics) PlayState.instance.scrollSpeed = 3.5;
    if (drainEnabled && drainTimer > 0) {
        if (health >= 0.15) health -= 0.05 * (drainAmount * (didDamage ? .65 : 1)) * elapsed;
        drainTimer -= elapsed;
    }
}

function fadeSansStrums(salpha:String) {
    if (!FlxG.save.data.mechanics) return;
    var falpha = Std.parseFloat(salpha);
    for (k=>s in strumLines.members[0].members) {
        FlxTween.tween(s, {alpha: falpha}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
    }
}

function onDadHit()  {
    if (!FlxG.save.data.mechanics) return;
    drainTimer += .12;
}

function enableDrain() {
    if (!FlxG.save.data.mechanics) return;
    drainEnabled = true;
    drainTimer = 0;
}

function disableDrain() {
    if (!FlxG.save.data.mechanics) return;
    drainEnabled = false;
    drainTimer = 0;
}

function changeDrainAmount(salpha:String) {
    if (!FlxG.save.data.mechanics) return;
    var falpha = Std.parseFloat(salpha);
    drainAmount = falpha;
}