package meta.state;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import gameObjects.Character;
import flixel.addons.display.FlxGridOverlay;
import flixel.FlxSprite;
import meta.state.menus.MainMenuState;


class TestState extends FlxState
{
    var text:FlxText;
    var grampsGhost:Character;
    var grampsHead:Character;
    var grampsBody:Character;


    //TODO:
    /*
    * spawn gramps ghost
    * figure out a way to move grampsHead and grampsBody independently (wasd and arrow keys??)
    * don't use this until offsets are done
    * shit more stuff probably it's like 3 in the morning
    * i miss chroma. :(
    */

    override public function create()
    {
        super.create();

        FlxG.camera.zoom = 0.5;

        var gridBG:FlxSprite = FlxGridOverlay.create(100, 100);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

        grampsHead = new Character().setCharacter(0, 1000, "gramps-head");
        grampsBody = new Character().setCharacter(grampsHead.x + 83, grampsHead.y + 481, "gramps-body");
        

        add(grampsBody);
        add(grampsHead);

        grampsGhost = new Character().setCharacter(0, 1000, "gramps");
        grampsGhost.alpha = 0.5;
        grampsGhost.color = 0xFF00AF00
        add(grampsGhost);

        text = new FlxText(FlxG.width * 0.5, FlxG.height, FlxG.width, 'HEAD XY: ${grampsHead.x}, ${grampsHead.y} \nBODY XY: ${grampsBody.x}, ${grampsBody.y}', 32);
        add(text);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var multiplier = 1;

        if (FlxG.keys.pressed.SHIFT)
            multiplier = 10;

        if (FlxG.keys.justPressed.W)
        {
            grampsHead.y -= 1 * multiplier;
        }

        if (FlxG.keys.justPressed.S)
        {
            grampsHead.y += 1 * multiplier;
        }

        if (FlxG.keys.justPressed.A)
        {
            grampsHead.x -= 1 * multiplier;
        }

        if (FlxG.keys.justPressed.D)
        {
            grampsHead.x += 1 * multiplier;
        }

        if (FlxG.keys.justPressed.UP)
        {
            grampsBody.y -= 1 * multiplier;
        }

        if (FlxG.keys.justPressed.DOWN)
        {
            grampsBody.y += 1 * multiplier;
        }

        if (FlxG.keys.justPressed.LEFT)
        {
            grampsBody.x -= 1 * multiplier;
        }

        if (FlxG.keys.justPressed.RIGHT)
        {
            grampsBody.x += 1 * multiplier;
        }

        if (FlxG.keys.pressed.I)
        {
            FlxG.camera.y -= 1;
        }

        if (FlxG.keys.pressed.K)
        {
            FlxG.camera.y += 1;
        }

        if (FlxG.keys.pressed.J)
        {
            FlxG.camera.x -= 1;
        }

        if (FlxG.keys.pressed.L)
        {
            FlxG.camera.x += 1;
        }

        if (FlxG.keys.pressed.U)
        {
            FlxG.camera.zoom -= 0.01;
        }

        if (FlxG.keys.pressed.O)
        {
            FlxG.camera.zoom += 0.01;
        }

        updateText();

        if (FlxG.keys.justPressed.Z)
        {
            grampsGhost.visible = !grampsGhost.visible;
        }

        if (FlxG.keys.justPressed.X)
        {
            grampsHead.visible = !grampsHead.visible;
        }

        if (FlxG.keys.justPressed.C)
        {
            grampsBody.visible = !grampsBody.visible;
        }

        if (FlxG.keys.justPressed.V)
        {
            text.visible = !text.visible;
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            Main.switchState(this, new MainMenuState());
        }
        
    }

    function updateText()
    {
        text.text = 'HEAD XY: ${grampsHead.x}, ${grampsHead.y} \nBODY XY: ${grampsBody.x}, ${grampsBody.y}';

        //get the XY difference between the head and body
        var xDiff:Float = grampsHead.x - grampsBody.x;
        var yDiff:Float = grampsHead.y - grampsBody.y;

        //get the offset of the head
        var headOffsetX:Float = 0 + grampsHead.x;
        var headOffsetY:Float = 1000 + grampsHead.y;

        //get the offset of the body
        var bodyOffsetX:Float = 83 + grampsBody.x;
        var bodyOffsetY:Float = 1481 + grampsBody.y;

        text.text += '\n\nDIFFERENCE: ${xDiff}, ${yDiff}';
        text.text += '\n\nHEAD OFFSET: ${headOffsetX}, ${headOffsetY}';
        text.text += '\nBODY OFFSET: ${bodyOffsetX}, ${bodyOffsetY}';
    }
}