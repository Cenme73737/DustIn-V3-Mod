// 存储每个音轨的按键状态、动画和默认大小
var isKeyPressed:Array<Bool> = [];
var currentTween:Array<FlxTween> = [];
var lastKeyState:Array<Bool> = []; // 记录上一帧的按键状态
var defaultScale:Array<Float> = []; // 记录每个箭头的默认Y轴大小
var st = 0.9;//修改缩小比例
var timesst = 0.2;//修改缩小时间
if (!FlxG.save.data.noteqq) {
    return;
}
function postCreate()
{
    for (i in 0...playerStrums.members.length) {
        var strum = playerStrums.members[i];
        strum.updateHitbox();
    }
    
    // 初始化数组（只处理0-3四个音轨）
    for (i in 0...4) {
        isKeyPressed[i] = false;
        lastKeyState[i] = false;
        currentTween[i] = null;
        
        // 获取对应的strum并记录默认大小
        var strum = playerStrums.members[i];
        if (strum != null) {
            defaultScale[i] = strum.scale.y;
        } else {
            defaultScale[i] = 1.0;
        }
    }
}

// 在update中检测按键状态
function update(elapsed:Float) {
    // 检查四个音轨的按键状态
    for (i in 0...4) {
        var currentKeyState = getKeyState(i);
        
        // 按键状态变化检测
        if (currentKeyState && !lastKeyState[i]) {
            // 按键刚按下
            onKeyDown(i);
        } else if (!currentKeyState && lastKeyState[i]) {
            // 按键刚松开
            onKeyUp(i);
        }
        
        // 更新上一帧状态
        lastKeyState[i] = currentKeyState;
    }
}

// 获取指定音轨的按键状态
function getKeyState(trackIndex:Int):Bool {
    switch(trackIndex) {
        case 0: // 左
            return controls.NOTE_LEFT_P || controls.NOTE_LEFT;
        case 1: // 下
            return controls.NOTE_DOWN_P || controls.NOTE_DOWN;
        case 2: // 上
            return controls.NOTE_UP_P || controls.NOTE_UP;
        case 3: // 右
            return controls.NOTE_RIGHT_P || controls.NOTE_RIGHT;
        default:
            return false;
    }
}

// 按键按下处理 - 使用固定值0.75倍默认大小
function onKeyDown(index:Int):Void {
    if (index >= 0 && index < 4) {
        // 如果已有动画正在进行，先停止它
        if (currentTween[index] != null) {
            currentTween[index].cancel();
            currentTween[index] = null;
        }
        
        // 获取对应的strum
        var strum = playerStrums.members[index];
        if (strum != null) {
            // 从当前状态弹性过渡到0.75倍默认大小
            currentTween[index] = FlxTween.tween(strum.scale, { y: defaultScale[index] * st }, timesst, {
                ease: FlxEase.elasticOut
            });
        }
    }
}

// 按键松开处理 - 恢复到默认大小
function onKeyUp(index:Int):Void {
    if (index >= 0 && index < 4) {
        // 如果已有动画正在进行，先停止它
        if (currentTween[index] != null) {
            currentTween[index].cancel();
            currentTween[index] = null;
        }
        
        // 获取对应的strum
        var strum = playerStrums.members[index];
        if (strum != null) {
            // 从当前状态弹性过渡回默认大小
            currentTween[index] = FlxTween.tween(strum.scale, { y: defaultScale[index] }, timesst, {
                ease: FlxEase.elasticOut,
                onComplete: function(t:FlxTween) {
                    currentTween[index] = null;
                }
            });
        }
    }
}

// 在销毁时取消所有动画
function onDestroy():Void {
    // 取消所有动画
    for (i in 0...4) {
        if (currentTween[i] != null) {
            currentTween[i].cancel();
            currentTween[i] = null;
        }
    }
}
/**
⠀⠀⠀⠀⢠⡿⠛⢻⡆⣴⠿⠿⠻⣦⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⠛⠛⠛⠛⢻⡇⠀⠀⠀⠀⠀
⠀⠀⠀⢠⡟⠁⠀⠈⠿⠋⠀⠀⠀⢿⡄⠀⠀⠀⠀⠀⠀⠀⠸⣷⣦⠀⠀⣶⣾⡇⠀⠀⠀⠀⠀
⠀⠀⢀⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀
⠀⢀⣾⠃⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀
⢀⣼⠇⠀⠀⢀⣾⣧⣰⡿⣧⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀
⣾⣇⠀⠀⢀⣾⠃⠘⠟⠀⢻⡆⠀⠀⠀⣿⡀⠀⠀⠀⠀⠀⢠⣤⣿⠀⠀⣿⣄⣀⡀⠀⠀⠀⠀
⠉⠙⠻⢶⡾⠃⠀⠀⠀⠀⠀⢿⣤⡶⠾⠛⠃⠀⠀⠀⠀⠀⣼⡏⠁⠀⠀⠈⠉⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠛⠛⠛⠻⠿⠿⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣶⣶⣶⣶⣶⣶⣶⣶⣦⣤⣤⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⠀⠀⠀
⠀⢠⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⣿⠛⠛⢻⣦⡾⠉⠉⠉⣿⡀⠀⠀
⠀⢸⣿⠀⠀⢀⣄⣀⣀⣀⡀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⣼⠇⠀⠀⠈⠛⠁⠀⠀⠀⢸⣇⠀⠀
⠀⢸⡇⠀⠀⢸⡏⠉⠉⢹⣿⠀⠀⢠⣿⠀⠀⠀⠀⠀⢀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡄⠀
⠀⢸⡇⠀⠀⢸⣇⣀⣀⣸⣿⠀⠀⢸⡿⠀⠀⠀⠀⠀⣸⡇⠀⠀⢠⣄⠀⢀⣶⡄⠀⠀⠸⣧⠀
⠀⢸⡇⠀⠀⠈⠉⠉⠉⠉⠉⠀⠀⢸⡇⠀⠀⠀⠀⢀⣿⠀⠀⠀⣿⠙⢷⡾⠻⣷⠀⠀⠀⢹⡇
⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⢸⡇⠀⠀⣸⡇⠀⠀⠀⠀⢻⡆⠀⣀⣨⣿
⠀⠘⠛⠛⠻⠿⠿⠿⠿⠿⠿⠿⠿⠿⠇⠀⠀⠀⠀⠙⠛⠷⣦⣿⠀⠀⠀⠀⠀⠈⠿⠛⠋⠉⠀
 */