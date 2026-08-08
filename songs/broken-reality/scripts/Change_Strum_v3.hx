// Change_Strum_v3.hx
// Codename Engine Gameplay HScript
//
// Public functions:
//   goDownScroll() -> switch to the OPPOSITE of the game's song-start setting.
//   goUpScroll()   -> restore the EXACT song-start appearance/direction.
//
// IMPORTANT:
// - No automatic timer switching.
// - Never writes downscroll / camHUD.downscroll.
// - Different function calls INTERRUPT the previous transition immediately.
// - Repeating the SAME requested function only rotates receptors 360 degrees.
// - Game-start receptor/UI layout is captured as-is and is NOT rearranged.
// - Only StrumLines listed in STRUMLINE_WHITELIST are allowed to change.
//
// Put in:
//   songs/YOUR-SONG/scripts/Change_Strum_v3.hx
//
// Remove/disable older ScreenFlowSwap / Change_Strum test scripts.

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import funkin.backend.system.Conductor;

if (!FlxG.save.data.mechanics)
    return;// 如果没有开启机制，就不加载这个脚本。

// ============================================================================
// CONFIGURATION / 配置区域
// ============================================================================
//
// 这里集中修改动画参数。
// 不需要修改下面的核心逻辑。

// --------------------------------------------------------------------------
// 轨道白名单 / STRUMLINE WHITELIST
// --------------------------------------------------------------------------
//
// 只有这里列出的“铺面编号 / StrumLine 编号”会被本脚本控制：
// - 判定键上下移动
// - 判定键旋转 360°
// - 铺面流向切换
// - 短键 / 长键 / 尾巴的手动定位
//
// 不在白名单里的轨道保持 CNE 原生行为，脚本不会修改它们。
//
// 编号从 0 开始。
// 例如：
//   [0]       = 只控制第 0 条铺面
//   [1]       = 只控制第 1 条铺面
//   [0, 1]    = 控制第 0、1 条铺面
//   [1, 3, 5] = 只控制第 1、3、5 条铺面
//
// 默认示例：控制第 0、1 条铺面。
// 请按你的歌曲实际 StrumLine 编号修改。
var STRUMLINE_WHITELIST = [1];

// 判定键从一侧移动到另一侧所需时间（秒）。
var STRUM_MOVE_TIME = 0.65;

// 判定键每次旋转 360° 所需时间（秒）。
// 重复调用相同函数时，只会执行这个旋转动画。
var STRUM_SPIN_TIME = 0.65;

// 每次旋转的角度。
// 默认 360 = 完整旋转一圈。
var STRUM_SPIN_DEGREES = 360.0;

// 铺面流向从当前方向平滑切换到目标方向所需时间（秒）。
var NOTE_FLOW_TIME = 0.65;

// UI 向当前最近屏幕边缘移出的时间（秒）。
var HUD_OUT_TIME = 0.32;

// UI 从屏幕另一侧进入目标位置的时间（秒）。
var HUD_IN_TIME = 0.33;

// UI 完全离屏后额外留出的距离（像素）。
// 数值越大，UI 会藏得更远。
var HUD_OFFSCREEN_PADDING = 20.0;


// ============================================================================
// CORE STATE / 核心状态
// ============================================================================

// 游戏正式开始时的真实设置。
// 只读取，不修改。
var startSettingDownscroll = Options.downScroll;

// false = HOME：与游戏开始时完全相同。
// true  = OPPOSITE：与游戏开始时完全相反。
var currentOppositeState = false;

// 最新一次函数调用要求的目标状态。
var targetOppositeState = false;

var initialized = false;

// 只表示“布局/流向切换”是否正在进行。
// 单独的重复旋转不会改变这个变量。
var switching = false;


// ============================================================================
// NOTE FLOW / 铺面流向
// ============================================================================

// flowProxy.x 是“屏幕视觉方向”：
//
// +1 = Future notes 在判定键下方，向上接近判定键。
// -1 = Future notes 在判定键上方，向下接近判定键。
//
// 注意：
// 这里从不通过修改真实 downscroll 或负 scrollSpeed 来切换方向。
var flowProxy = null;


// ============================================================================
// ACTIVE NOTE BUFFER / 当前帧 Note 缓冲
// ============================================================================
//
// CNE 的 StrumLine.onNoteUpdate 只会提供当前真正需要更新的 Note。
// 这里只保存这些 Note，然后在 postUpdate 中统一定位。
// 不会每帧扫描整张谱面。

var activeNotes = [];
var activeStrums = [];
var activeCount = 0;


// ============================================================================
// RECEPTOR DATA / 判定键数据
// ============================================================================

// 白名单内、真正由本脚本接管的 StrumLine。
var controlledLines = [];

// 对应 controlledLines 的原始 strumLines.members 下标。
var controlledLineIndexes = [];

var savedStrums = [];

// 开局时屏幕上真实看到的 Y。
// HOME 永远使用这个位置。
var strumHomeShownY = [];

// HOME 的垂直镜像位置。
var strumOppositeShownY = [];

// 每个判定键原始角度。
var strumBaseAngle = [];

// 分离保存移动 Tween 和旋转 Tween。
// 这样重复同函数调用时，可以只重启旋转，不影响位置动画。
var strumMoveTweens = [];
var strumSpinTweens = [];


// ============================================================================
// HUD DATA / UI 数据
// ============================================================================
//
// 只控制：
//   dustinHealthBG
//   dustinHealthBar
//   timeBarBG
//   timeBar
//   scoreTxt
//   missesTxt
//   accuracyTxt

// HUD mover 保存的是 dustinHealthBG 的 RAW Y（不是 shown Y）。
var hudMover = null;

var hudBaseX = 0.0;

// HOME = 开局实际的 dustinHealthBG raw Y。
// 初始化阶段绝不重排 UI。
var hudHomeRawY = 0.0;

// OPPOSITE = 把整个开局 UI 组平移到屏幕另一侧后的 raw Y。
var hudOppositeRawY = 0.0;

// 开局 UI 组在屏幕上的边界和 anchor。
var hudHomeShownTop = 0.0;
var hudHomeShownBottom = 0.0;
var hudHomeAnchorShownY = 0.0;

// OPPOSITE UI 组在屏幕上的边界和 anchor。
var hudOppositeShownTop = 0.0;
var hudOppositeShownBottom = 0.0;
var hudOppositeAnchorShownY = 0.0;

var hudTween = null;
var hudMoving = false;


// ============================================================================
// TRANSITION CONTROL / 中断控制
// ============================================================================

// 最新一次布局切换的完成 Timer。
// 新的“不同函数调用”会取消旧 Timer。
var transitionTimer = null;


// ============================================================================
// STRUMLINE WHITELIST HELPERS
// ============================================================================

function isWhitelistedLineIndex(index) {
    for (allowed in STRUMLINE_WHITELIST) {
        if (allowed == index)
            return true;
    }

    return false;
}


// 根据白名单建立实际受控轨道列表。
// 白名单中不存在的编号会自动忽略。
function buildControlledLines() {
    controlledLines = [];
    controlledLineIndexes = [];

    for (lineIndex in 0...strumLines.members.length) {
        if (!isWhitelistedLineIndex(lineIndex))
            continue;

        var line = strumLines.members[lineIndex];

        if (line == null)
            continue;

        controlledLines.push(line);
        controlledLineIndexes.push(lineIndex);
    }

    for (allowed in STRUMLINE_WHITELIST) {
        if (
            allowed < 0
            || allowed >= strumLines.members.length
            || strumLines.members[allowed] == null
        ) {
            trace(
                "[Change_Strum_v3] whitelist line ignored (not found): "
                + allowed
            );
        }
    }

    trace(
        "[Change_Strum_v3] controlled StrumLines = "
        + controlledLineIndexes
    );
}


// ============================================================================
// FLOW HELPERS
// ============================================================================

function getHomeFlow() {
    // 游戏设置 Downscroll=true：
    // HOME 的视觉铺面方向就是向下。
    return startSettingDownscroll ? -1.0 : 1.0;
}


function getFlowForState(opposite) {
    var homeFlow = getHomeFlow();

    return opposite
        ? -homeFlow
        : homeFlow;
}


// ============================================================================
// SCRIPT LOAD
// ============================================================================

function postCreate() {
    trace("[Change_Strum_v3] script loaded.");
}


// ============================================================================
// SCREEN / RAW COORDINATE HELPERS
// ============================================================================
//
// camHUD.downscroll=true 时，HudCamera 会镜像 Y：
//
// shownY = cameraHeight - rawY - objectHeight
//
// 本脚本从不改变 camHUD.downscroll。

function shownYFromRaw(rawY, objectHeight) {
    if (camHUD.downscroll)
        return camHUD.height - rawY - objectHeight;

    return rawY;
}


function rawYFromShown(shownY, objectHeight) {
    if (camHUD.downscroll)
        return camHUD.height - shownY - objectHeight;

    return shownY;
}


// ============================================================================
// NOTE CONFIGURATION
// ============================================================================

function configureNote(note) {
    if (note == null)
        return;

    // 使用统一的绝对坐标定位，避开 sustain 的负滚速额外高度补偿。
    note.strumRelativePos = false;

    // 判定键旋转只影响 receptor 本身。
    note.copyStrumAngle = false;
    note.noteAngle = 0;
    note.angle = 0;

    // Note 自己保持允许更新。
    // 真正禁止 CNE 写 X/Y 的位置在 Strum 上。
    note.updateNotesPosX = true;
    note.updateNotesPosY = true;

    if (note.isSustainNote) {
        // sustain 朝向由本脚本的视觉 flow 控制。
        note.updateFlipY = false;

        var flow =
            flowProxy != null
            ? flowProxy.x
            : getFlowForState(currentOppositeState);

        note.flipY =
            note.flipSustain
            && (flow < 0);
    }
}


function configureAllNotes() {
    // 仅初始化时完整走一次“白名单内”的谱面。
    for (line in controlledLines) {
        if (line == null || line.notes == null)
            continue;

        for (note in line.notes.members) {
            if (note != null && note.exists)
                configureNote(note);
        }
    }
}


function onPostNoteCreation(event) {
    // 不在这里全局修改新 Note。
    // 只有白名单 StrumLine 的 onNoteUpdate 才会把 Note 交给本脚本，
    // 从而保证非白名单轨道完全保持 CNE 原生行为。
}


// ============================================================================
// OPTIMIZED NOTE COLLECTION
// ============================================================================

function handleNoteUpdate(event) {
    if (!initialized || event == null)
        return;

    var note = event.note;
    var strum = event.strum;

    if (note == null || strum == null || !note.exists)
        return;

    // 此回调只挂在白名单 StrumLine 上。
    // 运行中动态创建的 Note 也会在这里获得受控配置。
    configureNote(note);

    activeNotes[activeCount] = note;
    activeStrums[activeCount] = strum;
    activeCount++;
}


// ============================================================================
// NOTE POSITIONING
// ============================================================================

function positionActiveNote(note, strum) {
    if (note == null || strum == null || !note.exists)
        return;

    note.strumRelativePos = false;
    note.copyStrumAngle = false;

    var speed;

    // 与 Strum.getScrollSpeed(note) 相同的优先级。
    if (note.scrollSpeed != null)
        speed = note.scrollSpeed;
    else if (strum.scrollSpeed != null)
        speed = strum.scrollSpeed;
    else
        speed = scrollSpeed;

    // 真正方向只由 flowProxy 控制。
    if (speed < 0)
        speed = -speed;

    var flow =
        flowProxy != null
        ? flowProxy.x
        : getFlowForState(currentOppositeState);

    var distance =
        (note.strumTime - Conductor.songPosition)
        * 0.45
        * speed
        * flow;

    // 判定键在屏幕上的中心点。
    var shownStrumY =
        shownYFromRaw(
            strum.y,
            strum.height
        );

    var shownCenterY =
        shownStrumY
        + (strum.height * 0.5);

    // Downscroll camera 不镜像 X。
    note.x =
        strum.x
        + (strum.width * 0.5)
        - note.origin.x
        + note.offset.x;

    var sustainAnchor = 0.0;

    if (note.isSustainNote) {
        // 连续的 sustain 半高度锚点：
        //
        // flow +1 -> +height/2
        // flow  0 -> 0
        // flow -1 -> -height/2
        //
        // 避免长键主体/尾巴沿铺面流向整体偏移。
        sustainAnchor =
            note.height
            * 0.5
            * flow;

        note.updateFlipY = false;

        note.flipY =
            note.flipSustain
            && (flow < 0);

        note.angle = 0;
    } else {
        note.flipY = false;
        note.angle = 0;
    }

    var wantedShownY =
        shownCenterY
        + distance
        + sustainAnchor
        - note.origin.y
        + note.offset.y;

    note.y =
        rawYFromShown(
            wantedShownY,
            note.height
        );
}


function positionActiveNotes() {
    for (i in 0...activeCount) {
        positionActiveNote(
            activeNotes[i],
            activeStrums[i]
        );

        // 清除本帧引用，数组本身重复利用。
        activeNotes[i] = null;
        activeStrums[i] = null;
    }
}


// ============================================================================
// INITIALIZATION
// ============================================================================

function onStartSong() {
    setupChangeStrum();
}


function setupChangeStrum() {
    if (initialized)
        return;

    trace("[Change_Strum_v3] initializing...");

    // 这里才读取游戏正式开始时的真实设置。
    // 不在更早阶段推测。
    startSettingDownscroll = camHUD.downscroll;

    currentOppositeState = false;
    targetOppositeState = false;

    // 0) 根据文件开头的白名单建立受控轨道。
    buildControlledLines();

    // 1) 只保存白名单轨道中判定键的真实屏幕位置。
    //    不移动它们。
    saveStrumHomeState();

    // 2) 保存开局 UI 的真实布局。
    //    不调用 moveHUD() 重排，不移动任何 UI。
    saveHUDHomeState();

    // 3) HOME 铺面流向严格使用设置中的方向。
    flowProxy = new FlxSprite();
    flowProxy.visible = false;
    flowProxy.x = getHomeFlow();

    // 4) 配置 Note / Strum 的定位管线。
    configureAllNotes();

    for (line in controlledLines) {
        if (line == null)
            continue;

        line.onNoteUpdate.add(handleNoteUpdate);
    }

    initialized = true;

    trace(
        "[Change_Strum_v3] ready. HOME setting = "
        + (startSettingDownscroll ? "Downscroll" : "Upscroll")
    );
}


// ============================================================================
// SAVE EXACT START RECEPTOR STATE
// ============================================================================

function saveStrumHomeState() {
    savedStrums = [];
    strumHomeShownY = [];
    strumOppositeShownY = [];
    strumBaseAngle = [];

    strumMoveTweens = [];
    strumSpinTweens = [];

    for (line in controlledLines) {
        if (line == null)
            continue;

        for (strum in line.members) {
            if (strum == null)
                continue;

            // HOME = 开局此刻屏幕真正显示的位置。
            var homeShownY =
                shownYFromRaw(
                    strum.y,
                    strum.height
                );

            // OPPOSITE = HOME 的精确垂直镜像。
            var oppositeShownY =
                camHUD.height
                - homeShownY
                - strum.height;

            savedStrums.push(strum);
            strumHomeShownY.push(homeShownY);
            strumOppositeShownY.push(oppositeShownY);
            strumBaseAngle.push(strum.angle);

            strumMoveTweens.push(null);
            strumSpinTweens.push(null);

            // 保留 CNE 的 Note 更新管线，只阻止其覆盖最终 X/Y。
            strum.updateNotesPosX = false;
            strum.updateNotesPosY = false;

            strum.copyStrumAngle = false;
            strum.noteAngle = 0;

            // 这里故意不写 strum.y。
            // 所以脚本初始化不会让判定键瞬移。
        }
    }

    trace(
        "[Change_Strum_v3] captured HOME receptors = "
        + savedStrums.length
    );
}


// ============================================================================
// HUD HOME SNAPSHOT
// ============================================================================
//
// 这里不调用 moveHUD()。
// HOME 直接保存游戏开局真实 UI，因此不会出现“开局布局与设置相反”。

function saveHUDHomeState() {
    hudBaseX = dustinHealthBG.x;
    hudHomeRawY = dustinHealthBG.y;

    // 保存 dustinHealthBG 自己在屏幕上的 anchor。
    hudHomeAnchorShownY =
        shownYFromRaw(
            dustinHealthBG.y,
            dustinHealthBG.height
        );

    // 取得 7 个 UI 在屏幕上的真实整体边界。
    hudHomeShownTop = getCurrentHUDShownTop();
    hudHomeShownBottom = getCurrentHUDShownBottom();

    // 整组垂直镜像后的目标边界。
    hudOppositeShownTop =
        camHUD.height
        - hudHomeShownBottom;

    hudOppositeShownBottom =
        camHUD.height
        - hudHomeShownTop;

    // 只做“整组平移”，不反转组内部元素顺序。
    var oppositeShift =
        hudOppositeShownTop
        - hudHomeShownTop;

    hudOppositeAnchorShownY =
        hudHomeAnchorShownY
        + oppositeShift;

    hudOppositeRawY =
        rawYFromShown(
            hudOppositeAnchorShownY,
            dustinHealthBG.height
        );

    // mover 从真实 HOME raw 坐标开始。
    // 不调用 updateHUDGroup()，避免初始化改动 UI。
    hudMover =
        new FlxSprite(
            hudBaseX,
            hudHomeRawY
        );

    hudMover.visible = false;

    trace(
        "[Change_Strum_v3] captured HOME HUD. top="
        + hudHomeShownTop
        + ", bottom="
        + hudHomeShownBottom
    );
}


// ============================================================================
// HUD LAYOUT
// ============================================================================
//
// 仅在真正执行 UI 动画时调用。
// 相对布局严格使用用户提供的实现。

function moveHUD(hudx:Float, hudy:Float) {
    dustinHealthBG.x = hudx;
    dustinHealthBG.y = hudy;

    dustinHealthBar.x =
        hudx + 46;

    dustinHealthBar.y =
        hudy
        + (camHUD.downscroll ? 25 : 32);

    timeBarBG.x =
        hudx + 77;

    timeBarBG.y =
        hudy + 74;

    timeBar.x =
        timeBarBG.x;

    timeBar.y =
        timeBarBG.y;

    scoreTxt.x =
        dustinHealthBG.x + 56;

    scoreTxt.y =
        dustinHealthBG.y + 114;

    missesTxt.x =
        dustinHealthBG.x + 116;

    missesTxt.y =
        dustinHealthBG.y + 114;

    accuracyTxt.x =
        dustinHealthBG.x + 116;

    accuracyTxt.y =
        dustinHealthBG.y + 114;
}


// ============================================================================
// HUD SCREEN BOUNDS
// ============================================================================

function shownTopOf(obj) {
    return shownYFromRaw(
        obj.y,
        obj.height
    );
}


function shownBottomOf(obj) {
    return
        shownYFromRaw(
            obj.y,
            obj.height
        )
        + obj.height;
}


function getCurrentHUDShownTop() {
    var top = shownTopOf(dustinHealthBG);

    top = Math.min(top, shownTopOf(dustinHealthBar));
    top = Math.min(top, shownTopOf(timeBarBG));
    top = Math.min(top, shownTopOf(timeBar));
    top = Math.min(top, shownTopOf(scoreTxt));
    top = Math.min(top, shownTopOf(missesTxt));
    top = Math.min(top, shownTopOf(accuracyTxt));

    return top;
}


function getCurrentHUDShownBottom() {
    var bottom = shownBottomOf(dustinHealthBG);

    bottom = Math.max(bottom, shownBottomOf(dustinHealthBar));
    bottom = Math.max(bottom, shownBottomOf(timeBarBG));
    bottom = Math.max(bottom, shownBottomOf(timeBar));
    bottom = Math.max(bottom, shownBottomOf(scoreTxt));
    bottom = Math.max(bottom, shownBottomOf(missesTxt));
    bottom = Math.max(bottom, shownBottomOf(accuracyTxt));

    return bottom;
}


// ============================================================================
// PUBLIC FUNCTIONS
// ============================================================================

// 切换到“与游戏开始设置相反”的状态。
function goDownScroll() {
    requestScrollState(true);
}


// 恢复到“与游戏开始设置相同”的 HOME 状态。
function goUpScroll() {
    requestScrollState(false);
}


// ============================================================================
// REQUEST LOGIC
// ============================================================================
//
// 规则：
//
// A) 当前稳定在目标状态，再次调用相同函数：
//    -> 只旋转判定键 360°。
//    -> 铺面流向、判定键位置、UI 全部不动。
//
// B) 正在切向某目标，又重复调用相同函数：
//    -> 原有布局/流向动画继续。
//    -> 新调用只让判定键重新旋转 360°。
//
// C) 正在切换时调用另一个不同函数：
//    -> 立刻取消旧布局切换。
//    -> 从当前动画已经进行到的位置直接转向最新目标。

function requestScrollState(opposite) {
    if (!initialized) {
        trace(
            "[Change_Strum_v3] function call ignored before onStartSong."
        );

        return;
    }

    // 正在切换。
    if (switching) {
        // 和“最新目标”相同 = 重复相同函数。
        if (targetOppositeState == opposite) {
            spinStrumsOnly();

            trace(
                "[Change_Strum_v3] repeated same target -> spin only."
            );

            return;
        }

        // 不同目标：打断上一轮，最新调用立即接管。
        interruptCurrentTransition();

        startStateTransition(
            opposite
        );

        return;
    }

    // 已经稳定在这个状态 = 重复相同函数。
    if (currentOppositeState == opposite) {
        spinStrumsOnly();

        trace(
            "[Change_Strum_v3] repeated current state -> spin only."
        );

        return;
    }

    // 正常切换到另一个状态。
    startStateTransition(
        opposite
    );
}


// ============================================================================
// INTERRUPT CURRENT TRANSITION
// ============================================================================

function interruptCurrentTransition() {
    // 取消旧完成 Timer，避免旧回调之后篡改状态。
    if (transitionTimer != null) {
        transitionTimer.cancel();
        transitionTimer = null;
    }

    // Note flow 从“此刻已有值”停止。
    if (flowProxy != null)
        FlxTween.cancelTweensOf(flowProxy);

    // HUD 停在当前动画位置。
    if (hudTween != null) {
        hudTween.cancel();
        hudTween = null;
    }

    FlxTween.cancelTweensOf(hudMover);

    // 判定键停在当前 Y / 当前角度。
    for (i in 0...savedStrums.length) {
        cancelMoveTween(i);
        cancelSpinTween(i);
    }

    hudMoving = false;
    switching = false;

    trace(
        "[Change_Strum_v3] previous transition interrupted."
    );
}


// ============================================================================
// START LAYOUT TRANSITION
// ============================================================================

function startStateTransition(opposite) {
    switching = true;
    targetOppositeState = opposite;

    trace(
        "[Change_Strum_v3] latest target -> "
        + (opposite ? "OPPOSITE" : "HOME")
    );

    // 判定键位置。
    for (i in 0...savedStrums.length) {
        tweenStrumMoveToState(
            i,
            opposite
        );
    }

    // 每次实际布局切换也旋转一圈。
    spinStrumsOnly();

    // 铺面流向：从当前 flow 值直接转向最新目标。
    FlxTween.cancelTweensOf(flowProxy);

    FlxTween.tween(
        flowProxy,
        {
            x:
                getFlowForState(
                    opposite
                )
        },
        NOTE_FLOW_TIME,
        {
            ease:
                FlxEase.sineInOut
        }
    );

    // UI：从当前所在位置响应最新目标。
    tweenHUDToState(
        opposite
    );

    // 只让最新 Timer 有资格提交最终状态。
    transitionTimer =
        new FlxTimer().start(
            Math.max(
                STRUM_MOVE_TIME,
                Math.max(
                    NOTE_FLOW_TIME,
                    HUD_OUT_TIME + HUD_IN_TIME
                )
            ) + 0.06,
            function(tmr) {
                // 如果 Timer 已被新调用替换，这个回调不会再执行。
                currentOppositeState =
                    targetOppositeState;

                flowProxy.x =
                    getFlowForState(
                        currentOppositeState
                    );

                switching = false;
                transitionTimer = null;

                trace(
                    "[Change_Strum_v3] latest transition complete -> "
                    + (
                        currentOppositeState
                        ? "OPPOSITE"
                        : "HOME"
                    )
                );
            }
        );
}


// ============================================================================
// STRUM MOVE
// ============================================================================

function cancelMoveTween(index) {
    if (
        index >= 0
        && index < strumMoveTweens.length
        && strumMoveTweens[index] != null
    ) {
        strumMoveTweens[index].cancel();
        strumMoveTweens[index] = null;
    }
}


function tweenStrumMoveToState(index, opposite) {
    var strum =
        savedStrums[index];

    if (strum == null)
        return;

    cancelMoveTween(index);

    strum.updateNotesPosX = false;
    strum.updateNotesPosY = false;

    strum.copyStrumAngle = false;
    strum.noteAngle = 0;

    var targetShownY =
        opposite
        ? strumOppositeShownY[index]
        : strumHomeShownY[index];

    var targetRawY =
        rawYFromShown(
            targetShownY,
            strum.height
        );

    strumMoveTweens[index] =
        FlxTween.tween(
            strum,
            {
                y:
                    targetRawY
            },
            STRUM_MOVE_TIME,
            {
                ease:
                    FlxEase.sineInOut,

                onComplete:
                    function(twn) {
                        strum.y =
                            targetRawY;

                        strumMoveTweens[index] =
                            null;
                    }
            }
        );
}


// ============================================================================
// STRUM SPIN ONLY
// ============================================================================
//
// 这个函数只改 angle。
// 不碰：
//   strum.y
//   flowProxy
//   HUD
//   currentOppositeState
//   targetOppositeState

function cancelSpinTween(index) {
    if (
        index >= 0
        && index < strumSpinTweens.length
        && strumSpinTweens[index] != null
    ) {
        strumSpinTweens[index].cancel();
        strumSpinTweens[index] = null;
    }
}


function spinStrumsOnly() {
    for (i in 0...savedStrums.length) {
        var strum =
            savedStrums[i];

        if (strum == null)
            continue;

        cancelSpinTween(i);

        var spinStart =
            strum.angle;

        var spinTarget =
            spinStart
            + STRUM_SPIN_DEGREES;

        strumSpinTweens[i] =
            FlxTween.tween(
                strum,
                {
                    angle:
                        spinTarget
                },
                STRUM_SPIN_TIME,
                {
                    ease:
                        FlxEase.sineInOut,

                    onComplete:
                        function(twn) {
                            // 完整 360° 后视觉与基础角度完全等价。
                            // 归一化数字，避免 360/720/1080 无限累积。
                            strum.angle =
                                strumBaseAngle[i];

                            strumSpinTweens[i] =
                                null;
                        }
                }
            );
    }
}


// ============================================================================
// HUD TARGET HELPERS
// ============================================================================

function getHUDTargetRawY(opposite) {
    return opposite
        ? hudOppositeRawY
        : hudHomeRawY;
}


function getHUDTargetAnchorShownY(opposite) {
    return opposite
        ? hudOppositeAnchorShownY
        : hudHomeAnchorShownY;
}


function getHUDTargetShownTop(opposite) {
    return opposite
        ? hudOppositeShownTop
        : hudHomeShownTop;
}


function getHUDTargetShownBottom(opposite) {
    return opposite
        ? hudOppositeShownBottom
        : hudHomeShownBottom;
}


// ============================================================================
// HUD MOVEMENT
// ============================================================================

function updateHUDGroup() {
    if (hudMover == null)
        return;

    moveHUD(
        hudBaseX,
        hudMover.y
    );
}


// Convert a desired dustinHealthBG SCREEN anchor back to RAW anchor.
function hudRawYFromAnchorShown(anchorShownY) {
    return rawYFromShown(
        anchorShownY,
        dustinHealthBG.height
    );
}


// Start/restart HUD animation toward the latest target.
//
// If a different function interrupts:
// - current HUD position is preserved
// - old tween is cancelled
// - this function starts from that exact current position

function tweenHUDToState(opposite) {
    if (hudMover == null)
        return;

    if (hudTween != null) {
        hudTween.cancel();
        hudTween = null;
    }

    FlxTween.cancelTweensOf(hudMover);

    hudMoving = true;

    // Ensure real UI matches mover before measuring bounds.
    updateHUDGroup();

    var currentTop =
        getCurrentHUDShownTop();

    var currentBottom =
        getCurrentHUDShownBottom();

    var currentAnchorShown =
        shownYFromRaw(
            hudMover.y,
            dustinHealthBG.height
        );

    var targetAnchorShown =
        getHUDTargetAnchorShownY(
            opposite
        );

    var targetTop =
        getHUDTargetShownTop(
            opposite
        );

    var targetBottom =
        getHUDTargetShownBottom(
            opposite
        );

    // 如果当前已经完全离屏，就不用再做一次 exit。
    var currentlyOutside =
        currentBottom < 0
        || currentTop > camHUD.height;

    if (currentlyOutside) {
        startHUDEnterFromTargetSide(
            opposite,
            targetAnchorShown,
            targetTop,
            targetBottom
        );

        return;
    }

    // 从“当前真正位置”选择最近屏幕边缘。
    var currentCenter =
        (currentTop + currentBottom)
        * 0.5;

    var exitTop =
        currentCenter
        < (camHUD.height * 0.5);

    var outAnchorShown;

    if (exitTop) {
        // 整组 bottom 最终刚好位于 -padding。
        var shift =
            -HUD_OFFSCREEN_PADDING
            - currentBottom;

        outAnchorShown =
            currentAnchorShown
            + shift;
    } else {
        // 整组 top 最终刚好位于 H+padding。
        var shift =
            camHUD.height
            + HUD_OFFSCREEN_PADDING
            - currentTop;

        outAnchorShown =
            currentAnchorShown
            + shift;
    }

    var outRawY =
        hudRawYFromAnchorShown(
            outAnchorShown
        );

    hudTween =
        FlxTween.tween(
            hudMover,
            {
                y:
                    outRawY
            },
            HUD_OUT_TIME,
            {
                ease:
                    FlxEase.quadIn,

                onComplete:
                    function(twn) {
                        hudTween = null;

                        startHUDEnterFromTargetSide(
                            opposite,
                            targetAnchorShown,
                            targetTop,
                            targetBottom
                        );
                    }
            }
        );
}


// HUD 已经离屏后：
// 瞬移到目标那一侧的屏幕外，再平滑进入。
function startHUDEnterFromTargetSide(
    opposite,
    targetAnchorShown,
    targetTop,
    targetBottom
) {
    if (hudMover == null)
        return;

    var targetCenter =
        (targetTop + targetBottom)
        * 0.5;

    var targetOnTop =
        targetCenter
        < (camHUD.height * 0.5);

    var enterAnchorShown;

    if (targetOnTop) {
        // 目标在顶部 -> 从顶部外进入。
        var shift =
            -HUD_OFFSCREEN_PADDING
            - targetBottom;

        enterAnchorShown =
            targetAnchorShown
            + shift;
    } else {
        // 目标在底部 -> 从底部外进入。
        var shift =
            camHUD.height
            + HUD_OFFSCREEN_PADDING
            - targetTop;

        enterAnchorShown =
            targetAnchorShown
            + shift;
    }

    // 离屏状态下瞬移。
    hudMover.y =
        hudRawYFromAnchorShown(
            enterAnchorShown
        );

    updateHUDGroup();

    var targetRawY =
        getHUDTargetRawY(
            opposite
        );

    hudTween =
        FlxTween.tween(
            hudMover,
            {
                y:
                    targetRawY
            },
            HUD_IN_TIME,
            {
                ease:
                    FlxEase.quadOut,

                onComplete:
                    function(twn) {
                        hudMover.y =
                            targetRawY;

                        updateHUDGroup();

                        hudTween = null;
                        hudMoving = false;
                    }
            }
        );
}


// ============================================================================
// FRAME UPDATE
// ============================================================================
//
// 没有 10 秒定时切换。
// update() 只负责清空当前帧 Note buffer。

function update(elapsed) {
    if (!initialized)
        return;

    activeCount = 0;
}


function postUpdate(elapsed) {
    if (!initialized)
        return;

    // 只定位 CNE 本帧真正更新到的 Note。
    positionActiveNotes();

    if (hudMoving)
        updateHUDGroup();
}


// ============================================================================
// CLEANUP
// ============================================================================

function destroy() {
    // 断开 Note 信号。
    for (line in controlledLines) {
        if (line != null) {
            line.onNoteUpdate.remove(
                handleNoteUpdate
            );
        }
    }

    if (transitionTimer != null) {
        transitionTimer.cancel();
        transitionTimer = null;
    }

    if (flowProxy != null) {
        FlxTween.cancelTweensOf(
            flowProxy
        );

        flowProxy.destroy();
        flowProxy = null;
    }

    if (hudTween != null) {
        hudTween.cancel();
        hudTween = null;
    }

    if (hudMover != null) {
        FlxTween.cancelTweensOf(
            hudMover
        );

        hudMover.destroy();
        hudMover = null;
    }

    for (i in 0...savedStrums.length) {
        cancelMoveTween(i);
        cancelSpinTween(i);
    }

    controlledLines = [];
    controlledLineIndexes = [];

    savedStrums = [];

    strumHomeShownY = [];
    strumOppositeShownY = [];
    strumBaseAngle = [];

    strumMoveTweens = [];
    strumSpinTweens = [];

    activeNotes = [];
    activeStrums = [];
    activeCount = 0;
}
