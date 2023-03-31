package meta;

import lime.utils.Assets;
import meta.state.PlayState;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

using StringTools;

#if sys
import sys.FileSystem;
#end

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static var difficultyLength = difficultyArray.length;

	public static function difficultyFromNumber(number:Int):String
	{
		return difficultyArray[number];
	}

	public static function dashToSpace(string:String):String
	{
		return string.replace("-", " ");
	}

	public static function spaceToDash(string:String):String
	{
		return string.replace(" ", "-");
	}

	public static function swapSpaceDash(string:String):String
	{
		return StringTools.contains(string, '-') ? dashToSpace(string) : spaceToDash(string);
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function getOffsetsFromTxt(path:String):Array<Array<String>>
	{
		var fullText:String = Assets.getText(path);

		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray)
			swagOffsets.push(i.split(' '));

		return swagOffsets;
	}

	public static function returnAssetsLibrary(library:String, ?subDir:String = 'assets/images'):Array<String>
	{
		var libraryArray:Array<String> = [];

		#if sys
		var unfilteredLibrary = FileSystem.readDirectory('$subDir/$library');

		for (folder in unfilteredLibrary)
		{
			if (!folder.contains('.'))
				libraryArray.push(folder);
		}
		trace(libraryArray);
		#end

		return libraryArray;
	}

	public static function getAnimsFromTxt(path:String):Array<Array<String>>
	{
		var fullText:String = Assets.getText(path);

		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagOffsets.push(i.split('--'));
		}

		return swagOffsets;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	/**
	 * Gets the most frequent colour in a health icon.
	 * @param char The character to get the icon for.
	 * @return The most frequent FlxColor in the icon.
	 */
	 public static function getDominantIconColour(char:String)
	{
		//start by cleaning up the char name so it matches the file name, getting rid of any hyphens and whatever comes after them
		/*if (char.contains('-'))
			char = char.split('-')[0];*/ //unneeded probably
			
		//grab the icon's bitmapdata
		var iconBitmapData:BitmapData = BitmapData.fromFile('assets/images/icons/icon-$char.png');
		//set up a dictionary to store the colours and their frequencies
		var colourDict:Map<Int, Int> = new Map<Int, Int>();
		//loop through the icon's pixels while ignoring any black or transparent pixels
		for (x in 0...iconBitmapData.width)
		{
			for (y in 0...iconBitmapData.height)
			{
				var pixelColour:Int = iconBitmapData.getPixel32(x, y);
				if (pixelColour != 0 && pixelColour != 0xFF000000)
				{
					//if the colour is already in the dictionary, increment its frequency
					if (colourDict.exists(pixelColour))
					{
						colourDict.set(pixelColour, colourDict.get(pixelColour) + 1);
					}
					//if the colour isn't in the dictionary, add it with a frequency of 1
					else
					{
						colourDict.set(pixelColour, 1);
					}
				}
			}
		}
		//set up vars for the most frequent colour and its frequency
		var mostFrequentColour:Int = 0;
		var mostFrequentColourFrequency:Int = 0;
		//loop through the dictionary
		for (colour in colourDict.keys())
		{
			//if the current colour's frequency is higher than the most frequent colour's frequency, set the most frequent colour to the current colour
			if (colourDict.get(colour) > mostFrequentColourFrequency)
			{
				mostFrequentColour = colour;
				mostFrequentColourFrequency = colourDict.get(colour);
			}
		}
		//throw in some traces for debugging
		trace('$char most frequent colour: $mostFrequentColour');
		trace('$char most frequent colour frequency: $mostFrequentColourFrequency');
		//convert the most frequent colour to an FlxColor
		var dominantColour:FlxColor = FlxColor.fromInt(mostFrequentColour);
		//return the most frequent colour
		return dominantColour;
	}
}
