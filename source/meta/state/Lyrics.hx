package meta.state;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Json;
import haxe.ds.Map;
import meta.state.PlayState;
import sys.io.File;

using StringTools;

//initial code by yoshubs
//slightly optimized (hopefully) and small feature was added

typedef LyricMeasure = {
    var steps:Array<Float>; 
    var curString:String;
}
class Lyrics extends FlxTypedGroup<FlxText> {
    static var cachedLyrics:Map<String, Array<LyricMeasure>>=new Map();
    public static function parseLyrics(song:String){

    var songKey = song.toLowerCase();
    if (cachedLyrics.exists(songKey)) {
        return cachedLyrics.get(songKey);
    }
    var lyricsFile = File.getContent(Paths.songJson(song.toLowerCase(), 'lyrics')).trim();
        while (!lyricsFile.endsWith("}"))
            lyricsFile = lyricsFile.substr(0, lyricsFile.length - 1);

        var lyricsList:Array<LyricMeasure> = cast Json.parse(lyricsFile).lyrics;
        return lyricsList;
        return null;
    }

    public var lyrics:Array<LyricMeasure>;
    public var stepProgression:Float = 0;
    public function new(lyrics:Array<LyricMeasure>){
        this.lyrics=lyrics;
        lyrics.sort((lyric1,lyric2)->lyric1.steps[0]<lyric2.steps[0]?-1:1);
        trace(lyrics);
        super();
    }

    override public function update(elapsed:Float) {
        if (PlayState.instance.curStep > stepProgression) {
            stepProgression = PlayState.instance.curStep;
            updateLyrics();
        }
        super.update(elapsed);
    }

    public var currentFocusedLyric:LyricMeasure;
    public var currentDivisionAmount:Int = 0;
    public function updateLyrics() {
        while (lyrics.length > 0 && lyrics[0] != null && lyrics[0].steps[0] <= stepProgression) {
            clearOldText();
            var myLyrics:LyricMeasure=lyrics.shift();
            var myLyricArray:Array<String> = myLyrics.curString.split('/');
            currentDivisionAmount = myLyricArray.length;
            var textPool:Array<FlxText> = [];
            for (i in 0...myLyricArray.length){
                var text:FlxText;
                if (i<members.length){
                    text=members[i];
                    text.text=myLyricArray[i] + "\n";
                } else {
                    text = new FlxText(0, 0, FlxG.width, myLyricArray[i] + "\n");
                    text.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                    text.antialiasing = false;
                    text.scrollFactor.set();
                    text.scale.set(1.5,1.5);
                    add(text);
                    textPool.push(text);
                }
            }
            trace(members);
            for (i in myLyricArray.length...members.length){
                textPool.push(members[i]);
                remove(members[i],true);
            }

            currentFocusedLyric = myLyrics;
        }

        if (currentFocusedLyric != null) {
            var mySteps:Array<Float> = currentFocusedLyric.steps;
            mySteps.sort((step,otherStep)->step<otherStep?-1:1);
            // reset all lyrics
            var totalTextLength:Float = 0;
            for (text in members) totalTextLength += text.width;

            for (i in 0...members.length) {
                var text:FlxText = members[i];
                text.x = FlxG.width/2-totalTextLength/2+(i>0?members[i-1].x+members[i-1].width:0);
                text.y = 534;
                text.color = FlxColor.fromRGB(255, 255, 255);
            }

            var curDivision:Int = 0;
            for (i in 0...mySteps.length) {
                if (stepProgression >= mySteps[i]) {
                    curDivision = i;
                    // break;
                }
            }

            if (curDivision < currentDivisionAmount) {
                members[curDivision].color = FlxColor.RED;
                members[curDivision].y -= 4;
            } else if (curDivision >= currentDivisionAmount) {
                clearOldText();
            }
        }

    }

    public function clearOldText() {
        // delete old text
        var textPool:Array<FlxText> = [];
        for (text in members) {
            textPool.push(text);
            remove(text, true);
        }
        currentFocusedLyric = null;
    }
}

