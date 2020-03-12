package com.olcanic.ffmpeglib {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author olcanic
	 */
	public class FFmpegEvent extends Event {
		
		public static const FFMPEG_ERROR:String = "ffmpegError";
		public static const FFMPEG_EXIT:String = "ffmpegExit";
		public static const FFMPEG_PROCESS:String = "ffmpegProcess";
		public static const FFMPEG_METADATA:String = "ffmpegMetadata";
		public static const FFMPEG_COMPLETE:String = "ffmpegComplete";
		public static const FFMPEG_WARNING:String = "ffmpegWarning";
		public static const FFMPEG_PROCESS_INFO:String = "ffmpegProcessInfo";
		
		private var _data:Object;
		
		public function FFmpegEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
			_data = data;
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new FFmpegEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String {
			return formatToString("FFmpegEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get dataAsError():Error {
			return _data as Error;
		}
		
		public function get dataAsString():String {
			return _data as String;
		}
		
		public function get dataAsInteger():int {
			return _data as int;
		}
		
		public function get data():Object {
			return _data;
		}
		
	}
	
}