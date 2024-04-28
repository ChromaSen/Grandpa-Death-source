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
        lyrics.sort((lyric1,lyric2)->Std.int(lyric1.steps[0]-lyric2.steps[0])); 
        //trace(lyrics);
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
        while (lyrics.length > 0 && lyrics[0].steps[0] <= stepProgression) {
            clearOldText();
            var myLyrics:LyricMeasure=lyrics.shift();
            var myLyricArray:Array<String> = myLyrics.curString.split('/');
            currentDivisionAmount = myLyricArray.length;
            var textPool:Array<FlxText> = [];
            for (text in myLyricArray) {
                var newText:FlxText = new FlxText(0,0,0,text+"\n");
                newText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                newText.antialiasing = false;
                newText.scrollFactor.set();
                newText.borderSize=1.5;
                add(newText);
            }
            //trace(members);

            currentFocusedLyric = myLyrics;
            lyrics.splice(lyrics.indexOf(myLyrics),1);
        }

        if (currentFocusedLyric != null) {
            var mySteps:Array<Int>=currentFocusedLyric.steps.map(Std.int);
            mySteps.sort((a,b)->a-b); 

            var totalTextLength = 0;
            for (text in members) 
                totalTextLength+=Std.int(text.width);
            
            var xpos=FlxG.width/2-totalTextLength/2;
            for (text in members){
                text.x=xpos;
                text.y = 534;
                text.scale.set(1.5,1.5);
                text.color = FlxColor.fromRGB(255, 255, 255);
                xpos += text.width;
            }

           var curDivision:Int = 0;
           while(curDivision<mySteps.length&&stepProgression>=mySteps[curDivision]){
               curDivision++;
           }

           if (curDivision < currentDivisionAmount&&members[curDivision]!= null){
                var highlightedLyric:FlxText = members[curDivision];
                highlightedLyric.color = FlxColor.RED;
                highlightedLyric.y -= 4;
            } else if (curDivision >= currentDivisionAmount) {
                clearOldText();
            }
        
       }

   }

   public function clearOldText() {
       // delete old text
       if (this.members.length > 0) {
           this.forEach(function(textMember:FlxText){
           if (textMember != null) 
               textMember.destroy();
           });
       }
       clear();
       currentFocusedLyric = null;
   }
}

