// imports
import flixel.text.FlxText.FlxTextFormat;
import funkin.savedata.FunkinSave;
import openfl.geom.Rectangle;
import StringTools;
importScript("data/scripts/DialogueBoxBG");
importScript("data/scripts/FunkinTypeText");

// "there must be a better way to do this!" ahh
var dialogue = [
    // - 介绍对话 -
    "beforeStoryMode" => [
        ["欢迎。", "talk"],
        ["请勿急躁。", "talk"],
        ["时机终会到来。", "focus"],
        ["在此之前，\n请先享受我准备的容器吧。", "surprised"]
    ],
    "afterStoryMode" => [
        ["有趣。\n十分有趣。", "talk"],
        ["你在寻找更多，\n不是吗？", "focus"],
        ["当然。当然。", "surprised"],
        ["那么，我还能向你\n展示更多。\n我在此的发现。", "talk"],
        ["我确信我的发现\n将证明这\n非常非常有趣。", "talk"]
    ],
    "bothEndings" => [
        ["有趣，非常有趣。", "talk"],
        ["好奇心\n还将驱使你走多远？", "surprised"],
        ["你还会\n陷入多深？", "focus"]
    ],
    "boughtItAll" => [
        ["现在。", "talk"],
        ["我已无物可提供给你。", "talk"],
        ["就先好好享受我的容器吧。", "laugh"],
        ["我会在黑暗中视奸你。", "focus"]
    ],
    // - 钥匙对话 -
    "mirror key" => [
        ["通往不同世界的钥匙。", "talk"],
        ["有着不同的容器在等着你。", "focus"],
        ["你希望获取此物品吗？", "talk"]
    ],
    "wrath key" => [
        ["通往地狱最深处的钥匙。", "talk"],
        ["那里只有痛苦等待着你。", "surprised"],
        ["你希望获取此物品吗？", "talk"]
    ],
    "guilty key" => [
        ["导致时间线分叉的错误。", "talk"],
        ["有些事情只会变得更糟。", "focus"],
        ["你希望获取此物品吗？", "talk"]
    ],
    "virus key" => [
        ["一个有趣的对象。\n似乎能从内部破坏时间线。", "talk"],
        ["或许你会觉得Ta的容器\n很熟悉？", "focus"],
        ["你希望获取此物品吗？", "talk"]
    ],

    "inopia" => [
        ["它来自未来数年的时间线。", "talk"],
        ["其破损状态不代表其功能性。", "focus"],
        ["你希望获取此物品吗？", "talk"]
    ],
    "yolo" => [
        ["它曾在多元宇宙的中心。", "talk"],
        ["状态依然相当完好。", "focus"],
        ["你希望获取此物品吗？", "talk"]
    ],
    "genocides" => [
        ["收下。", "goofy"]
    ],
    "uncreate" => [
        ["多元宇宙历史的又一碎片。", "talk"],
        ["墨水尚未干涸。", "focus"],
        ["你希望获取此物品吗？", "talk"]
    ],
    "psychopath" => [
        ["有些实体说这事件永不可能发生。", "focus"],
        ["但多元宇宙无限\n且有无尽可能", "surprised"],
        ["你希望获取此物品吗？", "talk"]
    ],
    "bargain" => [
        ["我个人最爱的宇宙", "talk"],
        ["会想起某段回忆。", "focus"],
        ["你希望获取此物品吗？", "talk"]
    ],
    "vindication" => [
        ["最难寻觅的光盘。", "talk"],
        ["一个实体离开自身宇宙\n进入其他宇宙的结果。", "focus"],
        ["你希望获取此物品吗？", "talk"]
    ],
    // - 其他对话 -
    "buySuccess" => [
        ["感谢惠顾。", "surprised"]
    ],
    "buyCancel" => [
        ["这是你的选择。", "focus"]
    ],
    "buyFail" => [
        ["看来你的EXP还不足。", "focus"],
        ["别担心，\n我会为你先保留这件物品。", "scary"]
    ]
];
static var shopMusicStarted:Bool = false;
// bg stuff
var bg:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/shop/background_gaster"));
var gaster:FunkinSprite = new FunkinSprite(650, 85, Paths.image("menus/shop/gaster"));
// shop stuff
var kms:Array<String> = ["* 钥匙", "镜之钥", "怒之钥", "孽之钥", "侵之钥", "* 光盘", "破损光盘", "酷拽光盘", "神秘光盘", "艺术光盘", "疯癫光盘", "购物光盘", "腐败光盘"];
var heart:FunkinSprite = new FunkinSprite(80, 0, Paths.image("game/heart"));
var items:Array<FunkinText> = [];
var yesno:Array<FunkinText> = [new FunkinText(595, 575 + (43 / 2), 0, "是", 40, false), new FunkinText(1095, 575 + (43 / 2), 0, "否", 40, false)];
var curItem:Int = 0;
var curYesno:Int = 0;
// dialogue
var dialogueTxtObj:FunkinTypeText = newFunkinTypeText(540, 490, 670, "hawk tuah", 40);
var dialogueTxt:FunkinTypeText = dialogueTxtObj.flxtext;
var dialogues:Array<Array<String>>;
var dialogueEnded:Bool = false;
var curDialogue:Int = 0;
// stuff that changes visually idk
var itemKeys:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/shop/keys"));
var itemCD:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/shop/cds"));
var cost:FunkinText = new FunkinText(0, 0, 175, "价格：\n？？？", 40, false);
var money:FunkinText = new FunkinText(0, 0, 0, "经验值[EXP]：" + FlxG.save.data.dustinCash, 40, false);

var itemmap = [
    "* 钥匙" => ["* keys"],
    "* 光盘" => ["* cds"],

    "镜之钥" => ["mirror key", 2000],
    "怒之钥" => ["wrath key", 1500],
    "孽之钥" => ["guilty key", 2000],
    "侵之钥" => ["virus key", 1500],

    "破损光盘" => ["inopia", 700],
    "酷拽光盘" => ["yolo", 400],
    "神秘光盘" => ["genocides", 0],
    "艺术光盘" => ["uncreate", 400],
    "疯癫光盘" => ["psychopath", 700],
    "购物光盘" => ["bargain", 300],
    "腐败光盘" => ["vindication", 1000]
];

var bgbox;

function create() {
    itemKeys.visible = itemCD.visible = !FlxG.save.data.dustinBeatEverything;
    dialogues = dialogue[FlxG.save.data.dustinBeatEverything ? "boughtItAll" : (FunkinSave.getWeekHighscore("dusttale-1", "hard").date != null ? "afterStoryMode" : "beforeStoryMode")];

    if (!shopMusicStarted) {
        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.music("gaster_shop"), 0.7, true);
        shopMusicStarted = true;
    }
    // bg stuff
    add(bg).screenCenter();
    if (Options.gameplayShaders && FlxG.save.data.water) {
        bg.shader = new CustomShader("waterDistortion");
        bg.shader.strength = 0.5;
    }

    for (a in ["idle", "talk", "focus", "scary", "goofy", "surprised"])
        gaster.addAnim(a, a, 12, true);
    add(gaster).playAnim("idle");

    bg.scrollFactor.set();
    bg.antialiasing = gaster.antialiasing = Options.antialiasing;
    // box stuff

    add(newDialogueBoxBG(515, 470, null, 700, 210, 5)).pixels.fillRect(new Rectangle(5, 5, 690, 200), 0xFF000000); // text box
    add(bgbox = newDialogueBoxBG(65, 40, null, 400, 640, 5)).pixels.fillRect(new Rectangle(5, 5, 390, 640), 0xFF000000); // options box
    add(newDialogueBoxBG(1040, 60, null, 175, 175, 5)).pixels.fillRect(new Rectangle(5, 5, 785, 460), 0xFF000000); // item box
    // shop stuff
    var why:Int = 0;
    for (a in 0...kms.length)
        if (!FlxG.save.data.dustinBoughtStuff.contains(itemmap[kms[a].toLowerCase()][0])) { // conditional if bought
            if (!StringTools.startsWith(kms[a], "*")) (StringTools.endsWith(kms[a], "光盘") ? itemCD : itemKeys).addAnim(kms[a].toLowerCase(), itemmap[kms[a].toLowerCase()][0], 1, false);
            why += (StringTools.startsWith(kms[a], "*") ? 58 : 46);
            var txt:FunkinText = new FunkinText(110, why, 0, kms[a], 40, false);
            if (StringTools.startsWith(kms[a], "*")) txt.alpha = 0.5;
            items.push(txt);
            add(txt).font = Paths.font("8bit-jve.ttf");
            textCrispy(txt);
        }
    kms.remove("* 钥匙");
    kms.remove("* 光盘");
        
    for (a in yesno) {
        add(a).font = Paths.font("8bit-jve.ttf");
        a.visible = false;
    }

    if (items[0] != null) {
        heart.scale.set(24/1024, 24/1024);
        add(heart).updateHitbox();
        heart.alpha = 0;
        heart.setPosition(80, items[0]?.y + (items[0]?.height - heart.height) / 2);
    }

    add(itemKeys).setPosition(1040 + 175 / 2 - itemKeys.width / 2, 60 + 175 / 2 - itemKeys.height / 2);
    add(itemCD).setPosition(1040 + 175 / 2 - itemCD.width / 2 - 30, 60 + 175 / 2 - itemCD.height / 2 - 5);
    itemCD.origin.x += 25;
    itemCD.origin.y += 5;
    itemKeys.scale.set(0.875, 0.875);
    itemCD.scale.set(0.5, 0.5);
    itemKeys.antialiasing = itemCD.antialiasing = Options.antialiasing;

    cost.font = money.font = Paths.font("8bit-jve.ttf");
    money.antialiasing = false;
    textCrispy(cost); textCrispy(money);
    add(cost).setPosition(1040, 235);
    cost.alignment = "center";
    add(money).setPosition(Math.floor(1215 - money.width), Math.floor(466 - money.height));

    cost.textField.antiAliasType = 0/*ADVANCED*/;
	cost.textField.sharpness = 400/*MAX ON OPENFL*/;

    money.textField.antiAliasType = 0/*ADVANCED*/;
	money.textField.sharpness = 400/*MAX ON OPENFL*/;

    add(dialogueTxt).setFormat(Paths.font("8bit-jve.ttf"), 40);
    dialogueTxt.letterSpacing = 8.0;
    dialogueTxtObj.resetText(" ", dialogueTxtObj);
    yap(dialogues[0]);

    updateItemList();
    changeSel(0);

    for (a in items) a.alpha = 0;
    bgbox.alpha = 0;

    FlxG.camera.scroll.x = 220;
    camOFFX = 220;
    leftAlpha = 0;
}

var camOFFX:Float = 220;
var leftAlpha:Float = 0;
var prevText:String;
var time:Float = FlxG.random.float(100, 1000);
function update(elapsed:Float) {
    updateFunkinTypeText(elapsed, dialogueTxtObj);

    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, camOFFX, 0.03); 
    if (Options.gameplayShaders && FlxG.save.data.water) bg.shader?.time = time += elapsed;

    for (a in items)
        a.alpha = FlxMath.lerp(a.alpha, StringTools.startsWith(a.text, "*") ? leftAlpha / 2 : leftAlpha, 0.03);
    bgbox.alpha = FlxMath.lerp(bgbox.alpha, leftAlpha, 0.03);

    if (dialogues[curDialogue] != null && (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X))
        if (dialogueEnded) yap(dialogues[curDialogue]); else dialogueTxtObj.skip(dialogueTxtObj);

     if (controls.ACCEPT || FlxG.keys.justPressed.Z) {
        if (dialogues[curDialogue] != null)
            if (dialogueEnded) yap(dialogues[curDialogue]); else dialogueTxtObj.skip(dialogueTxtObj);
        else if (!["", "你希望获取此物品吗？", "收下。"].contains(dialogueTxt.text)) {
            FlxG.sound.play(Paths.sound("menu/select"));
            if (dialogueTxt.text == "我会在黑暗中视奸你。") FlxTween.tween(gaster, {alpha: 0}, 1);
            if (dialogueTxt.text == "在此之前，\n请先享受我准备的容器吧。") exit();
            dialogueTxt.text = ["我会在黑暗中视奸你。", " "].contains(dialogueTxt.text) ? " " : "";
            dialogues = [];
            gaster.playAnim("idle", !(yesno[0].visible = yesno[1].visible = false));
            changeSel(0);
        } else if (gaster.getAnimName() == "idle" && dialogueTxt.text == "") {
            camOFFX = 220;
            leftAlpha = 1;
            var itemKey = itemmap[items[curItem].text.toLowerCase()][0];
            dialogues = dialogue[itemKey] != null ? dialogue[itemKey] : [["你希望获取此物品吗？", "talk"]];
            yap(dialogues[curDialogue = 0]);
        } else if (["收下。", "你希望获取此物品吗？"].contains(dialogueTxt.text)) {
            FlxG.sound.play(Paths.sound("menu/select"));
            var hawktuah:String = curYesno == 0 ? (FlxG.save.data.dustinCash - itemmap[items[curItem].text.toLowerCase()][1] >= 0? "buySuccess" : "buyFail") : "buyCancel";
            dialogues = dialogue[hawktuah];
            if (hawktuah == "buySuccess") {
                FlxG.save.data.dustinCash -= itemmap[items[curItem].text.toLowerCase()][1];
                money.text = "经验值[EXP]：" + FlxG.save.data.dustinCash;
                money.setPosition(Math.floor(1215 - money.width), Math.floor(470 - money.height));
                if (!FlxG.save.data.dustinBoughtStuff.contains(itemmap[items[curItem].text.toLowerCase()][0])) FlxG.save.data.dustinBoughtStuff.push(itemmap[items[curItem].text.toLowerCase()][0]);
                updateItemList();
                if (hasItAll()) {
                    dialogues = dialogue["boughtItAll"];
                    yap(dialogues[curDialogue = 0]);
                }
            }
            yap(dialogues[curDialogue = 0]);
            changeSel(0);
        }
    }

    if (prevText != dialogueTxt.text) {
        if (dialogueTxt.text != "" && !StringTools.endsWith(dialogueTxt.text, " ") && !StringTools.endsWith(dialogueTxt.text, "\n")) FlxG.sound.play(Paths.sound("wing_oggster/snd_wngdng" + FlxG.random.int(1, 7)), 0.7);
        prevText = dialogueTxt.text;
    }

    if ((controls.UP_P || controls.DOWN_P) && dialogueTxt.text == "")
        changeSel(controls.UP_P ? -1 : 1);

    if ((controls.LEFT_P || controls.RIGHT_P) && ["收下。", "你希望获取此物品吗？"].contains(dialogueTxt.text))
        changeYesno(controls.LEFT_P ? -1 : 1);

    if (controls.BACK)
        exit();
}

function exit() {
    if (FlxG.sound.music != null) FlxG.sound.music.stop();
        FlxG.sound.music = null;

    shopMusicStarted = false;
    FlxG.switchState(new ModState("NewMainMenu"));
}

function changeSel(_:Int, ?hello:Bool = true) {
    camOFFX = 0;
    leftAlpha = 1;
    curItem = FlxMath.wrap(curItem + _, 0, items.length - 1);

    if (items[curItem] != null) {
        if (hasItAll()) return;
        if (StringTools.startsWith(items[curItem].text, "*") || !items[curItem].visible) {
            changeSel(_ == 0 ? 1 : _, false);
            return;
        }
        if (_ != 0 && !hello) CoolUtil.playMenuSFX();
        if (items[curItem].visible) {
            itemKeys.visible = !(itemCD.visible = StringTools.endsWith(items[curItem].text, "光盘"));
            (itemKeys.visible ? itemKeys : itemCD).playAnim(items[curItem].text.toLowerCase());
            cost.text = "价格：\n" + itemmap[items[curItem].text.toLowerCase()][1];

            FlxTween.cancelTweensOf(heart);
            FlxTween.tween(heart, {x: 80, y: items[curItem].y + (items[curItem].height - heart.height) / 2, alpha: 1}, 0.25, {ease: FlxEase.backOut});
            for (a in 0...items.length) items[a].color = curItem == a ? FlxColor.YELLOW : FlxColor.WHITE;
        }
    }
}

function changeYesno(_:Int) {
	if (_ != 0) CoolUtil.playMenuSFX();
    curYesno = FlxMath.wrap(curYesno + _, 0, yesno.length - 1);
    FlxTween.cancelTweensOf(heart);

    FlxTween.tween(heart, {x: Std.int(yesno[curYesno].x - 25 - heart.width / 2), y: yesno[curYesno].y + (yesno[curYesno].height - heart.height) / 2}, 0.25, {ease: FlxEase.backOut});
    for (a in 0...yesno.length) yesno[a].color = curYesno == a ? FlxColor.YELLOW : FlxColor.WHITE;
}

function yap(_:Array<String>) {
    yesno[0].visible = yesno[1].visible = ["收下。", "你希望获取此物品吗？"].contains(_[0]);
    if (["收下。", "你希望获取此物品吗？"].contains(_[0])) changeYesno(curYesno = 0);

    dialogueEnded = false;
    gaster.playAnim(_[1], true);

    dialogueTxtObj.resetText(_[0], dialogueTxtObj);
    dialogueTxtObj.start(0.08, dialogueTxtObj);
    dialogueTxtObj.completeCallback = () -> {
        dialogueEnded = true;
        curDialogue++;
    };
}

function updateItemList() {
    var why:Int = 0;
    for (a in items) {
        if (FlxG.save.data.dustinBoughtStuff.contains(itemmap[a.text.toLowerCase()][0])) {
            a.visible = false;
        } else {
            why += (StringTools.startsWith(a.text.toLowerCase(), "*") ? 58 : 46);
            a.y = why;
        }
    }
}

function hasItAll():Bool {
    for (a in kms)
        if(!FlxG.save.data.dustinBoughtStuff.contains(itemmap[a.toLowerCase()][0]))
            return false;
    cost.text = "价格：\n？？？";
    return FlxG.save.data.dustinBeatEverything = !(heart.visible = itemKeys.visible = itemCD.visible = false);
}

function textCrispy(target_text) {
    target_text.textField.antiAliasType = 0/*ADVANCED*/;
    target_text.textField.sharpness = 400/*MAX ON OPENFL*/;
}