package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import meta.state.PlayState;
import openfl.display.GraphicsShader;
import sys.io.File;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;


	//grandpa death old hell
	var oldback:FlxSprite;
	var oldbackground:FlxSprite;
	var oldlava:FlxSprite;
	var oldfloor:FlxSprite;
	var oldcages:FlxSprite;
	var oldcage:FlxSprite;
	var overlay:FlxSprite;
	//

	//granpappy death new hell
	var carlos:FlxSprite; //left down right down left down right down left down right down left down right down left down right down
	var dumbfucks:FlxSprite;
	public var dumbFUCKS:Array<FlxSprite>=[];

	public var cages:FlxSprite;
	public var cave:FlxSprite;
	public var lava:FlxSprite;
	public var island:FlxSprite;

	//gramps
	public var sky:FlxSprite;
	public var clouds:FlxSprite;
	public var mountains:FlxSprite;
	public var ground:FlxSprite;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				default:
					curStage = 'hell';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		var left:Int=-180;
		var right:Int=-200;
		//
		switch (curStage)
		{
			case 'hell':
				//I FUCKING HATE STAGE IMPLEMENTATION -gdd
				//TODOS:
				//bring camera up, it's focusing too low currently
				//(potentially) fix caves if they're shit after cam fix
				//add parallax? - tinb
				curStage = 'hell';
				PlayState.defaultCamZoom = 0.6;

				sky = new FlxSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/sky')); //i could probably get away with just blowing this up massively but whatever
				sky.setPosition(-541.7, -383.1);
				add(sky);


				cages = new FlxSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/cages'));
				cages.setPosition(-331.5, -97.95);
				cages.updateHitbox();
				cages.scrollFactor.set(0.5, 1);
				add(cages);

				cave = new FlxSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/cave'));
				cave.screenCenter(X);
				cave.x = cave.x - 200; //sorry i didn't know else to do it lol
				cave.y = -550;
				cave.updateHitbox();
				cave.scrollFactor.set(0.5, 1);
				add(cave);

				lava = new FlxSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/lava'));
				lava.updateHitbox();
				lava.scrollFactor.set(0.85, 1);
				lava.setPosition(-250, 376.1);
				add(lava);

				island = new FlxSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/island'));
				island.setPosition(-100, 606.1);
				island.updateHitbox();
				island.scrollFactor.set(0.85, 1);
				add(island);

				carlos = new FlxSprite();
				carlos.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/carlos'); //AWW RIIIIIIIIIIIIGHT
				carlos.setPosition(1537.2, -59.65);
				carlos.animation.addByPrefix('idle', 'carlos instance 1000');
				add(carlos);
				carlos.animation.play('idle');

				var ground = new FlxSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/ground'));
				ground.setPosition(-776.9, 86.4);
				add(ground);

				for(i in 0...4){
					dumbfucks=new FlxSprite();
					dumbfucks.frames=Paths.getSparrowAtlas('backgrounds/hell/skelehenchman');
					dumbfucks.animation.addByPrefix("idle","henchmanbopper",24,true);
					dumbfucks.animation.play("idle");
					dumbfucks.updateHitbox();

					if (i==2||i==3){
						dumbfucks.flipX=true;
					}

					switch(i)
					{
						case 0:dumbfucks.setPosition(-500,680);
						case 1:dumbfucks.setPosition(100,880);
						case 2:dumbfucks.setPosition(1400,690);
						case 3:dumbfucks.setPosition(800,880);
					}

					foreground.add(dumbfucks);
					dumbFUCKS.push(dumbfucks);
				}		
			case 'gramps':
				curStage='gramps';
				PlayState.defaultCamZoom=0.8;
				sky=new FlxSprite().loadGraphic(Paths.image("backgrounds/gramps/sky"));
				sky.updateHitbox();
				sky.scale.set(1.05,1.05);
				sky.screenCenter();
				sky.setPosition(-827,-241);
				sky.antialiasing=false;
				add(sky);
				clouds=new FlxSprite().loadGraphic(Paths.image("backgrounds/gramps/clouds"));
				clouds.updateHitbox();
				clouds.screenCenter();
				clouds.setPosition(-1900,-107.5);
				clouds.antialiasing=false;
				add(clouds);
				mountains=new FlxSprite().loadGraphic(Paths.image("backgrounds/gramps/mountains"));
				mountains.updateHitbox();
				mountains.scale.set(1.1,1.1);
				mountains.screenCenter();
				mountains.setPosition(-813,192);
				mountains.antialiasing=false;
				add(mountains);
				ground=new FlxSprite().loadGraphic(Paths.image("backgrounds/gramps/ground"));
				ground.updateHitbox();
				ground.screenCenter();
				ground.setPosition(-771.5,892.5);
				ground.antialiasing=false;
				add(ground);
			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'highway':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray)
		{
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
					/*
						if (isStoryMode)
						{
							camPos.x += 600;
							tweenCamIn();
					}*/
					/*
						case 'spirit':
							var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
							evilTrail.changeValuesEnabled(false, false, false, false);
							add(evilTrail);
					 */
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'hell':
				boyfriend.setPosition(1029.7, 709.1);
				dad.setPosition(88.05,dad.curCharacter=='gd-true'?289.1:429.1);
				if(dad.curCharacter=='grandpadeath'){
					dad.setPosition(178.05,389.1);
					trace('gramper');
				}
				trace(dad.getPosition());
				gf.setPosition(538,250);
			case 'highway':
				boyfriend.y -= 220;
				boyfriend.x += 260;
			case 'gramps':
				dad.setPosition(-740,234);
				boyfriend.setPosition(1050,740);
				gf.visible=false; //from now
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'hell':
				carlos.animation.play('idle', true); //up down left down right left down right down side to side

			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
