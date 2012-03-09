/**
 * Original Visualizr AS component was developed by Ronny Welter. 
 * 
 * See http://nocreativity.com/blog/visualizr-source for the original example and source code.
 *
 * Adopted and converted to UIComponent by Taras Novak (www.randomfractals.com)
 **/
package com.demo.graphics 
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.profiler.*;
    import flash.system.*;
    import flash.utils.*;
    
    import mx.core.UIComponent;
    
    public class Visualizr extends UIComponent 
    {
    public static var MIN_WIDTH:Number = 320;
    public static var MIN_HEIGHT:Number = 160;

        //set up the bitmap, the bitmapdata, and the bytearray
        private var scalerBitmapData:BitmapData;
        private var scalerBitmap:Bitmap;
        private var soundDataArray:ByteArray;
        
        private var drawerBitmapData:BitmapData;
        private var drawerBitmap:Bitmap;
        
        private var holder:Sprite;
        private var rotor:Sprite;

        //fx
        private var blurFilter:BlurFilter;
        private var hider:Sprite;

        //additional stuff to glue it together
        private var color:Array;
        private var newcolor:String;
        private var newcolor2:String;
        private var rotationJump:Number;
        private var scaleChange:Number;
        
        //settingsstuff
        private var beginX:Number;
        private var beginY:Number;
        
        private var transparent:Boolean = true;
                
        public function Visualizr():void 
        {
            super();
            
            soundDataArray = new ByteArray();
            
            //all the values you want to be able to show up in the color codes
            color = new Array(0xFF0033,0x33FF00,0x3300FF,0x00EEFF,0xFFFF00);                        
            setTimeout(getColor, 800);                        
            
            rotationJump = 1.5;
            scaleChange = 1.08;            
            this.width = 420;
            this.height = 400;            
        }
        
        private function getColor():void 
        {
            var newpos:String = color[Math.floor(Math.random()*color.length)]; 
            newcolor != newpos ? newcolor = newpos : getColor();             
        }
        
        //-------- UIComponent Methods -----------------------
        
        override protected function measure():void 
        {
        super.measure();    
        
      this.measuredWidth = 420;
      this.measuredMinWidth = Visualizr.MIN_WIDTH;
      
      this.measuredHeight = 300;
      this.measuredMinHeight = Visualizr.MIN_HEIGHT;
    }
        
         override protected function createChildren():void
        {                        
            super.createChildren();
            
            holder = new Sprite();
            hider = new Sprite();
            rotor = new Sprite();

            //set up those filters!
            blurFilter = new BlurFilter(4, 4, 4);
                        
            scalerBitmapData = new BitmapData(this.width, this.height, 
                this.transparent, 0x000000);
            scalerBitmap = new Bitmap(scalerBitmapData);
            scalerBitmap.x = -scalerBitmap.width/2;
            scalerBitmap.y = -scalerBitmap.height/2;
            
            rotor.x = scalerBitmap.width/2;
            rotor.y = scalerBitmap.height/2;                                    
            rotor.addChild(scalerBitmap);
            
            holder.addChild(rotor);
            
            drawerBitmapData = new BitmapData(this.width, this.height, 
                this.transparent, 0x000000);
            drawerBitmap = new Bitmap(drawerBitmapData);
            
            holder.addChild(hider);
            holder.addChild(drawerBitmap);
            
            addChild(holder);
                        
            // add event handlers
            addEventListener(Event.ENTER_FRAME,loop);
            addEventListener(MouseEvent.MOUSE_DOWN, startTheCount);
            addEventListener(MouseEvent.CLICK, changeTheColor);
            addEventListener(KeyboardEvent.KEY_DOWN, toggleFullScreen);                        
            
            doLayout();
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
        {            
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if(isNaN(unscaledWidth) || isNaN(unscaledHeight)) 
            {
                return;
            }
            
            resizeBitmaps(unscaledWidth, unscaledHeight);
        }
        
        //------------ Rendering -----------------------------
                
        private function doLayout():void
        {    
            scalerBitmap.x = -scalerBitmap.width/2;
            scalerBitmap.y = -scalerBitmap.height/2;
            holder.x = 0;//(this.stage.stageWidth - sizex)/2;
            holder.y = 0;//(this.stage.stageHeight - sizey)/2;
        }
                
        private function resizeBitmaps(newWidth:uint, newHeight:uint):void
        {
            var tempBitmapData:BitmapData;
            
            if (newWidth != scalerBitmapData.width || newHeight != scalerBitmapData.height)
            {
                // create new bitmap
                tempBitmapData = scalerBitmapData;
                scalerBitmapData = new BitmapData(newWidth, newHeight, this.transparent, 0x000000);
                tempBitmapData.dispose();
                scalerBitmap.bitmapData = scalerBitmapData;
                scalerBitmap.width = newWidth;
                scalerBitmap.height = newHeight;
                scalerBitmap.x = -scalerBitmap.width/2;
                scalerBitmap.y = -scalerBitmap.height/2;
                rotor.x = scalerBitmap.width/2;
                rotor.y = scalerBitmap.height/2;                                                    
            }
            
            if (newWidth != drawerBitmapData.width || newHeight != drawerBitmapData.height)
            {            
                tempBitmapData = drawerBitmapData;
                drawerBitmapData = new BitmapData(newWidth, newHeight, this.transparent, 0x000000);
                tempBitmapData.dispose();
                drawerBitmap.bitmapData = drawerBitmapData;
                drawerBitmap.width = newWidth;
                drawerBitmap.height = newHeight;
            }            
        }
                
        private function loop(e:Event):void 
        {                        
            if (!enabled)
            {
                // don't update
                return;
            }
            
            //let's see if we can get some low, mid and high tones...        
            var array:Array = new Array();
            SoundMixer.computeSpectrum(soundDataArray, true, 85);
            for(var j:uint=0; j<255; j+=85)
            {
                soundDataArray.position = j;
                array.push(soundDataArray.readFloat());
            }
        
            if (array[0]>1)
            {
                rotationJump *= -1;
                scaleChange = array[0];
            }
            else if (array[0]<0.5)
            {
                scaleChange = array[0]*1.7;
            }
    
            //scaleChange = Math.abs(array[1]);
            
            var a:Number= Math.round(array[2]);
            if(a != 0 && a > 51200000000000000000000000000000)
            {
                getColor();
                trace(a);
            }
                        
            //let's draw some stuff            
            hider.graphics.clear();
            hider.graphics.lineStyle(1,uint(newcolor));
            SoundMixer.computeSpectrum(soundDataArray);                //FREAKING COOLNESS!! I TELL YOU!!!

            //left
            var cWidth:Number;
            var cHeight:Number;
            var soundData:Number;

            //draw 1 circle
            for (var i:Number = 0; i<360; i++) 
            {
                cWidth = Math.cos(i*Math.PI/180);
                cHeight = Math.sin(i*Math.PI/180);
                soundData = soundDataArray[i]/2;
                if (i==0) 
                {
                    hider.graphics.moveTo(cWidth*soundData + this.width/2 + 50, cHeight*soundData + this.height/2);
                }
                if (soundData>60) 
                {
                    hider.graphics.lineTo(cWidth*soundData + this.width/2, cHeight*soundData + this.height/2);
                }
            }

            //make the bitmap grow
            // This is where the magic happens
            
            rotor.scaleX = scaleChange;
            rotor.scaleY = scaleChange;
            
            rotor.rotation = rotationJump;
            
            doLayout();
            rotor.visible = true;
            
            drawerBitmap.visible = false;
            drawerBitmapData.draw(holder);
            drawerBitmap.visible = true;
            
            doLayout();
            
            drawerBitmapData.applyFilter(drawerBitmapData, drawerBitmapData.rect, new Point(0,0), blurFilter);
            
            rotor.visible=false;
            scalerBitmapData.draw(holder);
            
            rotor.rotation = rotationJump;
                        
            // This was where the magic happens                        
        }
                
        // -------- Event Handlers -------------------------------- 
                        
        private function toggleFullScreen(e:KeyboardEvent):void
        {
            if (e.keyCode == 70)
            {
                stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            if (e.keyCode == 83)
            {
                enabled = !enabled;
                if (enabled)
                {
                    stage.removeEventListener(Event.ENTER_FRAME,loop);
                }
                else
                {
                    stage.addEventListener(Event.ENTER_FRAME,loop);
                }                
            }
        }
        
        private function changeTheColor(e:MouseEvent):void
        {
            getColor();
            //trace(System.totalMemory/1024/1024,' MB', ' @ ', stage.frameRate , "fps");
        }
        
        private function startTheCount(e:MouseEvent):void
        {
            beginX = mouseX;
            beginY = mouseY;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, updateTheCount);
            stage.addEventListener(MouseEvent.MOUSE_UP, stopTheCount);
        }
        
        private function stopTheCount(e:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateTheCount);
            stage.removeEventListener(MouseEvent.MOUSE_UP, stopTheCount);
            e.stopPropagation();
            stage.addEventListener(MouseEvent.MOUSE_MOVE, changeTheColor); // orig.: click
        }
        
        private function updateTheCount(e:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.CLICK, changeTheColor);
                        
            // recalculate scale change
            if(scaleChange - ((mouseX - beginX)/7500) < 0.5)
            {
                scaleChange = 0.5;
            }
            else if(scaleChange + ((mouseX - beginX)/7500) > 1.5)
            {
                scaleChange = 1.5;
            }
            else
            {
                scaleChange -= ((mouseX - beginX)/7500);
            }
            
            // recalculate rotation jump
            if(rotationJump - ((mouseY - beginY)/80) < -20)
            {
                rotationJump = -20;
            }
            else if(rotationJump + ((mouseY - beginY)/80) > 20)
            {
                rotationJump = 20;
            }
            else
            {
                rotationJump -= ((mouseY - beginY)/80);
            }
            
            beginX = mouseX;
            beginY = mouseY;
        }
        
        private function clickHandler(e:MouseEvent):void 
        {
            hider.visible= !hider.visible;
        }
        
        private function keydownHandler(e:KeyboardEvent):void 
        {
            this.stage.removeEventListener(Event.ENTER_FRAME, loop);
        }
        
        private function keyupHandler(e:KeyboardEvent):void 
        {            
            this.stage.addEventListener(Event.ENTER_FRAME, loop);
        }
    }
}
