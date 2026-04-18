import funkin.backend.system.RotatingSpriteGroup;
import flixel.text.FlxTextBorderStyle;
import funkin.ui.FunkinText;
import flixel.tweens.FlxTween;
import flixel.text.FlxTextAlign;
import flixel.tweens.FlxEase;
import funkin.game.ComboRating;
import flixel.util.FlxStringUtil;
import flixel.util.FlxAxes;

if (!FlxG.save.data.datavis){
    return;
}

var customLengthOverride:Float = -1;
// 设置端口
// 修改黑边大小
var BlackS = 2;
//是否开启抗锯齿(1为是，0为否)
var TKJC = 1;
// 修改字体文件
var Tttf = "Combo.ttf";
// 标题y轴位置，注意是越小就越在上面，数据也会跟着往下排列
var Tnf = 200;
// 标题文字大小
var Ts = 25;
// 数据文字大小
var Ds = 20;
// 修改或新建两个变量来实现自由调节小区间和大区间的大小
var SmallGap = 3;  // 小区间间隔大小（像素）- 文本底部到下一个文本顶部的距离
var LargeGap = 8;  // 大区间间隔大小（像素）- 文本底部到下一个文本顶部的距离

//是否修改歌曲名 (1为是，0为否)
var NYN = 0;
// 歌曲名称显示模式变量 (0: 不改变, 1: 首字母大写, 2: 首字母小写, 3: 全部大写)
var SongNameDisplayMode:Int = 1;
//是否使用DIY的歌名？(1为是，0为否)
var DIYNY = 0;
// 时间显示模式变量 (1: 当前时间/总时间, 0: 剩余时间/总时间)
var Ttm:Int = 1;
// 百分比显示模式变量 (1: 已过百分比, 0: 剩余百分比)
var Ptm:Int = 1;
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
// 新增：DatashowmarvelousMode变量
var DatashowmarvelousMode:Bool = false;

var currentY = Tnf;
public var DIYName:String = -1; //不要动，DIY设置
var FirstN = 0;
var ComboB = null;
var SickN = 0;
var GoodN = 0;
var BadN = 0;
var ShitN = 0;
var MarvelousN = 0;  // 新增：marvelous计数变量
var ComboM = 0;
var Stext:FunkinText;
var Sotext:FunkinText;
var Actext:FunkinText;
var SNtext:FunkinText;
var Gtext:FunkinText;
var Btext:FunkinText;
var Shtext:FunkinText;
var Mtext:FunkinText;  // 新增：Marvelous文本
var Ctext:FunkinText;
var CMtext:FunkinText;
var Ttext:FunkinText;
var Misstext:FunkinText;
var Titext:FunkinText;
var camMIOMData:FlxCamera = new FlxCamera();
var firstHit:Bool = true;

function postCreate() {
    camMIOMData.bgColor = 0x00000000;
    FlxG.cameras.add(camMIOMData, false);
}

function create() {
    var currentY = Tnf;
    
    // 标题文本
    Ttext = new FunkinText(5, currentY, FlxG.width, "   Scoreboard", 20);
    Ttext.camera = camMIOMData;
    Ttext.setFormat(Paths.font(Tttf), Ts, 0xFFFF00);
    Ttext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Ttext.borderColor = 0xFF000000;
    Ttext.borderSize = BlackS;
    if ( TKJC == 1){
    Ttext.antialiasing = true;
    }
    add(Ttext);
    currentY += Ttext.height/1.5 + LargeGap; // 标题后使用大区间间隔
    
    // Combo Max文本
    CMtext = new FunkinText(5, currentY, FlxG.width, "Combo Max: "+ComboM, 20);
    CMtext.camera = camMIOMData;
    CMtext.setFormat(Paths.font(Tttf), Ds, 0xFFFFFF);
    CMtext.borderStyle = FlxTextBorderStyle.OUTLINE;
    CMtext.borderColor = 0xFF000000;
    CMtext.borderSize = BlackS;
    if ( TKJC == 1){
    CMtext.antialiasing = true;
    }
    add(CMtext);
    currentY += CMtext.height/1.5 + SmallGap; // Combo Max后使用小区间间隔
    
    // Combo文本
    Ctext = new FunkinText(5, currentY, FlxG.width, "Combo: "+combo, 20);
    Ctext.camera = camMIOMData;
    Ctext.setFormat(Paths.font(Tttf), Ds, 0xFFFFFF);
    Ctext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Ctext.borderColor = 0xFF000000;
    Ctext.borderSize = BlackS;
    if ( TKJC == 1){
    Ctext.antialiasing = true;
    }
    add(Ctext);
    currentY += Ctext.height/1.5 + LargeGap; // Combo后使用大区间间隔（进入判定数据部分）
    
    // 初始化时检测MIOMmarvelousMode状态
    try {
        if (MIOMmarvelousMode) {
            DatashowmarvelousMode = true;
        }
    } catch (e:Dynamic) {
        DatashowmarvelousMode = false;
    }
    
    // 创建Marvelous文本但 > 先隐藏
    Mtext = new FunkinText(5, currentY, FlxG.width, "Marvelous: "+MarvelousN, 20);
    Mtext.camera = camMIOMData;
    Mtext.setFormat(Paths.font(Tttf), Ds, 0xFF41A3);
    Mtext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Mtext.borderColor = 0xFF000000;
    Mtext.borderSize = BlackS;
    if ( TKJC == 1){
    Mtext.antialiasing = true;
    }
    Mtext.visible = DatashowmarvelousMode; // 根据初始状态设置可见性
    add(Mtext);
    
    // 调整当前位置
    if (DatashowmarvelousMode) {
        currentY += Mtext.height/1.5 + SmallGap; // Marvelous后使用小区间间隔
    }
    
    // Sick文本
    Stext = new FunkinText(5, currentY, FlxG.width, "Sick: "+SickN, 20);
    Stext.camera = camMIOMData;
    Stext.setFormat(Paths.font(Tttf), Ds, 0xFFFF00);
    Stext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Stext.borderColor = 0xFF000000;
    Stext.borderSize = BlackS;
    if ( TKJC == 1){
    Stext.antialiasing = true;
    }
    add(Stext);
    currentY += Stext.height/1.5 + SmallGap; // Sick后使用小区间间隔
    
    // Good文本
    Gtext = new FunkinText(5, currentY, FlxG.width, "Good: "+GoodN, 20);
    Gtext.camera = camMIOMData;
    Gtext.setFormat(Paths.font(Tttf), Ds, 0x87CEEB);
    Gtext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Gtext.borderColor = 0xFF000000;
    Gtext.borderSize = BlackS;
    if ( TKJC == 1){
    Gtext.antialiasing = true;
    }
    add(Gtext);
    currentY += Gtext.height/1.5 + SmallGap; // Good后使用小区间间隔
    
    // Bad文本
    Btext = new FunkinText(5, currentY, FlxG.width, "Bad: "+BadN, 20);
    Btext.camera = camMIOMData;
    Btext.setFormat(Paths.font(Tttf), Ds, 0xA5A5A5);
    Btext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Btext.borderColor = 0xFF000000;
    Btext.borderSize = BlackS;
    if ( TKJC == 1){
    Btext.antialiasing = true;
    }
    add(Btext);
    currentY += Btext.height/1.5 + SmallGap; // Bad后使用小区间间隔
    
    // Shit文本
    Shtext = new FunkinText(5, currentY, FlxG.width, "Shit: "+ShitN, 20);
    Shtext.camera = camMIOMData;
    Shtext.setFormat(Paths.font(Tttf), Ds, 0x696969);
    Shtext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Shtext.borderColor = 0xFF000000;
    Shtext.borderSize = BlackS;
    if ( TKJC == 1){
    Shtext.antialiasing = true;
    }
    add(Shtext);
    currentY += Shtext.height/1.5 + SmallGap; // Shit后使用小区间间隔
    
    // Misses文本
    Misstext = new FunkinText(5, currentY, FlxG.width, "Misses: "+misses, 20);
    Misstext.camera = camMIOMData;
    Misstext.setFormat(Paths.font(Tttf), Ds, 0xFF4500);
    Misstext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Misstext.borderColor = 0xFF000000;
    Misstext.borderSize = BlackS;
    if ( TKJC == 1){
    Misstext.antialiasing = true;
    }
    add(Misstext);
    currentY += Misstext.height/1.5 + LargeGap; // Misses后使用大区间间隔（进入歌曲信息部分）
    
    // 歌曲名称文本
    SNtext = new FunkinText(5, currentY, FlxG.width, "Song Name: " + getFormattedSongName(), 20);
    SNtext.camera = camMIOMData;
    SNtext.setFormat(Paths.font(Tttf), Ds, 0xFFFF00);
    SNtext.borderStyle = FlxTextBorderStyle.OUTLINE;
    SNtext.borderColor = 0xFF000000;
    SNtext.borderSize = BlackS;
    if ( TKJC == 1){
    SNtext.antialiasing = true;
    }
    add(SNtext);
    currentY += SNtext.height/1.5 + SmallGap; // Song Name后使用小区间间隔
    
    // Score文本
    Sotext = new FunkinText(5, currentY, FlxG.width, "Score: "+FlxStringUtil.formatMoney(songScore,false,true), 20);
    Sotext.camera = camMIOMData;
    Sotext.setFormat(Paths.font(Tttf), Ds, 0xFFFF00);
    Sotext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Sotext.borderColor = 0xFF000000;
    Sotext.borderSize = BlackS;
    if ( TKJC == 1){
    Sotext.antialiasing = true;
    }
    add(Sotext);
    currentY += Sotext.height/1.5 + SmallGap; // Score后使用小区间间隔
    
    // Accuracy文本
    Actext = new FunkinText(5, currentY, FlxG.width, "Accuracy: 0% - " , 20);
    Actext.camera = camMIOMData;
    Actext.setFormat(Paths.font(Tttf), Ds, 0xFFFF00);
    Actext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Actext.borderColor = 0xFF000000;
    Actext.borderSize = BlackS;
    if ( TKJC == 1){
    Actext.antialiasing = true;
    }
    add(Actext);
    currentY += Actext.height/1.5 + SmallGap; // Accuracy后使用小区间间隔
    
    // Time文本
    Titext = new FunkinText(5, currentY, FlxG.width, "Time: 00:00:00 / 00:00:00 - 0.00%" , 20);
    Titext.camera = camMIOMData;
    Titext.setFormat(Paths.font(Tttf), Ds, 0xFFFF00);
    Titext.borderStyle = FlxTextBorderStyle.OUTLINE;
    Titext.borderColor = 0xFF000000;
    Titext.borderSize = BlackS;
    if ( TKJC == 1){
    Titext.antialiasing = true;
    }
    add(Titext);
}

function update() {
    // 实时检测MIOMmarvelousMode状态变化
    try {
        if (MIOMmarvelousMode != DatashowmarvelousMode) {
            DatashowmarvelousMode = MIOMmarvelousMode;
            Mtext.visible = DatashowmarvelousMode; // 更新Marvelous文本可见性
            adjustTextPositions(); // 重新调整所有文本位置
        }
    } catch (e:Dynamic) {
        // 如果MIOMmarvelousMode不存在，保持当前状态
    }
    
    // 更新文本内容
    Stext.text = "Sick: "+SickN;
    Gtext.text = "Good: "+GoodN;
    Btext.text = "Bad: "+BadN;
    Shtext.text = "Shit: "+ShitN;
    Ctext.text = "Combo: "+combo;
    CMtext.text = "Combo Max: "+ComboM;
    Misstext.text = "Misses: "+misses;
    Sotext.text = "Score: "+FlxStringUtil.formatMoney(songScore,false,true);
    
    // 如果启用Marvelous模式，更新Marvelous文本
    if (DatashowmarvelousMode && Mtext != null) {
        Mtext.text = "Marvelous: "+MarvelousN;
    }
    
    // 更新歌曲名称显示
    SNtext.text = "Song Name: " + getFormattedSongName();
    
    if (CoolUtil.quantize(accuracy * 100, 100) != -100){
        Actext.text = "Accuracy: "+ CoolUtil.quantize(accuracy * 100, 100) + "% - " + curRating.rating;
    } else {
        Actext.text = "Accuracy: [N/A] - "+ curRating.rating;
    }
    
    // 根据Ttm和Ptm变量选择时间显示模式
    var currentTimeFormatted = formatTimeMMSSMM(inst.time);
    var totalTimeFormatted = formatTimeMMSSMM(inst.length);
    
    // 计算进度百分比，使用新的Ptm函数
    var progressPercent = 0.00;
    if (inst.length > 0) {
        progressPercent = getProgressPercent(inst.time, inst.length, Ptm);
        // 使用字符串格式化确保小数点后两位
        progressPercent = Std.parseFloat(formatFloat(progressPercent, 2));
    }
    
    // 根据Ttm变量决定显示当前时间还是剩余时间
    var displayTimeFormatted = currentTimeFormatted;
    if (Ttm == 0) {
        // 显示剩余时间
        var remainingTime = Math.max(0, inst.length - inst.time);
        displayTimeFormatted = formatTimeMMSSMM(remainingTime);
    }
    
    Titext.text = "Time: " + displayTimeFormatted + " / " + totalTimeFormatted + " - " + formatFloat(progressPercent, 2) + "%";
    
    if(combo >= ComboM){
        ComboM = combo;
    }

    // === 颜色逻辑 ===
    
    // 原有的黄色逻辑：无失误且达到最大连击
    if (ComboM != 0 && misses == 0 && ComboM == combo){
        CMtext.color = FlxColor.fromString("#FFFF00");
        Ctext.color = FlxColor.fromString("#FFFF00");
    }
    
    // 原有的ComboB状态判断逻辑
    if (ComboM !=0 && misses != 0 && ComboM == combo && ComboB != 3){
        ComboB = 1;
    } else {
        if (combo == 0 && FirstN != 0 && misses != 0 && ComboM !=0){
            ComboB = 0;            
        } else {
            if (ComboB != 3)
                ComboB = 2;
        }
    }

    // 原有的淡蓝色逻辑（ComboB == 1时）
    if (ComboB == 1){
        CMtext.color = FlxColor.fromString("#87CEEB");
        Ctext.color = FlxColor.fromString("#87CEEB");
    } else {
        if (ComboB == 2 && misses != 0){
            CMtext.color = FlxColor.fromString("#87CEEB");
            Ctext.color = FlxColor.fromString("#FFFFFF");
        }
    }
    
    // 原有的红色逻辑（ComboB == 0时）
    if (ComboB == 0){
        Ctext.color = FlxColor.fromString("#FF4500");
    }

    // === 新增的逻辑 ===
    
    // 新增逻辑1：如果combo == ComboM，Ctext保持淡蓝色
    if (combo == ComboM && ComboM != 0 && ComboB != 1 && ComboB != 0 && 
        !(ComboM != 0 && misses == 0 && ComboM == combo)) {
        Ctext.color = FlxColor.fromString("#87CEEB");
    }
    
    // 新增逻辑2：如果Misses不等于零，但ComboM等于零，CMtext变红色
    if (misses != 0 && ComboM == 0 && 
        !(ComboM != 0 && misses == 0 && ComboM == combo) && 
        ComboB != 1) {
        CMtext.color = FlxColor.fromString("#FF4500");
    } else if (misses != 0 && ComboM != 0 && ComboB != 1 && 
               !(ComboM != 0 && misses == 0 && ComboM == combo)) {
        CMtext.color = FlxColor.fromString("#87CEEB");
    }
}

// 调整文本位置的函数
function adjustTextPositions() {
    var currentY = Tnf;
    
    // 设置标题位置
    Ttext.y = currentY;
    currentY += Ttext.height/1.5 + LargeGap;
    
    // 设置Combo Max位置
    CMtext.y = currentY;
    currentY += CMtext.height/1.5 + SmallGap;
    
    // 设置Combo位置
    Ctext.y = currentY;
    currentY += Ctext.height/1.5 + LargeGap;
    
    // 设置Marvelous位置（如果可见）
    if (Mtext != null && Mtext.visible) {
        Mtext.y = currentY;
        currentY += Mtext.height/1.5 + SmallGap;
    }
    
    // 设置Sick位置
    Stext.y = currentY;
    currentY += Stext.height/1.5 + SmallGap;
    
    // 设置Good位置
    Gtext.y = currentY;
    currentY += Gtext.height/1.5 + SmallGap;
    
    // 设置Bad位置
    Btext.y = currentY;
    currentY += Btext.height/1.5 + SmallGap;
    
    // 设置Shit位置
    Shtext.y = currentY;
    currentY += Shtext.height/1.5 + SmallGap;
    
    // 设置Misses位置
    Misstext.y = currentY;
    currentY += Misstext.height/1.5 + LargeGap;
    
    // 设置Song Name位置
    SNtext.y = currentY;
    currentY += SNtext.height/1.5 + SmallGap;
    
    // 设置Score位置
    Sotext.y = currentY;
    currentY += Sotext.height/1.5 + SmallGap;
    
    // 设置Accuracy位置
    Actext.y = currentY;
    currentY += Actext.height/1.5 + SmallGap;
    
    // 设置Time位置
    Titext.y = currentY;
}

// 修改后的歌曲名称显示逻辑函数
function getFormattedSongName():String {
    if (NYN == 0) {
        // NYN等于0：不允许修改歌曲名，无论如何都只显示原本歌曲的名称
        return PlayState.SONG.meta.displayName;
    } else {
        // NYN等于1：允许修改歌曲名
        if (DIYNY == 1 && DIYName != "-1") {
            // DIYNY为1且DIYName不等于-1：显示DIYName
            return DIYName;
        } else {
            // DIYNY为0或DIYName等于-1：根据SongNameDisplayMode格式化原歌曲名称
            var songName = PlayState.SONG.meta.displayName;
            if (songName == null || songName == "") return "Unknown";
            
            switch(SongNameDisplayMode) {
                case 0: // 不改变歌曲名称
                    return songName;
                    
                case 1: // 将歌曲名称第一个字母强制为大写
                    if (songName.length > 0) {
                        return songName.charAt(0).toUpperCase() + songName.substr(1);
                    }
                    return songName;
                    
                case 2: // 将歌曲名称第一个字母强制为小写
                    if (songName.length0) {
                        return songName.charAt(0).toLowerCase() + songName.substr(1);
                    }
                    return songName;
                    
                case 3: // 歌曲名称的所有字母都强制改为大写
                    return songName.toUpperCase();
                    
                default: // 默认原样显示
                    return songName;
            }
        }
    }
}

// 歌曲名称格式化函数
function formatSongName(songName:String):String {
    if (songName == null || songName == "") return "Unknown";
    
    switch(SongNameDisplayMode) {
        case 0: // 不改变歌曲名称
            return songName;
            
        case 1: // 将歌曲名称第一个字母强制为大写
            if (songName.length > 0) {
                return songName.charAt(0).toUpperCase() + songName.substr(1);
            }
            return songName;
            
        case 2: // 将歌曲名称第一个字母强制为小写
            if (songName.length > 0) {
                return songName.charAt(0).toLowerCase() + songName.substr(1);
            }
            return songName;
            
        case 3: // 歌曲名称的所有字母都强制改为大写
            return songName.toUpperCase();
            
        default: // 默认原样显示
            return songName;
    }
}

// 新的时间格式化函数 - 将毫秒转换为 分:秒:毫秒 格式 (00:00:00)
function formatTimeMMSSMM(ms:Float):String {
    if (ms < 0) ms = 0;
    
    var totalSeconds:Int = Math.floor(ms / 1000);
    var minutes:Int = Math.floor(totalSeconds / 60);
    var seconds:Int = totalSeconds % 60;
    var milliseconds:Int = Math.floor(ms % 1000 / 10); // 取前两位毫秒
    
    // 分钟格式化：不足两位补零，但可以超过两位
    var minutesStr:String = Std.string(minutes);
    if (minutesStr.length < 2) {
        minutesStr = "0" + minutesStr;
    }
    
    // 秒格式化：固定两位，不足补零
    var secondsStr:String = seconds < 10 ? "0" + seconds : "" + seconds;
    
    // 毫秒格式化：固定两位，不足补零
    var millisecondsStr:String = milliseconds < 10 ? "0" + milliseconds : "" + milliseconds;
    
    return minutesStr + ":" + secondsStr + ":" + millisecondsStr;
}

// 新增函数：根据模式计算进度百分比
function getProgressPercent(currentTime:Float, totalTime:Float, mode:Int):Float {
    if (totalTime <= 0) return 0.00;
    
    if (mode == 1) {
        // Ptm为1：显示已过百分比（当前时间/总时间）
        return (currentTime / totalTime) * 100;
    } else {
        // Ptm为0：显示剩余百分比（剩余时间/总时间）
        var remainingTime = Math.max(0, totalTime - currentTime);
        return (remainingTime / totalTime) * 100;
    }
}

// 新增函数：格式化浮点数到指定小数位数
function formatFloat(value:Float, decimals:Int):String {
    if (Math.isNaN(value)) value = 0;
    
    var factor:Float = Math.pow(10, decimals);
    var rounded:Float = Math.round(value * factor) / factor;
    
    var parts:Array<String> = Std.string(rounded).split(".");
    if (parts.length == 1) {
        // 没有小数部分，添加小数点和小数位
        return parts[0] + "." + StringTools.lpad("", "0", decimals);
    } else {
        // 有小数部分，确保小数位正确
        var integerPart:String = parts[0];
        var decimalPart:String = parts[1];
        
        if (decimalPart.length < decimals) {
            decimalPart = StringTools.rpad(decimalPart, "0", decimals);
        } else if (decimalPart.length > decimals) {
            decimalPart = decimalPart.substr(0, decimals);
        }
        
        return integerPart + "." + decimalPart;
    }
}

function onPlayerHit(event) {
    if (event.note.isSustainNote) return;
    
    switch (event.rating) {
        case "sick": 
            SickN += 1;
            if (firstHit) {
                firstHit = false;
                FirstN = 1;
            }
        case "good":
            GoodN += 1;          
            if (firstHit) {
                firstHit = false;
                FirstN = 1;
            }    
        case "bad": 
            BadN += 1;      
            if (firstHit) {
                firstHit = false;
                FirstN = 1;
            }         
        case "shit": 
            ShitN += 1;
            if (firstHit) {
                firstHit = false;
                FirstN = 1;
            }
        case "marvelous":  // 新增：处理marvelous判定
            if (DatashowmarvelousMode) {
                MarvelousN += 1;
                if (firstHit) {
                    firstHit = false;
                    FirstN = 1;
                }
            }
    }
}

// 新增函数：设置NYN的值
function setNYN(value:Int):Void {
    NYN = value;
    // 立即更新显示
    if (SNtext != null) {
        SNtext.text = "Song Name: " + getFormattedSongName();
    }
}

// 新增函数：获取NYN的值
function getNYN():Int {
    return NYN;
}

// 新增函数：设置DIYNY的值
function setDIYNY(value:Int):Void {
    DIYNY = value;
    // 立即更新显示
    if (SNtext != null) {
        SNtext.text = "Song Name: " + getFormattedSongName();
    }
}

// 新增函数：获取DIYNY的值
function getDIYNY():Int {
    return DIYNY;
}

// 新增函数：动态更改歌曲名称显示模式
function setSongNameDisplayMode(mode:Int):Void {
    SongNameDisplayMode = mode;
    // 立即更新显示
    if (SNtext != null) {
        SNtext.text = "Song Name: " + getFormattedSongName();
    }
}

// 新增函数：获取当前歌曲名称显示模式
function getSongNameDisplayMode():Int {
    return SongNameDisplayMode;
}

// 新增函数：设置DIYName的值
function setDIYName(value:String):Void {
    DIYName = value;
    // 立即更新显示
    if (SNtext != null) {
        SNtext.text = "Song Name: " + getFormattedSongName();
    }
}

// 新增函数：获取DIYName的值
function getDIYName():String {
    return DIYName;
}

// 新增函数：设置时间显示模式
function setTimeDisplayMode(mode:Int):Void {
    Ttm = mode;
    // 立即更新显示
    if (Titext != null) {
        update();
    }
}

// 新增函数：获取时间显示模式
function getTimeDisplayMode():Int {
    return Ttm;
}

// 新增函数：设置百分比显示模式
function setProgressPercentMode(mode:Int):Void {
    Ptm = mode;
    // 立即更新显示
    if (Titext != null) {
        update();
    }
}

// 新增函数：获取百分比显示模式
function getProgressPercentMode():Int {
    return Ptm;
}

// 新增函数：设置小区间间隔大小
function setSmallGap(value:Int):Void {
    SmallGap = value;
    adjustTextPositions(); // 重新调整位置
}

// 新增函数：获取小区间间隔大小
function getSmallGap():Int {
    return SmallGap;
}

// 新增函数：设置大区间间隔大小
function setLargeGap(value:Int):Void {
    LargeGap = value;
    adjustTextPositions(); // 重新调整位置
}

// 新增函数：获取大区间间隔大小
function getLargeGap():Int {
    return LargeGap;
}

// 新增函数：设置DatashowmarvelousMode的值
function setDatashowmarvelousMode(value:Bool):Void {
    DatashowmarvelousMode = value;
    if (Mtext != null) {
        Mtext.visible = value;
        adjustTextPositions(); // 重新调整位置
    }
}

// 新增函数：获取DatashowmarvelousMode的值
function getDatashowmarvelousMode():Bool {
    return DatashowmarvelousMode;
}
