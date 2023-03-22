package meta.state;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import meta.*;
import gameObjects.Boyfriend;
import gameObjects.Character;
import Sys;
import meta.state.menus.MainMenuState;

/**
	*DEBUG MODE
 */

 //PLEASE NOTE THIS *MIGHT* BREAK AS I PRETTY MUCH STRAIGHT UP YOINKED THIS FROM FUNKIN SOURCE
 //IF IT DOES BREAK THEN I'M SORRY BUT IF YOU'RE USING THIS YOU SHOULD KNOW WHAT YOU'RE DOING
 //SO YEAH, HAVE FUN
 //HOW THE FUCK DID FOREVER GO THIS LONG WITHOUT THIS? WHAT THE FUCK WERE THEY USING FOR OFFSETS??

 //HOW TO IMPLEMENT:
 //1. Put this file in source/meta/state
 //2. Move over to playState.hx and implement a way to get to this state (it's not hard)
 //3. when calling the state, pass in the animation you want to debug as a string (tip: set it to the current BF or dadOpponent to save you rebuilding the game every time)
 //   also if you're debugging the BF, set isDad to false.
 //4. You're good to go! 

 //HOW TO USE:
 //1. Use W and S to cycle through the animations
 //2. Use the arrow keys to change the offsets
 //3. Use space to replay the current animation
 //4. Use Z to toggle the visibility of the idle ghost. Extremely useful for lining up your offsets. (i made this bit myself!!)
 //5. Use E and Q to zoom in and out.
 //6. Use IJKL to move the camera around.
 //7. Once you're done, press ENTER to save the offsets to the character's offsets file. (this bit is also mine)

 //Ported and modified for Forever Engine 0.3 by GDD.
class AnimationDebug extends FlxState
{
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;
	var idleOnionDad:Character;
	var idleOnionBf:Boyfriend;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		//change the below line if you're debugging different sides, isDad = false means you're debugging the player
		isDad = true;

		if (isDad)
		{
			dad = new Character().setCharacter(0, 0, daAnim);
			idleOnionDad = new Character().setCharacter(0, 0, daAnim);
			dad.screenCenter();
			idleOnionDad.screenCenter();
			dad.debugMode = true;
			idleOnionDad.debugMode = true;
			idleOnionDad.alpha = 0.5;
			add(dad);
			add(idleOnionDad);

			char = dad;
			dad.flipX = true;
			idleOnionDad.flipX = true;
			idleOnionDad.playAnim('idle');
		}
		else
		{
			bf = new Boyfriend();
			idleOnionBf = new Boyfriend();
			bf.setCharacter(0, 0, daAnim);
			bf.screenCenter();
			idleOnionBf.setCharacter(0, 0, daAnim);
			idleOnionBf.screenCenter();
			bf.debugMode = true;
			idleOnionBf.debugMode = true;
			idleOnionBf.alpha = 0.5;
			add(bf);
			add(idleOnionBf);

			char = bf;
			bf.flipX = true;
			idleOnionBf.flipX = true;
			idleOnionBf.playAnim('idle');
		}

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (FlxG.keys.justPressed.Z)
		{
			if (isDad)
				idleOnionDad.visible = !idleOnionDad.visible;
			else
				idleOnionBf.visible = !idleOnionBf.visible;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			saveOffsets();
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			Main.switchState(this, new MainMenuState());
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		super.update(elapsed);
	}

	function saveOffsets()
	{
		//should be formatted like this:
		//[character]Offsets.txt
		//animName value1 value2
		//animName value1 value2

		var curChar = char;
		var fileString = "";
		var file = sys.io.File.write("assets/images/characters/" + curChar.curCharacter + "Offsets.txt", false);

		//now that we know the file exists, we can format everything
		for (anim => offsets in curChar.animOffsets)
		{
			fileString += anim + " " + offsets[0] + " " + offsets[1] + "\n";
		}

		trace("saving offsets: \n" + fileString);

		//now we can write to the file
		file.writeString(fileString);

		trace("offsets saved! :D");

		//clean up after ourselves
		file.close();

		trace("file closed, all done! :D");

	}
}
