import sys.FileSystem;
import funkin.options.type.TextOption;
import funkin.options.type.Checkbox;
import funkin.options.TreeMenuScreen;

function postCreate() {
    bg.visible = false;

    titleLabel.font = Paths.font("8bit-jve.ttf");
    descLabel.font = Paths.font("8bit-jve.ttf");

    titleLabel.size = 48;
    descLabel.size = 24;

    titleLabel.x += 10;
    descLabel.x += 10;
}

function update(elapsed:Float) {
    for (menu in tree) {
        if (menu.health != -1) {
            menu.health = -1;
            switch (menu.rawName) {
                case "optionsTree.gameplay-name":
                    var middlescrollOption:Checkbox = null;
                    var noHitCheckbox:Checkbox = null;
                    var mechanicsHitCheckbox:Checkbox = null;
                    var HardCheckbox:Checkbox = null;

                    menu.insert(1, middlescrollOption = new Checkbox("Middlescroll", "若勾选此项,按键布局将移到中间\n警告:可能与有些歌曲设置冲突,并可能产生巨大的BUG!", "middlescrollOption", null, FlxG.save.data));
                    menu.insert(2, noHitCheckbox = new Checkbox("No Hit Mode", "不要漏掉任何一个音符,否则你就输了!!!", "nh", null, FlxG.save.data));
                    menu.insert(3, mechanicsHitCheckbox = new Checkbox("Mechanics", "启用/禁用 游戏玩法机制\n在这个定制版本里你无法更改此选项", "mechanics", null, FlxG.save.data));
                    menu.insert(4, HardCheckbox = new Checkbox("Super Hard Mode", "启用/禁用 加难模式", "night", null, FlxG.save.data));

                    middlescrollOption.color = 0xFF8A50FF;
                    noHitCheckbox.color = 0xFFC9FEFF;
                    mechanicsHitCheckbox.color = 0xFF8CDBFF;
                    HardCheckbox.color = 0xFFFF4500;

                    menu.members[3].locked = true;
                    menu.members.remove(menu.members[5]); // remove naughtyness
                    
                case "optionsTree.appearance-name":
                    var splashCheckbox:Checkbox = null;
                    //for (i in 1...5) menu.members.remove(menu.members[1]);

                    menu.insert(5, splashCheckbox = new Checkbox("Show Splash", "展示/隐藏 箭头溅射\n开启后即可显示溅射(可能会影响性能)", "splashvis", null, FlxG.save.data));
                    splashCheckbox.color = 0xFF48D1CC;

                    var hudvisCheckbox:Checkbox = null;
                    menu.insert(6, hudvisCheckbox = new Checkbox("HUD Visible", "显示/隐藏 HUD\n关闭后即可隐藏HUD", "hudvis", null, FlxG.save.data));
                    hudvisCheckbox.color = 0xFFFFD700;

                    var fullsCheckbox:Checkbox = null;
                    menu.insert(7, fullsCheckbox = new Checkbox("Fullscreen", "开启/关闭 全屏模式\n开启后即可切换全屏", "fulls", null, FlxG.save.data));
                    fullsCheckbox.color = 0xFFEFC3CA;

                    menu.members[8].suffix = "/Shaders >";
                case "optionsMenu.advanced":
                    menu.members[0].changedCallback = (val:String) -> {
                        var qualitly:Int = Std.parseInt(val);
                        switch (qualitly) {
                            case 0: // LOW
                                set_shaders_low();
                            case 1: // HIGH
                                set_shaders_high();
                        }

                        if (qualitly <= 1) Options.antialiasing = true;
                        menu.members[1].checked = Options.antialiasing;
                        menu.members[2].checked = Options.gameplayShaders;

                        for (member in 0...menu.members.length) 
                            menu.members[member].locked = false;
                        
                        menu.members[5].locked = qualitly <= 1;
                        menu.members[4].locked = qualitly <= 1;

                        var antialiasing = qualitly == 0 ? false : (qualitly == 1 ? true : Options.antialiasing);
                        FlxG.game.stage.quality = (FlxG.enableAntialiasing = antialiasing) ? 0/*BEST*/ : 2/*LOW*/;
                    };

                    var shaderOption = menu.members[3];
                    menu.members.remove(shaderOption);
                    menu.members.insert(4, shaderOption);

                    //menu.members.remove(menu.members[2]); // remove low memory mode
                    //menu.members.remove(menu.members[2]); // remove vram sprites option

                    shaderOption.selectCallback = () -> {
                        menu.members[3].locked = !shaderOption.checked;
                    };

                    menu.add(new TextOption("Specific Shaders ", "更改更高级的着色器选项。", ">", () -> {
                        var spefShadersTree:TreeMenuScreen = new TreeMenuScreen("Specific Shaders", "更改更高级的着色器选项\n\n（HIGH END）指最容易造成卡顿的着色器，\n\n（MEDIUM）指可能造成轻微卡顿的着色器，\n\n（LOW END）指在大多数系统上不会造成问题的着色器。");
                        var highEndText:TextOption = null;
                        spefShadersTree.add(highEndText = new TextOption("High End Shaders ", "", ">", () -> {
                            var intShadersTree:TreeMenuScreen = new TreeMenuScreen("Intensive Shaders", "更改高负载着色器选项\n\n（从最难以运行到最容易运行，自上而下排列）。");
                            intShadersTree.add(new Checkbox("Bloom Effects", "\n启用/禁用 泛光着色器。", "bloom", null, FlxG.save.data));
                            intShadersTree.add(new Checkbox("God Rays Shaders", "\n启用/禁用 曙光着色器。", "godrays", null, FlxG.save.data));
                            intShadersTree.add(new Checkbox("Particles Shaders", "\n启用/禁用 粒子着色器。", "particles", null, FlxG.save.data));
                            intShadersTree.add(new Checkbox("Glitch Shaders", "\n启用/禁用 故障着色器。", "glitch", null, FlxG.save.data));
                            spefShadersTree.parent.addMenu(intShadersTree);

                            for (i => member in intShadersTree.members)
                                member.color = FlxColor.interpolate(0xFFFE2323, 0xFFFFE3E3, i/intShadersTree.members.length);
                        }));
                        highEndText.color = 0xFFFFACAC;
                        var medEndText:TextOption = null;
                        spefShadersTree.add(medEndText = new TextOption("Medium Shaders ", "", ">", () -> {
                            var medShadersTree:TreeMenuScreen = new TreeMenuScreen("Medium Shaders", "更改中端着色器选项\n\n（从最难以运行到最容易运行，自上而下排列）。");
                            medShadersTree.add(new Checkbox("Fog Shaders", "\n启用/禁用 雾效着色器。", "fog", null, FlxG.save.data));
                            medShadersTree.add(new Checkbox("Water Shaders", "\n启用/禁用 水效着色器。", "water", null, FlxG.save.data));
                            medShadersTree.add(new Checkbox("Chromatic Shaders", "\n启用/禁用 色差着色器。", "chromwarp", null, FlxG.save.data));
                            medShadersTree.add(new Checkbox("Warp Shaders", "\n启用/禁用 扭曲着色器。", "warp", null, FlxG.save.data));
                            medShadersTree.add(new Checkbox("Fire Shaders", "\n启用/禁用 火焰着色器。", "fire", null, FlxG.save.data));
                            spefShadersTree.parent.addMenu(medShadersTree);

                            for (i => member in medShadersTree.members)
                                member.color = FlxColor.interpolate(0xFFFFF97D, 0xFFFFFFFF, i/medShadersTree.members.length);
                        }));
                        medEndText.color = 0xFFFFF5AC;
                        var lowEndText:TextOption = null;
                        spefShadersTree.add(lowEndText = new TextOption("Low End Shaders ", "", ">", () -> {
                            var lowShadersTree:TreeMenuScreen = new TreeMenuScreen("Low Shaders", "更改低端着色器选项\n\n（从最难以运行到最容易运行，自上而下排列）。");
                            lowShadersTree.add(new Checkbox("Static Shaders", "\n启用/禁用 静态着色器。", "static", null, FlxG.save.data));
                            lowShadersTree.add(new Checkbox("Pixel Shaders", "\n启用/禁用 像素着色器。", "pixel", null, FlxG.save.data));
                            lowShadersTree.add(new Checkbox("Saturation Shaders", "\n启用/禁用 饱和度着色器。", "saturation", null, FlxG.save.data));
                            lowShadersTree.add(new Checkbox("Impact Shaders", "\n启用/禁用 冲击着色器。", "impact", null, FlxG.save.data));
                            spefShadersTree.parent.addMenu(lowShadersTree);
                            
                            for (i => member in lowShadersTree.members)
                                member.color = FlxColor.interpolate(0xFF88FF5D, 0xFFFFFFFF, i/lowShadersTree.members.length);
                        }));
                        lowEndText.color = 0xFFC2FFAC;
                        menu.parent.addMenu(spefShadersTree);
                    }));

                    menu.members[0].changedCallback(Std.string(Options.quality));
                    shaderOption.selectCallback();
                case "optionsTree.miscellaneous-name":
                    //for (member in 1...5) // get rid of some cne stuff that will mess with the build
                    //    menu.members.remove(menu.members[1]);
                    //if (!FileSystem.exists("dev.txt")) menu.members.shift();
                case "DUSTIN MUSIC OPTIONS":
                    case "CHEAT OPTIONS":
                        var BotPlayCheckbox:Checkbox = null;
                        var BotTextCheckbox:Checkbox = null;
                        var practiseModeCheckbox:Checkbox = null;
                        
                        menu.insert(1, BotPlayCheckbox = new Checkbox("BotPlay", "如果你手没那么巧,直接打开这个功能就行", "botplay", null, FlxG.save.data));
                        menu.insert(2, BotTextCheckbox = new Checkbox("Bot Text", "如果你不想看那奇葩玩意(那个彩色'BOTPLAY'标识)就取消勾选!\n注意!\n1. 这个选项只在Botplay开启时生效\n2. 若关闭此选项,且要录制或直播,请在流媒体中声明是否使用Botplay,以免引起不必要的误会\n(如果你嫌麻烦,就把这个选项开启吧awa)\n3. 建议开启此选项以尊重Botplay传统(PsychEngine默认Botplay是有文字显示的)", "bottextvis", null, FlxG.save.data));
                        menu.insert(3, practiseModeCheckbox = new Checkbox("Practise Mode", "练习模式下你将不会死(删了的原版功能我给你带回来!)", "pre", null, FlxG.save.data));
                        
                        BotPlayCheckbox.color = 0xFFFFEE00;
                        BotTextCheckbox.color = 0xFF00FF15;
                        practiseModeCheckbox.color = 0xFF00FFFF;
                    case "HITBOX OPTIONS":
                        var vanillaHitboxCheckbox:Checkbox = null;
                        var hardModeCheckbox:Checkbox = null;
                        var bigHitboxCheckbox:Checkbox = null;

                        menu.insert(1, vanillaHitboxCheckbox = new Checkbox("Vanilla Hitbox", "打开这个功能后,请不要使用其他Hitbox选项!否则效果可能会叠加,导致Hitbox变得奇怪!\n打开后,Hitbox将会变回Dustin判定(.7),关闭则是CNE判定(1.5),关闭后可使用其他Hitbox选项", "hitb", null, FlxG.save.data));
                        menu.insert(2, bigHitboxCheckbox = new Checkbox("Big Hitbox", "打开这个功能后,请不要使用其他Hitbox选项!否则效果可能会叠加,导致Hitbox变得奇怪!\n判定将乘以2.5倍(仅适用于CNE,请勿开启'Vanilla Hitbox'选项),更大的Hitbox,适合新手!", "bib", null, FlxG.save.data));
                        menu.insert(3, hardModeCheckbox = new Checkbox("Hard Mode", "打开这个功能后,请不要使用其他Hitbox选项!否则效果可能会叠加,导致Hitbox变得奇怪!\n开启后,游戏难度将会提升!(Botplay都玩不过,你更玩不过……)", "ks", null, FlxG.save.data));
                        
                        bigHitboxCheckbox.color = 0xFF7CFC00;
                        hardModeCheckbox.color = 0xFFFF4500;
                        vanillaHitboxCheckbox.color = 0xFFFF7F50;
            }
        }
    }
}