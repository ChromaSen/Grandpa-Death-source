package meta.state.menus;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.MusicBeat.MusicBeatState;
import meta.data.Song;
import meta.data.dependency.Discord;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MainMenuState extends MusicBeatState
{
	public var menuItems:Array<MainMenuItem> = [];
	public var curSelected:Int = -1;
	public var bg:FlxSprite; // the background has been separated for more control
	public var magenta:FlxSprite;
	public var optionShit:Array<String> = ['story', 'freeplay', 'options'];
	public var curDiff:Int=2;

	public var mouse:FlxText;
	public var camFollow:FlxObject;

	// the create 'state'
	override function create()
	{
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if DISCORD_RPC
		Discord.changePresence('MENU SCREEN', 'Main Menu');
		#end

		FlxG.mouse.visible=true;

		// uh
		persistentUpdate = persistentDraw = true;

		// background
		mouse=new FlxText(0,0,0,"Use your mouse to interact with the buttons");
		mouse.setFormat(Paths.font('vcr.ttf'),18,FlxColor.WHITE);
		mouse.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		mouse.setPosition(800,700);
		mouse.alpha=0.7;
		mouse.antialiasing=false;
		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		add(mouse);

		magenta = new FlxSprite(-85).loadGraphic(Paths.image('menus/base/menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		// add the camera
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);


		// create the menu items themselves

		// loop through the menu options
		for (i in 0...optionShit.length)
		{
			var menuItem:MainMenuItem=new MainMenuItem();
			menuItem.frames = Paths.getSparrowAtlas('menus/base/title/MENU/menu_' + optionShit[i]);
			menuItem.ID = i;
			// add the animations in a cool way (real
			menuItem.animation.addByPrefix('idle', "idle", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " selected", 24);
			menuItem.animation.play('idle');
			menuItem.screenCenter(Y);

			menuItem.onAway=function()
			{
				menuItem.animation.play("idle");
			};

			menuItem.onClick=function()
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				menuItem.animation.play("selected");
			};

			menuItem.onOverlap=function()
			{
				if (menuItem.animation.curAnim.name!='selected'){menuItem.animation.play("selected");}
			}

			switch (optionShit[i]){
				case 'story':
					menuItem.x=15;
					menuItem.animation.play("idle");
					menuItem.onClick=function(){
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						persistentUpdate=false;


							PlayState.storyPlaylist=['deadbattle','reaper-rhythm','behold-the-apocalypse'];

							
							PlayState.isStoryMode = true;

							var diffic:String = '-' + CoolUtil.difficultyFromNumber(curDiff).toLowerCase();
							diffic = diffic.replace('-normal', '');

							PlayState.storyDifficulty = curDiff;

							PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
							PlayState.storyWeek = 0;
							PlayState.campaignScore = 0;
							new FlxTimer().start(1,function(tmr:FlxTimer)
							{
								Main.switchState(this,new PlayState());
							});
					}
				case 'freeplay':
					menuItem.animation.play("idle");
					menuItem.x = 350;
					menuItem.onClick=function()
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						//hiiii sorry i need to check the chart works sooooooooooo - gdd
						new FlxTimer().start(0.5,function(tmr:FlxTimer)
						{
							Main.switchState(this,new FreeplayState());
						});
					}
				case 'options':
					menuItem.animation.play("idle");
					menuItem.x=696;
					menuItem.onClick=function()
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						trace('test');
						//and this is because i refuse to play without upscroll and DFJK - gdd
						new FlxTimer().start(0.5,function(tmr:FlxTimer)
						{
							Main.switchState(this,new OptionsMenuState());
						});
					}
					
				
			}
			add(menuItem);
			menuItem.hitbox=Center(menuItem.x,menuItem.y,menuItem.width,menuItem.height,0.85);

			menuItems.push(menuItem);

		}

		// set the camera to actually follow the camera object that was created before
		camFollow.screenCenter();

		FlxG.camera.follow(camFollow, LOCKON, 1.0);


		// from the base game lol

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Forever Engine Legacy v" + Main.gameVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		//
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);

		#if debug
		var positions:Array<Array<Float>>=[];

		for (shit in menuItems)
		{
			positions.push([shit.x,shit.y]);
		}

		for (i in 0...optionShit.length)
		{
			FlxG.watch.addQuick(optionShit[i] + " x and y", positions[i]);
		}

		//im not sorry -gdd
		#end
		if (FlxG.keys.justPressed.FIVE)
			{
				Main.switchState(this, new StoryMenuState());
			}

		if(FlxG.keys.justPressed.ESCAPE){
			Main.switchState(this,new TitleState());
		}

		for (i in 0...menuItems.length)
		{
			var overlapping:Bool=
			(FlxG.mouse.x>=menuItems[i].hitbox.x&&FlxG.mouse.x<=menuItems[i].hitbox.x+menuItems[i].hitbox.width);
			overlapping=overlapping 
			&& 
			(FlxG.mouse.y>=menuItems[i].hitbox.y&&FlxG.mouse.y<=menuItems[i].hitbox.y+menuItems[i].hitbox.height);

			if (curSelected!=i)
			{
				if (overlapping)
				{
					if (curSelected!=i&&menuItems[curSelected]!=null&&menuItems[curSelected].onAway!=null)
						menuItems[curSelected].onAway();

					if (menuItems[i].onOverlap!=null)
					{
						curSelected=i;
						menuItems[i].onOverlap();

						switch(i){
							case 0://s
							menuItems[i].x=-15;
							menuItems[i].y=5.5;			
							case 1://f
							menuItems[i].x=320;
								menuItems[i].y=5.5;
							case 2://o
							menuItems[i].x=676;
								menuItems[i].y=5.5;
						}

						break;
					}
				}
			}
			else if (curSelected!=-1&&!overlapping)
			{
				menuItems[i].onAway();
				curSelected = -1;
				switch(i){
					case 0: //s
						menuItems[i].x=15;
						menuItems[i].y=49.5;
					case 1: //f
					menuItems[i].x=350;
						menuItems[i].y=49.5;
					case 2: //o
					menuItems[i].x=696;
						menuItems[i].y=49.5;
				}
			}
		}

		if (curSelected!=-1&&curSelected<menuItems.length&&menuItems[curSelected]!=null){
			if (FlxG.mouse.justPressed&&menuItems[curSelected].onClick!=null){
				menuItems[curSelected].onClick();
			}
		}

		super.update(elapsed);
		
	}

	var lastCurSelected:Int = 0;


	private function Center(x:Float, y:Float, width:Float, height:Float, scale:Float):FlxRect
	{
		var newWidth:Float = Math.round(width * scale);
		var newHeight:Float = Math.round(height * scale);

		var newX:Float = x + (width - newWidth) / 2;
		var newY:Float = y + (height - newHeight) / 2;

		return FlxRect.get(newX, newY, newWidth, newHeight);
	}


}

class MainMenuItem extends FlxSprite
{
    public var onOverlap:Void->Void;
    public var onClick:Void->Void;
    public var onAway:Void->Void;
    public var hitbox:FlxRect;
}
