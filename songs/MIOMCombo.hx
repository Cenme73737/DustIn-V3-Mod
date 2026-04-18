import funkin.backend.system.RotatingSpriteGroup;
import flixel.text.FlxTextBorderStyle;
import funkin.ui.FunkinText;
import flixel.tweens.FlxTween;
import flixel.text.FlxTextAlign;
import flixel.tweens.FlxEase;
import funkin.game.ComboRating;
if (!FlxG.save.data.countervis){
    return;
}
//设置端口
//隐藏默认判定显示（1为是，0为否）
var Hideyshow = 1;
//是否设置在与箭头同一摄像机上（1为是，0为否）
var SETcamHUD = 1;
//是否开启抗锯齿(1为是，0为否)
var TKJC = 1;
//颜色是否会根据SFC GFC FC SDCB 来变化（1为是，0为否）
var color = 1;

//颜色是否会根据bad shit miss 判定等级来变化（1为是，0为否）
var Jcolor = 1;

//没有颜色变化时，长时间保持的颜色( 16进制格式两个都要修改 )
var colorch = 0xFFFFFF; 
var Tcolorch = "#FFFFFF"; 

//是否显示SFC GFC文本（1为是，0为否）
var OpenSGFC = 1;

//进入歌曲的文本
var SGBS = "[SGBS : OPEN]";
//Combo文本
var Tcombo = "连击数:";
//字体
var tttf = "fallen-Tdown.ttf";
//在这里选择是否为纯英文字体(1为是，0为否)他会根据是否为英文字体来决定是否修改字体大小
//只有在字体大小为默认值时生效
var ttl = 0;

//修改判定显示的文本内容
var Tsick = "酷耶!";
var Tgood = "可以";
var Tbad = "加油吧";
var Tshit = "狗屎";
var Tmiss = "失误";
//修改SFC GFC FC SDCB显示的文本内容
var TSFC = "[SFC]";
var TGFC = "[GFC]";
var TFC = "[FC]";
var TSDCB = "[SDCB]";
var TNA = "[N/A]";

// Marvelous相关配置
// 是否启用Marvelous判定（1为是，0为否）
var EnableMarvelous = 1;

// Marvelous显示文本
var Tmarvelous = "牛逼!!!";

// MFC显示文本
var TMFC = "[MFC]";

// Marvelous颜色（16进制）
var MarvelousColor = "#FF41A3";
var TMarvelousColor = "#FF41A3";

// MFC颜色（16进制）
var MFCColor = "#FF0051";
var TMFCColor = "#FF0051";

// 是否启用MFC显示（1为是，0为否）
var EnableMFC = 1;

// 内部使用的MFC状态变量
var MFC = 0; // 初始为0，表示全Marvelous（默认状态）
var lastMFC = 0;

//调试文本位置
//是否强制y为正就为上（1为是，0为否）
var ys = 0;
//是否位置兼容向上向下滚动（1为是，0为否）
var GHJ =1;
//是否强制三个文本顺序从上到下（1为是，0为否）
var NT = 1;
//整体位置调试大小

//调整X值，0为原位置
var moveTextsX = 0;
//调整Y值，0为原位置
var moveTextsY = 0;

//单个文本位置调试
//Sick Good Bad Shit是否随着combo大于10或小于10移动（1为是，0为否）
var MTextM = 1;
//Sick Good Bad Shit 显示位置
var MTextX = 0;
var MTextY = 0;

//Combo显示位置
//是否跟随Sick Good Bad Shit X轴位置 作为您建议选择关掉Sick Good Bad Shit 随着 combo移动（1为是，0为否）
var TNY = 1;
//ComboX轴位置但是必须TNY=0才生效
var MCCTextX = 0;
//ComboY轴位置
var MCTextY = 0;

//SFC GFC 等显示位置
var MJTextX = 0;
var MJTextY = 0;

//文本大小乘积
//所有文本
var STexts = 1;
//Sick Good Bad Shit 文本大小
var SText = 1;
//Combo文本大小
var SCText = 1;
//SFC GFC 文本大小
var SJText = 1;

//设置字体大小
//Sick Good Bad Shit 字体大小
var ZText = 50;
//Combo字体大小
var ZCText = 35;
//SFC GFC 文本大小(默认值为25)
var ZJText = 25;

if (ZJText == 25 && ttl == 1){
ZJText = 35;
}

//作者:MIOM 当前版本为Demo-2演示版,不代表正式版的最终显示成果
//2025.11.6
//已添加Marvelous判定和MFC系统
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
//以下玩家请不要修改

var FK = 0;
var jC = "";
if(ys != 1 && SETcamHUD == 1 && !get_downscroll && NT !=0){
MTextY =-1*MTextY;
MJTextY =-1*MJTextY;
}
if(ys == 1 && SETcamHUD == 1 && !get_downscroll && NT ==0){
MTextY =-1*MTextY;
MJTextY =-1*MJTextY;
}
if(ys == 1 && SETcamHUD == 1 && !get_downscroll){
MCTextY =-1*MCTextY;
}
if(NT ==1 && get_downscroll){
MCTextY =-1*MCTextY;
}

if(TNY == 1){
var MCTextX = MTextX;
}else{
var MCTextX = MCCTextX;
}
    if (!get_downscroll() && NT == 1){
    var MMM = 1;
    }else{
         var MMM = 0;
     }
     
public var camMIOMCombo:FlxCamera = new FlxCamera();
if(SETcamHUD == 0){
    var Ty = 550 - moveTextsY;
    }else{
    if (get_downscroll() ){
    var Ty = 135 + moveTextsY;
    }else{
    if (GHJ==0 ){
    var Ty = 550 - moveTextsY;
    }else{
    if (ys==0 ){
    var Ty = 135 + moveTextsY;
    }else{
    var Ty = 135 - moveTextsY;
    }
    }}}
var prevCombo:Int = 0;
var prevMisses:Int = 0;
var textMoved:Bool = false;
var GFC = 1;
var SFC = 1;
var FC = 1;
var SDCB = 1;
var FI = 1;

if ( color == 0){
    var Sickcolor =Tcolorch;
    var Goodcolor = Tcolorch;
    var Otcolor = Tcolorch;
    var JTextcolor = Tcolorch;
    }else{
    var Sickcolor = "#FFFF00";
    var Goodcolor = "#87CEEB";
    var Otcolor = "#9ACD32";
    var JTextcolor = "#FFD700";
    }

// 标记是否第一次按音符
var firstHit:Bool = true;

// 无操作计时器和淡出控制变量
var idleTimer:Float = 0;
var isFadingOut:Bool = false;
var fadeTween:FlxTween = null;

// 文本对象声明
var Text:FunkinText;
var CText:FunkinText;
var JText:FunkinText;
var AText:FunkinText;
var ratingNum:Int = 0;

// 添加缩放动画控制变量
var textScaleTween:FlxTween = null;
var cTextScaleTween:FlxTween = null;

// 添加变量追踪上一次的值
var lastGFC:Int = 1;
var lastSFC:Int = 1;
var lastFC:Int = 1;
var lastSDCB:Int = 1;
var lastGGG:Int = 1;

// 添加JText动画控制变量
var aTextAlphaTween:FlxTween = null;
var jTextTween:FlxTween = null;
var jTextOriginalY:Float = 0;
var jTextOriginalAlpha:Float = 1;

// 用于SETcamHUD=1时文本淡出的虚拟对象
var textFadeData = { alpha: 1.0 };

// 跟踪CText透明度补间
var cTextAlphaTween:FlxTween = null;

// 跟踪CText的目标透明度
var cTextTargetAlpha:Float = 0;

// 新增：标记是否第一次显示CText
var firstCTextShow:Bool = true;

function updateColors() {
    if (color == 1) {
        // 优先级：MFC > SFC > GFC > FC > SDCB
        if (MFC == 0 && EnableMFC == 1) {
            // MFC：全Marvelous
            Sickcolor = MFCColor;
            Goodcolor = MFCColor;
            Otcolor = MFCColor;
            JTextcolor = MFCColor;
            jC = TMFC;
        } else if (SDCB == 0) {
            Sickcolor = "#FFFFFF";
            Goodcolor = "#FFFFFF";
            Otcolor = "#FFFFFF";
            JTextcolor = Otcolor;
            jC = "";
        } else if (FC == 0) {
            Sickcolor = "#FF90EE90";
            Goodcolor = "#FF90EE90";
            Otcolor = "#FF90EE90";
            JTextcolor = Otcolor;
            jC = TSDCB;
        } else if (SFC == 0) {
            Sickcolor = "#FFA500";
            Goodcolor = "#FFA500";
            Otcolor = "#FFA500";
            JTextcolor = Otcolor;
            jC = TFC;
        } else if (GFC == 0) {
            Sickcolor = "#87CEEB";
            Goodcolor = "#87CEEB";
            Otcolor = "#87CEEB";
            JTextcolor = Goodcolor;
            jC = TGFC;
        } else {
            Sickcolor = "#FFFF00";
            Goodcolor = "#FFFF00";
            Otcolor = "#FFFF00";
            JTextcolor = Sickcolor;
            jC = TSFC;
        }
    } else {
        // 无颜色变化模式
        if (MFC == 0 && EnableMFC == 1) {
            jC = TMFC;
        } else if (SDCB == 0) {       
            jC = "";
        } else if (FC == 0) {               
            jC = TSDCB;
        } else if (SFC == 0) {       
            jC = TFC;
        } else if (GFC == 0) {
            jC = TGFC;
        } else {       
             jC = TSFC;
        }
    }
}

function postCreate() {
    camMIOMCombo.bgColor = 0x00000000;
    FlxG.cameras.add(camMIOMCombo, false);
}

function onPlayerHit(event) {
    resetIdleTimer();
    if(Hideyshow == 1){
        event.showRating = false;
    }
    if (event.note.isSustainNote) return;
    
    // 直接检测event.rating是否为marvelous
    var isMarvelous = false;
    if (EnableMarvelous == 1 && event.rating == "marvelous") {
        isMarvelous = true;
    }
    
    // 触发放大动画
    triggerScaleAnimation();
    
    ratingNum += 1;
    
    // 关键修复：只有当击打不是Marvelous时，才设置MFC=1
    if (!isMarvelous) {
        MFC = 1; // 有非Marvelous击打，不是全Marvelous
    }
    
    // 第一次按音符时的特殊处理
    if (firstHit) {
        firstHit = false;
        
        if (isMarvelous) {
            // Marvelous判定 - 不设置SFC/GFC/FC
            JTextcolor = MarvelousColor;
            SGBS = Tmarvelous;
            Text.color = FlxColor.fromString(MarvelousColor);
            CText.color = FlxColor.fromString(MarvelousColor);
        } else {
            // 原有判定逻辑
            switch (event.rating) {
                case "sick": 
                    // 有sick但不是Marvelous，设置SFC=1（保持SFC状态）
                    // MFC已经在上面设置为1了
                    JTextcolor = Sickcolor;
                    SGBS = Tsick;
                    Text.color = FlxColor.fromString("#FFFF00");
                    CText.color = FlxColor.fromString("#FFFF00");
                    
                case "good":
                    GFC = 0; // 有good，不是GFC
                    MFC = 1; // 有非Marvelous击打
                    JTextcolor = Goodcolor;
                    SGBS = Tgood;
                    Text.color = FlxColor.fromString("#87CEEB");
                    CText.color = FlxColor.fromString("#87CEEB");
                    
                case "bad": 
                    GFC = 0; // 有bad，不是GFC
                    SFC = 0; // 有bad，不是SFC
                    MFC = 1; // 有非Marvelous击打
                    JTextcolor = Otcolor;
                    SGBS = Tbad;
                    if(Jcolor == 1){
                        Text.color = FlxColor.fromString("#A5A5A5");
                        CText.color = FlxColor.fromString("#9ACD32");
                    }else{
                        Text.color = FlxColor.fromString(Tcolorch);
                        CText.color = FlxColor.fromString(Tcolorch);
                    }
                    
                case "shit": 
                    GFC = 0; // 有shit，不是GFC
                    SFC = 0; // 有shit，不是SFC
                    MFC = 1; // 有非Marvelous击打
                    JTextcolor = Otcolor;
                    SGBS = Tshit;
                    if(Jcolor == 1){
                        Text.color = FlxColor.fromString("#696969");
                        CText.color = FlxColor.fromString("#FFD700");
                    }else{
                        Text.color = FlxColor.fromString(Tcolorch);
                        CText.color = FlxColor.fromString(Tcolorch);
                    }
            }
        }
        
        // 触发JText动画显示第一次击打的信息
        FK = 1;
        updateColors();
        triggerJTextAnimation();
        
    } else {
        // 非第一次击打
        if (isMarvelous) {
            // Marvelous判定 - 不设置SFC/GFC/FC
            updateColors();
            Text.color = FlxColor.fromString(MarvelousColor);
            CText.color = FlxColor.fromString(MarvelousColor);
            SGBS = Tmarvelous;
        } else {
            // 原有判定逻辑
            switch (event.rating) {
                case "sick": 
                    // 有sick但不是Marvelous，MFC已经在上面设置为1了
                    updateColors();
                    Text.color = FlxColor.fromString(Sickcolor);
                    CText.color = FlxColor.fromString(Sickcolor);
                    SGBS = Tsick;
                    
                case "good":
                    GFC = 0; // 有good，不是GFC
                    MFC = 1; // 有非Marvelous击打
                    updateColors();
                    Text.color = FlxColor.fromString(Goodcolor);
                    CText.color = FlxColor.fromString(Goodcolor);
                    SGBS = Tgood;
                    
                case "bad": 
                    GFC = 0; // 有bad，不是GFC
                    SFC = 0; // 有bad，不是SFC
                    MFC = 1; // 有非Marvelous击打
                    updateColors();
                    if(Jcolor == 1){
                        Text.color = FlxColor.fromString("#A5A5A5");
                        CText.color = FlxColor.fromString(Otcolor);
                    }else{
                        Text.color = FlxColor.fromString(Tcolorch);
                        CText.color = FlxColor.fromString(Tcolorch);
                    }
                    SGBS = Tbad;
                    
                case "shit": 
                    GFC = 0; // 有shit，不是GFC
                    SFC = 0; // 有shit，不是SFC
                    MFC = 1; // 有非Marvelous击打
                    updateColors();
                    if(Jcolor == 1){
                        Text.color = FlxColor.fromString("#696969");
                        CText.color = FlxColor.fromString(Otcolor);
                    }else{
                        Text.color = FlxColor.fromString(Tcolorch);
                        CText.color = FlxColor.fromString(Tcolorch);
                    }
                    SGBS = Tshit;
            }
        }
    }
}

function create() {
    // 初始化MFC状态为0（默认全Marvelous）
    MFC = 0;
    lastMFC = 0;
    
   if(SETcamHUD == 0){
   if(MTextM == 1){
   Text = new FunkinText(530, Ty-8-MTextY, FlxG.width, "", 20);
   }else{
   Text = new FunkinText(530, Ty - 45 - MTextY ,FlxG.width, "", 20);
   }
    }else{
    if(MMM == 0){
    if(MTextM == 1){
  Text = new FunkinText(530, Ty-4+MTextY, FlxG.width, "", 20);
  }else{
  Text = new FunkinText(530, Ty + 34 + MTextY, FlxG.width, "", 20);
  }
    }else{
    if(MTextM == 1){
    Text = new FunkinText(530, Ty-8-MTextY, FlxG.width, "", 20);
    }else{
    Text = new FunkinText(530, Ty - 45 - MTextY, FlxG.width, "", 20);
    }
    }
    }
    
    Text.alignment = FlxTextAlign.CENTER;
    Text.screenCenter(FlxAxes.X);
    Text.x += moveTextsX + MTextX;
   if (SETcamHUD == 0){
    Text.camera = camMIOMCombo;
    }else{
    Text.camera = camHUD;
    }
    if ( color == 1){
    Text.setFormat(Paths.font(tttf), ZText, 0xFFFF00);
    }else{
    Text.setFormat(Paths.font(tttf), ZText, colorch);
    }
    Text.borderStyle = FlxTextBorderStyle.OUTLINE;
    Text.borderSize = 2;
    Text.borderColor = 0xFF000000;
    Text.scale.set(1*STexts*SText, 1*STexts*SText);
    if ( TKJC == 1){
    Text.antialiasing = true;
    }
    add(Text);
    
    if(SETcamHUD == 0){
   CText = new FunkinText(530, Ty+3, FlxG.width, "", 20);
    }else{
   if(MMM == 0){
  CText = new FunkinText(530, Ty-3, FlxG.width, "", 20);
  }else{
  CText = new FunkinText(530, Ty+3, FlxG.width, "", 20);
  }
    }
    CText.alignment = FlxTextAlign.CENTER;
    CText.screenCenter(FlxAxes.X);
    if (SETcamHUD == 0){
    CText.camera = camMIOMCombo;
    }else{
    CText.camera = camHUD;
    }
    if ( color == 1){
    CText.setFormat(Paths.font(tttf), ZCText, 0xFFFF00);
    }else{
    CText.setFormat(Paths.font(tttf), ZCText, colorch);
    }
    CText.borderStyle = FlxTextBorderStyle.OUTLINE;
    CText.borderSize = 2;
    CText.borderColor = 0xFF000000;
    CText.x += moveTextsX + MCTextX;
    if(SETcamHUD == 0){
    CText.y -= MCTextY;
    }else{
    CText.y += MCTextY;
    }
    CText.alpha = 0;
    CText.scale.set(1*STexts*SCText, 1*STexts*SCText);
    if ( TKJC == 1){
    CText.antialiasing = true;
    }
    add(CText);
    
    if(SETcamHUD == 0){
   JText = new FunkinText(530, Ty+35-MJTextY, FlxG.width, TNA, 20);
    }else{
    if(MMM == 0){
  JText = new FunkinText(530, Ty-35+MJTextY, FlxG.width, TNA, 20);
  }else{
  JText = new FunkinText(530, Ty+35-MJTextY, FlxG.width, TNA, 20);
    }}
    JText.alignment = FlxTextAlign.CENTER;
    JText.screenCenter(FlxAxes.X);
    if (SETcamHUD == 0){
    JText.camera = camMIOMCombo;
    }else{
    JText.camera = camHUD;
    }
     if ( color == 1){
    JText.setFormat(Paths.font(tttf), ZJText, 0x808080);
    }else{
    JText.setFormat(Paths.font(tttf), ZJText, colorch);
    }
    JText.borderStyle = FlxTextBorderStyle.OUTLINE;
    JText.borderSize = 2;
    JText.borderColor = 0xFF000000;
    JText.x += moveTextsX + MJTextX;
    
    // 记录JText的原始位置和透明度
    jTextOriginalY = JText.y;
    jTextOriginalAlpha = JText.alpha;
    JText.scale.set(1*STexts*SJText,1*STexts*SJText);
    if ( TKJC == 1){
    JText.antialiasing = true;
    }
    add(JText);
     AText = new FunkinText(530, Ty+35-MJTextY, FlxG.width, "", 20);
       add(AText);
    updateColors(); // 初始化颜色
}

function update(elapsed:Float) {
    idleTimer += elapsed;
    
    if (idleTimer >= 1 && !isFadingOut) {
        startFadeOut();
    }
    
    if (combo >= 10 && prevCombo < 10 && !textMoved) {
        // 先处理Text的位置动画
        if(SETcamHUD == 0){
            FlxTween.tween(Text, { y: Ty - 45 - MTextY }, 0.8, { ease: FlxEase.backOut });
        }else{
        if(MMM == 0){
            FlxTween.tween(Text, { y: Ty + 34 + MTextY }, 0.8, { ease: FlxEase.backOut });
            }else{
            FlxTween.tween(Text, { y: Ty - 45 - MTextY }, 0.8, { ease: FlxEase.backOut });
            }
        }
        
        // 确保CText的透明度动画在第一次也能正确播放
        cTextTargetAlpha = 1;
        updateCTextAlpha();
        
        textMoved = true;
    }
    
    if (combo < 10 && prevCombo >= 10 && textMoved) {
        // 先处理Text的位置动画
        if(SETcamHUD == 0){
        if(MTextM == 1){
            FlxTween.tween(Text, { y: Ty-8-MTextY }, 0.8, { ease: FlxEase.backOut });
            }else{
            Text.y = Ty - 45 - MTextY;
            }
        }else{
        if(MMM == 0){
         if(MTextM == 1){
            FlxTween.tween(Text, { y: Ty-4+MTextY }, 0.8, { ease: FlxEase.backOut });
            }else{
            Text.y =  Ty + 34 + MTextY;
            }
            }else{
             if(MTextM == 1){
            FlxTween.tween(Text, { y: Ty-8-MTextY }, 0.8, { ease: FlxEase.backOut });
            }else{
            Text.y = Ty - 45 - MTextY;
            }
            
        }
        }
        
        // 设置CText的目标透明度为0
        cTextTargetAlpha = 0;
        updateCTextAlpha();
        
        textMoved = false;
    }
    
    prevCombo = combo;

    Text.text = SGBS;
    
    if (combo < 10) {
        CText.text = "";
    } else if (combo < 100) {
        CText.text = Tcombo + " 0" + combo;
    } else {
        CText.text = Tcombo + " " + combo;
    }
    
    // 检测五个判定变量是否有变化（仅在非第一次击打时）
     if (!firstHit && (GFC != lastGFC || SFC != lastSFC || FC != lastFC || SDCB != lastSDCB || MFC != lastMFC)) {
        // 只调用动画触发，不在这里直接更新文本
        triggerJTextAnimation();
        
        // 更新记录的值
        lastGFC = GFC;
        lastSFC = SFC;
        lastFC = FC;
        lastSDCB = SDCB;
        lastMFC = MFC;
    }
    
    if (misses != prevMisses) {
        idleTimer = 0;
        resetIdleTimer();
     
        FC = 0;
        SFC = 0;
        GFC = 0;
        MFC = 1; // 有miss肯定不是MFC
        if(Jcolor == 1){
        Text.color = FlxColor.fromString("#FF4500");
        CText.color = FlxColor.fromString("#FF4500");
        }else{
         Text.color = FlxColor.fromString(Tcolorch);
        CText.color = FlxColor.fromString(Tcolorch);
        }
        SGBS = Tmiss;
        triggerScaleAnimation();
        prevMisses = misses;
        if ( misses > 10){
            SDCB = 0;
        }
        updateColors();
      
    }
      if (OpenSGFC != 1 ){
    JText.text = "";
    }
}

// 平滑更新CText透明度
function updateCTextAlpha() {
    // 如果CText正在执行透明度动画，先取消
    if (cTextAlphaTween != null) {
        cTextAlphaTween.cancel();
        cTextAlphaTween = null;
    }
    
    // 关键修改：确保第一次显示时从0开始
    if (firstCTextShow && cTextTargetAlpha == 1) {
        CText.alpha = 0;
        firstCTextShow = false;
    }
    
    // 创建CText的透明度补间动画
    cTextAlphaTween = FlxTween.tween(CText, { alpha: cTextTargetAlpha }, 0.8, {
        ease: FlxEase.quadInOut,
        onComplete: function() {
            cTextAlphaTween = null;
        }
    });
}

// 缩放动画触发函数
function triggerScaleAnimation() {
    // 取消可能正在进行的缩放动画
    if (textScaleTween != null) textScaleTween.cancel();
    if (cTextScaleTween != null) cTextScaleTween.cancel();
    
    // 重置缩放值为1
    Text.scale.set(1*STexts*SText, 1*STexts*SText);
    CText.scale.set(1*STexts*SCText, 1*STexts*SCText);
    JText.scale.set(1*STexts*SJText,1*STexts*SJText);
    Text.updateHitbox();
    CText.updateHitbox();
    
    // Text的缩放动画
    textScaleTween = FlxTween.tween(Text.scale, { x: 1.05*STexts*SText, y: 1.05*STexts*SText }, 0.1, {
        ease: FlxEase.quadOut,
        onComplete: function(t:FlxTween) {
            textScaleTween = FlxTween.tween(Text.scale, { x: 1*STexts*SText, y: 1*STexts*SText }, 0.3, {
                ease: FlxEase.quadIn,
                onComplete: function(t:FlxTween) {
                    textScaleTween = null;
                }
            });
        }
    });
    
    // CText的缩放动画
    cTextScaleTween = FlxTween.tween(CText.scale, { x: 1.03*STexts*SCText, y: 1.03*STexts*SCText }, 0.1, {
        ease: FlxEase.quadOut,
        onComplete: function(t:FlxTween) {
            cTextScaleTween = FlxTween.tween(CText.scale, { x: 1*STexts*SCText, y: 1*STexts*SCText }, 0.3, {
                ease: FlxEase.quadIn,
                onComplete: function(t:FlxTween) {
                    cTextScaleTween = null;
                }
            });
        }
    });
}
        
// JText动画触发函数
function triggerJTextAnimationB() {
    if (jTextTween != null) jTextTween.cancel();
   
    // 在动画开始前保存当前状态
    var originalText = JText.text;
    var originalColor = JText.color;
     
    if(SETcamHUD == 0){
    
        jTextTween = FlxTween.tween(JText, { y: Ty + 35 + 25 - MJTextY, alpha: 0 }, 0.3, {
            ease: FlxEase.quadIn,
            onComplete: function(t:FlxTween) {
                // 只在淡入动画开始时更新文本
                JText.text = jC;
                JText.color = FlxColor.fromString(JTextcolor);
                
                jTextTween = FlxTween.tween(JText, { y: Ty +35 - MJTextY, alpha: jTextOriginalAlpha }, 0.3, {
                    ease: FlxEase.backOut,
                    onComplete: function(t:FlxTween) {
                        jTextTween = null;
                    }
                });
            }
        });
    }else{
    if(MMM == 0){
    
        jTextTween = FlxTween.tween(JText, { y: Ty - 35 - 25 + MJTextY, alpha: 0 }, 0.3, {
            ease: FlxEase.quadIn,
            onComplete: function(t:FlxTween) {
                // 只在淡入动画开始时更新文本
                JText.text = jC;
                JText.color = FlxColor.fromString(JTextcolor);
                
                jTextTween = FlxTween.tween(JText, { y: Ty -35 + MJTextY, alpha: jTextOriginalAlpha }, 0.3, {
                    ease: FlxEase.backOut,
                    onComplete: function(t:FlxTween) {
                        jTextTween = null;
                    }
                });
            }
        });
    }
    else{
            jTextTween = FlxTween.tween(JText, { y: Ty + 35 + 25 - MJTextY, alpha: 0 }, 0.3, {
            ease: FlxEase.quadIn,
            onComplete: function(t:FlxTween) {
                // 只在淡入动画开始时更新文本
                JText.text = jC;
                JText.color = FlxColor.fromString(JTextcolor);
                
                jTextTween = FlxTween.tween(JText, { y: Ty +35 - MJTextY, alpha: jTextOriginalAlpha }, 0.3, {
                    ease: FlxEase.backOut,
                    onComplete: function(t:FlxTween) {
                        jTextTween = null;
                    }
                });
            }
        });
        }
}}

// 第一次击打动画触发函数
function triggerFirstHitAnimation() {
    updateColors();
    triggerJTextAnimation() ;
    JText.color = FlxColor.fromString(JTextcolor);   
}

function resetIdleTimer() {
    idleTimer = 0;
    if (isFadingOut) {
        cancelFadeOut();
        if (SETcamHUD == 0) {
            // SETcamHUD=0时，恢复相机透明度
            FlxTween.tween(camMIOMCombo, { alpha: 1 }, 0.1, {
                ease: FlxEase.quadOut,
                onComplete: function() {
                    camMIOMCombo.alpha = 1;
                }
            });
        } else {
            // SETcamHUD=1时，恢复所有文本透明度
            FlxTween.tween(textFadeData, { alpha: 1 }, 0.1, {
                ease: FlxEase.quadOut,
                onUpdate: function() {
                    Text.alpha = textFadeData.alpha;
                    CText.alpha = textFadeData.alpha;
                    JText.alpha = textFadeData.alpha;
                },
                onComplete: function() {
                    Text.alpha = 1;
                    CText.alpha = 1;
                    JText.alpha = 1;
                    textFadeData.alpha = 1;
                    
                    // 恢复CText的目标透明度
                    updateCTextAlpha();
                }
            });
        }
    }
}

function startFadeOut() {
    isFadingOut = true;
    if (fadeTween != null) fadeTween.cancel();
    
    if (SETcamHUD == 0) {
        // 淡出相机
        fadeTween = FlxTween.tween(camMIOMCombo, { alpha: 0 }, 0.8, { 
            ease: FlxEase.quadIn,
            onComplete: function(t:FlxTween) {
                camMIOMCombo.alpha = 0;
                isFadingOut = false;
                fadeTween = null;
            }
        });
    } else {
        // 淡出三个文本
        fadeTween = FlxTween.tween(textFadeData, { alpha: 0 }, 0.8, {
            ease: FlxEase.quadIn,
            onUpdate: function() {
                Text.alpha = textFadeData.alpha;
                CText.alpha = textFadeData.alpha;
                JText.alpha = textFadeData.alpha;
            },
            onComplete: function(t:FlxTween) {
                Text.alpha = 0;
                CText.alpha = 0;
                JText.alpha = 0;
                textFadeData.alpha = 0;
                isFadingOut = false;
                fadeTween = null;
            }
        });
    }
}

function cancelFadeOut() {
    if (fadeTween != null) {
        fadeTween.cancel();
        fadeTween = null;
    }
    isFadingOut = false;
}
function triggerJTextAnimation() {
if ( JText.alpha != 1){
aTextAlphaTween = FlxTween.tween(AText, { alpha: 0 }, 0.1, {
            ease: FlxEase.quadIn,
            onComplete: function(t:FlxTween) {
                AText.alpha = 0;
                triggerJTextAnimationB();
            }
        });
}else{

triggerJTextAnimationB();
}
}

// 添加歌曲开始时的重置函数
function onSongStart() {
    MFC = 0; // 初始为0（全Marvelous）
    lastMFC = 0;
    firstHit = true;
    ratingNum = 0;
    SFC = 1;
    GFC = 1;
    FC = 1;
    SDCB = 1;
    updateColors();
}

// 清理函数
function onDestroy() {
    if (fadeTween != null) fadeTween.cancel();
    if (textScaleTween != null) textScaleTween.cancel();
    if (cTextScaleTween != null) cTextScaleTween.cancel();
    if (jTextTween != null) jTextTween.cancel();
    if (cTextAlphaTween != null) cTextAlphaTween.cancel();
    FlxG.cameras.remove(camMIOMCombo, false);
}
