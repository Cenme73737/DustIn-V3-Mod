import funkin.ui.FunkinText;
import flixel.tweens.FlxTweenType;
import flixel.util.FlxColor;
import funkin.game.SplashHandler;


public static var HUDcam:HudCamera;
var botText:FunkinText;
var fakebotText:FunkinText;
var botplayEnabled:Bool = false;
var colorTween:FlxTween;
var currentColorIndex:Int = 0;

function postCreate() {
    if (FlxG.save.data.botplay == null) {
        FlxG.save.data.botplay = false;
        FlxG.save.flush();
    }
    
    botplayEnabled = FlxG.save.data.botplay;
    
    if (botplayEnabled) {
        setupBotplay();
    }
}

function setupBotplay() {
    FlxG.cameras.add(HUDcam = new HudCamera(), false);
    HUDcam.bgColor = 0x00000000;
    HUDcam.downscroll = downscroll;
    if (FlxG.save.data.bottextvis == true) {
        botText = new FunkinText(0, 75, FlxG.width, "BOTPLAY");
    } else {
        botText = new FunkinText(0, 75, FlxG.width, "");
    }
    botText.alignment = "center";
    botText.cameras = [HUDcam];
    botText.setFormat(Paths.font("fallen-down.ttf"), 20, 0xFFFFFF);
    add(botText);

    // 透明度pingpong效果
    FlxTween.tween(botText, {alpha: 0}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
    
    // 添加彩色渐变效果
    startColorCycle();

    strumLines.members[1].forEach(function(obj:Strum) {
        obj.cpu = true;
    });

    strumLines.members[1].onNoteUpdate.add(function(event) {
        event.cancel();

        var sl = strumLines.members[1];

        var ignoredNoteTypes:Array<String> = ["Madness_NOTE_assets", "NOTE_karma", "NOTE_hate"];

        if (ignoredNoteTypes.indexOf(event.note.noteType) != -1) {
            if (event.__autoCPUHit && event.note.strumTime < sl.__updateNote_songPos) {
                event.note.tooLate = true;
            }
        } else {
            if (event.__updateHitWindow) {
                event.note.canBeHit = (event.note.strumTime > sl.__updateNote_songPos - (PlayState.instance.hitWindow * event.note.latePressWindow)
                    && event.note.strumTime < sl.__updateNote_songPos + (PlayState.instance.hitWindow * event.note.earlyPressWindow));

                if (event.note.strumTime < sl.__updateNote_songPos - PlayState.instance.hitWindow && !event.note.wasGoodHit)
                    event.note.tooLate = true;
            }

            if (event.__autoCPUHit && !event.note.avoid && !event.note.wasGoodHit && event.note.strumTime < sl.__updateNote_songPos) {
                PlayState.instance.goodNoteHit(sl, event.note);
            }

            if (event.note.wasGoodHit && event.note.isSustainNote && event.note.strumTime + (event.note.sustainLength) < sl.__updateNote_songPos) {
                deleteNote(event.note);
                return;
            }

            if (event.strum == null) return;

            if (event.__reposNote) event.strum.updateNotePosition(event.note);
            if (event.note.isSustainNote)
                event.note.updateSustain(event.strum);
        }
    });

    strumLines.members[1].onHit.add(function(event) {
        event.preventStrumGlow();
        
        if (event.note.__strum != null && event.note.__strum.press != null) {
            event.note.__strum.press(event.note.strumTime - (event.note.isSustainNote ? (event.note.nextSustain != null ? 0 : Conductor.crochet / 6.1) : (event.note.nextNote.isSustainNote ? 0 : Conductor.crochet / 6.1)));
        } else {
            trace("Error: __strum or press method is not defined.");
        }
    });
}

// 修复后的颜色循环函数
function startColorCycle() {
    //if (botText == null && fakebotText == null) return;
    if (botText == null) {
        botText = fakebotText;
    }
    // 如果已有颜色渐变在进行，则取消它
    if (colorTween != null) {
        colorTween.cancel();
        colorTween = null;
    }
    
    var colors:Array<FlxColor> = [
        0xFFFF0000, // 红色
        0xFFFFFF00, // 黄色
        0xFF00FF00, // 绿色
        0xFF00FFFF, // 青色
        0xFF0000FF, // 蓝色
        0xFFFF00FF  // 紫色
    ];
    
    // 设置初始颜色
    botText.color = colors[currentColorIndex];
    
    // 创建颜色循环
    colorTween = FlxTween.color(botText, 2.0, colors[currentColorIndex], colors[(currentColorIndex + 1) % colors.length], {
        ease: FlxEase.sineInOut,
        onComplete: function(tween:FlxTween) {
            // 更新索引
            currentColorIndex = (currentColorIndex + 1) % colors.length;
            // 开始下一个颜色过渡
            startColorCycle();
        }
    });
}

function update(elapsed:Float) {
    if (!FlxG.save.data.bottextvis) {
        songScore = 0;
    }
    if (controls.getJustPressed("toggleBotplay") && !FlxG.save.data.botplay && !player.cpu) {

        FlxG.cameras.add(HUDcam = new HudCamera(), false);
        HUDcam.bgColor = 0x00000000;
        HUDcam.downscroll = downscroll;
        fakebotText = new FunkinText(0, 75, FlxG.width, "Temporary\nBOTPLAY");
        fakebotText.alignment = "center";
        fakebotText.cameras = [HUDcam];
        fakebotText.setFormat(Paths.font("fallen-down.ttf"), 20, 0xFFFFFF);
        add(fakebotText);
        startColorCycle();

        // 透明度pingpong效果
        FlxTween.tween(fakebotText, {alpha: 0}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});

        player.cpu = !player.cpu;

    }else if (controls.getJustPressed("toggleBotplay") && !FlxG.save.data.botplay && player.cpu) {
        if (colorTween != null) {
            colorTween.cancel();
            colorTween = null;
        }
        
        // 重置颜色索引
        currentColorIndex = 0;
        
        player.cpu = !player.cpu;
        remove(fakebotText);
        fakebotText.destroy();
        fakebotText = null;
    }

    if (botplayEnabled && HUDcam != null) {
        HUDcam.zoom = camHUD.zoom;
        HUDcam.angle = camHUD.angle;
    }
}

function onInputUpdate(event) {
    if (botplayEnabled) {
        event.cancel();
    }
}

function onNoteCreation(event:NoteCreationEvent) {
    var ignoredNoteTypes:Array<String> = ["Madness_NOTE_assets", "NOTE_karma", "NOTE_hate"];

    if (!FlxG.save.data.mechanics && ignoredNoteTypes.indexOf(event.note.noteType) != -1) {
        event.note.strumTime -= 999999;
        event.note.exists = event.note.active = event.note.visible = false;
        return;
    }
}

function onPlayerMiss(event) {
    var ignoredNoteTypes:Array<String> = ["Madness_NOTE_assets", "NOTE_karma", "NOTE_hate"];

    if (ignoredNoteTypes.indexOf(event.noteType) != -1) {
        event.cancel(true); 
        event.note.strumLine.deleteNote(event.note);
    }
}

function onPlayerHit(event) {
    var ignoredNoteTypes:Array<String> = ["Madness_NOTE_assets", "NOTE_karma", "NOTE_hate"];

    if (ignoredNoteTypes.indexOf(event.noteType) != -1) {
        event.cancel(true);
    }
}

function toggleBotplay() {
    botplayEnabled = !botplayEnabled;
    FlxG.save.data.botplay = botplayEnabled;
    FlxG.save.flush();
    
    if (botplayEnabled) {
        setupBotplay();
        trace("Botplay enabled");
    } else {
        // 停止颜色渐变tween
        if (colorTween != null) {
            colorTween.cancel();
            colorTween = null;
        }
        
        // 重置颜色索引
        currentColorIndex = 0;
        
        if (HUDcam != null) {
            FlxG.cameras.remove(HUDcam);
            HUDcam = null;
        }
        if (botText != null) {
            remove(botText);
            botText.destroy();
            botText = null;
        }
        if (fakebotText != null) {
            remove(fakebotText);
            fakebotText.destroy();
            fakebotText = null;
        }
        trace("Botplay disabled");
    }
}