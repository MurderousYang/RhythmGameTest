//i can feel the chatGPT coming inside me!!~

//context: i literally just used ChatGPT to make this shitty rhythm game lmao

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;
import openfl.utils.Timer;
import openfl.text.TextField;
import openfl.ui.Keyboard;

class RhythmGame extends Sprite {

    var timer.Timer;
    var beat: Int = 0;
    var score: Int = 0;
    var combo: Int = 0;
    var comboBreaks: Int = 0;
    var perfectHits: Int = 0;
    var greatHits: Int = 0;
    var goodHits: Int = 0;
    var missHits: Int = 0;
    var beatShapes: Array < Shapes >;
    var scoreBar: Sprite;
    var comboTextField: TextField;
    var scoreTextField: TextField;
    var accuracyTextField: TextField;
    var ratingTextField: TextField;
    var hitBoxSize: Float = 500;
    var keysControls: Array < String > = ["A",
        "S",
        "D",
        "F"]; // custom keys controls, change your shit here

    public function new() {
        super();

        // initializes multitouch input
        Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

        // create hitbox shape and add to display list
        var hitBox = new Shape();
        hitBox.graphics.beginFill(0xFF0000); // my favourite color, red!!!!!
        hitBox.graphics.drawRect(0, 0, hitBoxSize, hitBoxSize);
        hitBox.graphics.endFill();
        hitBox.x = (stage.stageWidth - hitBoxSize) / 2;
        hitBox.y = stage.stageHeight - hitBoxSize * 2;
        addChild(hitBox);

        // create beat shapes and add to display list
        beatShapes = new Array < Shape > ();
        for (i in 0...keysControls.length) {

            var shape = new Shape();
            shape.graphics.beginFill(0x00FF00); //green shit
            shape.graphics.drawCircle(0, 0, 50);
            shape.graphics.endFill();
            shape.x = i * 150 + 75;
            shape.y = stage.stageHeight / 2;
            addChild(shape);
            beatShapes.push(shape)
        }

        //create score bar and add to display list
        scoreBar = new Sprite();
        scoreBar.graphics.beginFill(0xFFFFFF); // white like your fucking dick's tip
        scoreBar.graphics.drawRect(0, 0, stage.stageWidth, 50);
        scoreBar.graphics.endFill();
        scoreBar.y = 20;
        addChild(scoreBar);

        //create combo text field
        comboTextField = new TextField();
        comboTextField.textColor = 0x000000; //black just like me :pensive:
        comboTextField.selectable = false;
        comboTextField.width = 100;
        comboTextField.y = 5;
        scoreBar.addChild(comboTextField);

        //create accuracy text field
        accuracyTextField = new TextField();
        accuracyTextField.textColor = 0x000000; //BLACK NI- nah jk i'm not gonna say the n word lmao
        accuracyTextField.selectable = false;
        accuracyTextField.width = 100;
        accuracyTextField.x = (stage.stageWidth - accuracyTextField.width) / 2;
        accuracyTextField.y = 5;
        scoreBar.addChild(accuracyTextField);

        //create rating text field
        ratingTextField = new TextField();
        ratingTextField.textColor = 0x000000; //okay i need to stop with these comments :sob: anyways bye bitches
        ratingTextField.selectable = false;
        ratingTextField.width = 100;
        ratingTextField.x = (stage.stageWidth - ratingTextField.wdith) / 2;
        ratingTextField.y = 25;
        scoreBar.addChild(ratingTextField);

        //create timer to play beats
        timer = new Timer(500);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        timer.start();

        //listen for key events
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    function onTimer(event: Event) {
        beat++;
        beat %= keysControls.length;
        updateBeats();
    }

    // update beat circles colors based on current beat
    function updateBeats() {
        for (i in 0...keysControls.length) {
            var shape = beatShapes[i];
            if (i == beat) {
                shape.alpha = 1.0;
            } else {
                shape.alpha = 0.5;
            }

        }
    }

    //called when the user presses a key
    function onKeyDown(event: KeyboardEvent) {
        var key = event.keyCode.toString();
        var index = keysControls.indexOf(key);
        if (index != -1) {
            handleHit(index);
        }
    }

    //handle a hit on the beat cicrle
    function handleHit(index: Int) {
        var shape = beatShapes[index];
        var hitAccuracy = Math.abs(shape.y - hitBox.y) / (stage.stageHeight / 2 - hitBoxSize);
        if (hitAccuracy < 0.05) {
            score += 100;
            combo++;
            perfectHits++;
        } else if (hitAccuracy < 0.1) {
            score += 50;
            combo++;
            greatHits++;
        } else if (hitAccuracy < 0.15) {
            score += 25;
            combo++;
            goodHits++;
        } else {
            combo = 0;
            missHits++;
        }
        updateScoreBar();
    }

    //update the score bar field
    function updateScoreBar() {
        var comboBreakText = "";
        if (comboBreaks > 0) {
            comboBreakText = "-" + comboBreaks.toString() + " Combo Breaks ";
        }
        comboTextField.text = "Combo: " + combo.toString() + " Combo Breaks ";
        scoreTextField.text = "Score: " + score.toString();
        var accuracy = ((perfectHits * 2 + greatHits) * 100 / (perfectHits + greatHits + goodHits + missHits));
        accuracyTextField.text = "Accuracy: " + accuracy.toString() + "%";
        if (accuracy == 100) {
            ratingTextField.text = "Perfect!";
        } else if (accuracy >= 90) {
            ratingTextField.text = "Great";
        } else if (accuracy >= 80) {
            ratingTextField.text = "Good";
        } else {
            ratingTextField.text = "Miss";
        }
    }

    //called when the user breaks the combo
    function breakCombo() {
        comboBreaks++;
        combo = 0;
        updateScoreBar();
    }

}