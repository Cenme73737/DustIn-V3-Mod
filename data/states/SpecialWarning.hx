import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import funkin.backend.utils.FlxInterpolateColor;

var text:FlxText;
var confirmText:FunkinText;
var holdCircle:FlxSprite;
var skipColor:FlxInterpolateColor = new FlxInterpolateColor(0xffffffff);
var alphaTween:FlxTween;
var alphaTimer:Float = 0.0;
var holdTime:Float = 0.0;
var ratio:Float = 0.0;
var headerImage:FunkinSprite;
var baseTextX:Float = 0;
var baseTextY:Float = 0;
var jitterTimer:Float = 0.0;
var jitterInterval:Float = 0.07; // seconds between jitter updates
var jitterStrength:Float = 1.5; // pixel offset
var imgsize:Float = 0.2; // image size ratio

function create() {
	text = new FlxText(0, FlxG.height * 0.5, FlxG.width, "警告:\n此修改版由可恶的360制作\n由于项目已停止制作,此版本已废弃(或者说停止支持)\n所以有任何BUG和问题本人概不负责\n若发现HUD不显示等问题请先检查设置(最好都确认一下)\n若设置没有描述则调整decf设置即可\n---存档的版本1.2.4-Preview---");
	text.setFormat(Paths.font("8bit-jve.ttf"), 30, 0xFFFFFF00, "center", FlxTextBorderStyle.OUTLINE, 0xff000000);
	text.textField.antiAliasType = 0;
	text.textField.sharpness = 400;
	add(text);

	// cache base pos for lightweight jitter
	baseTextX = text.x;
	baseTextY = text.y;

	// 头图：居中并放在文字上方
	headerImage = new FunkinSprite().loadGraphic(Paths.image("menus/main/logo-og"));
	headerImage.antialiasing = Options.antialiasing;
	headerImage.scale.set(imgsize, imgsize); // 缩小为 60%
	headerImage.updateHitbox();
	headerImage.screenCenter();
	headerImage.y = text.y - headerImage.height - 20;
	add(headerImage);

	confirmText = new FunkinText(-28, FlxG.height - 50 - 6, FlxG.width, "按住 回车/空格/鼠标左 键以继续...").setFormat(Paths.font('8bit-jve.ttf'), 28, 0xffffffff, "right", FlxTextBorderStyle.OUTLINE, 0xff000000);
	confirmText.textField.antiAliasType = 0;
	confirmText.textField.sharpness = 400;
	confirmText.scrollFactor.set();
	confirmText.borderSize = 3;
	add(confirmText);

	holdCircle = new FlxSprite();
	holdCircle.frames = Paths.getFrames(Paths.image("menus/holdCircle"), true);
	holdCircle.animation.addByPrefix("idle", "hold", ratio = ((holdCircle.frames.frames.length - 1) / 2), false);
	holdCircle.animation.frameIndex = 0;
	holdCircle.setGraphicSize(33 * (FlxG.width / 1280), 33 * (FlxG.width / 1280));
	holdCircle.updateHitbox();
	holdCircle.setPosition(FlxG.width - holdCircle.width - confirmText.textField.textWidth - 40 - 8, FlxG.height - holdCircle.height - 10 - 10);
	add(holdCircle);

	ratio /= 360; // for color lerp like in视频脚本
}

function update(elapsed:Float) {
	// 长按确认逻辑（与 skippableVideoUndertale 同步：Enter / Space / 鼠标左键）
	if (!FlxG.mouse.pressed && !FlxG.keys.pressed.ENTER && !FlxG.keys.pressed.SPACE) {
		holdTime = 0;
		holdCircle.animation.stop();
		holdCircle.animation.frameIndex = 0;

		skipColor.color = 0xffffffff;

		if (alphaTimer > 1) doAlphaTween();
		else alphaTimer += elapsed;
	} else {
		alphaTween?.cancel();
		confirmText.alpha = 1;
		alphaTimer = 0;
		holdCircle.animation.play("idle", false, false, 1);

		confirmText.color = skipColor.fpsLerpTo(0xffff0000, ratio);

		if ((holdTime += elapsed) > 2) {
			onConfirm();
		}
	}

	holdCircle.color = confirmText.color = skipColor.color;
	holdCircle.alpha = confirmText.alpha;
}

function doAlphaTween() {
	alphaTween?.cancel();
	alphaTween = FlxTween.tween(confirmText, {alpha: 0}, 0.5);
}

function onConfirm() {
	FlxG.sound.play(Paths.sound("menu/select"), 0.9);
	// 确认后跳转到主菜单（根据项目中其他地方使用的主菜单为 NewMainMenu）
	FlxG.switchState(new ModState("NewMainMenu"));
	
}