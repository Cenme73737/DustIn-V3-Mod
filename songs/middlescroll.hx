//原属于absorbent v2 but Plana and Arona sing的cne那个版本的文件因为有中间式所以搬过来了，这部分由LSVoiid修改
//LSVoiid：你问我为啥不把middlescroll的代码单独搬出来，那是因为怕出问题，别问我怎么知道（
import flixel.ui.FlxBarFillDirection;
import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBar;
import funkin.game.HudCamera;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;
// import funkin.backend.utils.NativeAPI;

public var camUI:HudCamera;
public var bars = [];

var lyrics:FlxText;
var lyricsBG:FlxSprite;

var healthBarOffsetY = 0;
var healthBarPercent:Float;

var scoreGroup:FlxGroup;

function create() {
	for (i in [1, 2]) {
		var obj:FlxSprite = new FlxSprite().makeSolid(FlxG.width, Std.int(FlxG.height / 5)*2, 0xFF000000);
		obj.scrollFactor.set();
		obj.cameras = [camHUD];
		obj.y = i==2?FlxG.height:-obj.height;
		insert(0, obj);
		bars[i-1] = obj;
		
    camUI = new HudCamera();
	    camUI.bgColor = FlxColor.TRANSPARENT;
	    FlxG.cameras.add(camUI, false);
	    camUI.downscroll = Options.downscroll;

	}
}

function onEvent(_) {
	if (FlxG.save.data.noevents) return;
	
	switch(_.event.name) {
		case "Lyrics":
			if (_.event.params[0] != '') {
				lyrics.clearFormats();
				lyrics.text = _.event.params[1] != null ? StringTools.replace(_.event.params[0], "$", "") : _.event.params[0];
				lyrics.updateHitbox();
				lyrics.screenCenter();
				lyrics.y += 150;

				lyricsBG.setGraphicSize(lyrics.width + 10, lyrics.height + 10);
				lyricsBG.setPosition(lyrics.x - 5, lyrics.y - 5);
				lyricsBG.updateHitbox();

				lyricsBG.alpha = 0.5;
				lyrics.alpha = 1;

				if (_.event.params[1] != null) lyrics.applyMarkup(_.event.params[0], [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString(_.event.params[1])), "$")]);
			} else {
				lyricsBG.alpha = 0.001;
				lyrics.alpha = 0.001;
			}
	}
}
function postCreate() {
	for (v in strumLines.members)
		for (i in v.notes.members)
			if (i.isSustainNote) i.alpha = FlxG.save.data.sustainalpha;

	camUI = new HudCamera();
	camUI.bgColor = FlxColor.TRANSPARENT;
	FlxG.cameras.add(camUI, false);
	camUI.downscroll = Options.downscroll;

	scoreGroup = new FlxGroup();
	

	if (FlxG.save.data.middlescrollOption)
		for (sl in strumLines.members)
			for (i in 0...4) {
				sl.members[i].visible = !sl.cpu;
				sl.members[i].x = 425 + (Note.swagWidth * i);
			}
	
	if (FlxG.save.data.strumbg) {
		for (sl in strumLines.members) {
			if (sl.cpu!=true) {
				var underlay = new FlxSprite(sl.members[0].x-10, 0).makeSolid(1, 1, 0xFF000000);
				underlay.alpha = FlxG.save.data.strumbgalpha;
				underlay.setGraphicSize(Note.swagWidth*sl.members.length+20, FlxG.height);
				underlay.scrollFactor.set();
				underlay.updateHitbox();
				insert(3, underlay);
				underlay.cameras = [camHUD];
			}
		}
	}
}

	function postUpdate() {

	healthBar.value = healthBar.value+0.6*(health-healthBar.value);

}

