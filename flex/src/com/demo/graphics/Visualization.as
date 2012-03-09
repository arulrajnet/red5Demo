package com.demo.graphics {
    
    import mx.core.UIComponent;
     import flash.display.BitmapData;
     import flash.filters.BlurFilter;
     import flash.media.SoundMixer;
     import flash.utils.ByteArray;
     import flash.events.Event;
     import flash.geom.Rectangle;
     import flash.display.Bitmap;
     import flash.geom.Point;
    
    [Event("rendered")]
    [Event("render")]
    [Style(name="audioLineColor",type="Number",format="Color",inherit="no")]
    [Style(name="audioFillColor",type="Number",format="Color",inherit="no")]
     public class Visualization extends UIComponent {
         
          public var bitmapData:BitmapData = new BitmapData(1, 1, true, 0x00000000);
          private var _bitmap:Bitmap = new Bitmap(bitmapData);
          private var _spectrumData:ByteArray = new ByteArray();
          private var _rc:Number = 0; // relativeCenter
          private var _rp:Number = 0; // relativePixel
          
          private var _audioLineColor:uint = 0x000000;
          private var _audioFillColor:uint = 0x000000;
          
          
          // constructors
          
          public function Visualization() {
               addEventListener(Event.ENTER_FRAME, enterFrameListener);
           }
        
        // properties
        
        private var _type:String = "wave"; // line, wave, bars
        public function get type():String { return _type; }
        public function set type( value:String ):void {
            if( value=="line" || value=="wave" || value=="bars" ) {
                _type = value;
            }
        }
        
          private var _channel:String="mono"; // mono, left, right, stereo
          public function get channel():String { return _channel; }
          public function set channel( value:String ):void {
              if( value=="mono" || value=="left" || value=="right" || value=="stereo" ) {
                  _channel = value;
              }
          }
          
          private var _bars:uint = 64; // 1 - 256
          public function get bars():uint { return _bars; }
          public function set bars( value:uint ) : void {
              _bars = value;
          }
        
        
        // public methods
        
        public function start():void {
            addEventListener(Event.ENTER_FRAME, enterFrameListener);
        }
        
        public function stop():void {
            if(!hasEventListener( "render" )) { bitmapData.fillRect( bitmapData.rect, 0x0); }
            removeEventListener(Event.ENTER_FRAME, enterFrameListener);
        }
        
        // private methods etc.
        
           override protected function createChildren():void {
               addChild(_bitmap);
           }
           
           override protected function updateDisplayList(w:Number, h:Number):void {
               super.updateDisplayList(w, h);
               var bt:uint = getStyle("borderThickness")*2;
               if(w-bt>0 && h-bt>1) {bitmapData = new BitmapData(w-bt, h-bt, true, 0x0);}
               _bitmap.bitmapData = bitmapData;
               _audioLineColor = getStyle("audioLineColor");
               _audioFillColor = getStyle("audioFillColor");
               // convenience variables to skip useless calls to getters
               _rc = (h-bt)/2;
               _rp = (w-bt)/256;
           }
           
          private function enterFrameListener(e:Event):void {
              var rect:Rectangle = bitmapData.rect
               SoundMixer.computeSpectrum(_spectrumData, type=="bars", 0);
            dispatchEvent( new Event("render",true) );
            if(!hasEventListener( "render" )) { bitmapData.fillRect( rect, 0x0); }
            switch (_channel) {
                case "mono":
                    toMono();
                case "left":
                    if(_type=="line" || _type=="wave") { drawWave(1); }
                    if(_type=="wave") {
                        _spectrumData.position=0;
                        drawWave(-1);
                    }
                    if(_type=="bars") {
                        drawEQ();
                    }
                    break;
                case "right":
                    for (var i:int = 0; i < 256 ; i++) {_spectrumData.readFloat();} // using spectrumData.position yields poor results
                    if(_type=="line" || _type=="wave") { drawWave(1); }
                    if(_type=="wave") {
                        _spectrumData.position=0;
                        for (var j:int = 0; j < 256 ; j++) {_spectrumData.readFloat();}
                        drawWave(-1);
                    }
                    if(_type=="bars") {
                        drawEQ();
                    }
                    break;
                case "stereo":
                    if(_type=="line" || _type=="wave") {
                        drawWave(1);
                        drawWave(1);
                    }
                    if(_type=="wave") {
                        _spectrumData.position=0;
                        drawWave(-1);
                        drawWave(-1);
                    }
                    if(_type=="bars") {
                        drawEQ();
                        drawEQ();
                    }
                    break;
            }
            //bitmapData.applyFilter( bitmapData, rect, new Point(0,0), new BlurFilter(bitmapData.width/256,bitmapData.width/256,1));
            dispatchEvent( new Event("rendered",true) );
        }
        
        private function toMono():void {
            _spectrumData.position = 0;
            if(_spectrumData.length==2048) {
                var leftData:ByteArray = new ByteArray();
                   var rightData:ByteArray = new ByteArray();
                   _spectrumData.readBytes(leftData, 0, 1024);
                   _spectrumData.readBytes(rightData, 0, 1024);
                   _spectrumData = new ByteArray();
                   for (var i:uint = 0; i < 256 ; i++) {
                       _spectrumData.writeFloat((leftData.readFloat()+rightData.readFloat())/2);
                   }
                   _spectrumData.position = 0;
               }
        }
        
        private function drawWave(modifier:Number=1):void {
            var v:Number;
               var lastv:Number = _rc;
               var r:Rectangle = new Rectangle();
               for (var i:uint = 0; i < 256; i++) {
                   var rf:Number = _spectrumData.readFloat();
                v = _rc+rf*_rc*modifier*-1;
                if(type=="wave"){
                    r.x = i*_rp; r.y = Math.min(v,_rc); r.width = _rp; r.height = Math.abs(_rc-v);
                    bitmapData.fillRect( r, 0xFF000000 | _audioFillColor );
                }
                r.x = i*_rp; r.y = v; r.width = _rp; r.height = 1+Math.abs(lastv-v);
                   bitmapData.fillRect( r, 0xFF000000 | _audioLineColor );
                lastv=v;
            }
        }
        
        private function drawEQ():void {
            var v:Number;
               var nrp:Number = _rp*256/_bars;
               var r:Rectangle = new Rectangle();
               for (var i:uint = 0; i < _bars; i++) {
                   var n:Number = 0;
                   var je:Number = Math.floor(256/_bars);
                   for (var j:uint = 0; j < je ; j++) { n += _spectrumData.readFloat(); }
                n = n/je;
                v = Math.max(_rc*2-n*_rc*2,5);
                r.x = nrp/8+i*nrp; r.y = v; r.width = nrp/2+nrp/4; r.height = _rc*2-v;
                bitmapData.fillRect( r, 0xFF000000 | _audioFillColor );
                r.x = nrp/8+i*nrp; r.y = v; r.width = nrp/2+nrp/4; r.height = 1;
                bitmapData.fillRect( r, 0xFF000000 | _audioLineColor );
            }
        }
        
      }
}
