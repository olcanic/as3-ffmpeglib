package com.olcanic.test {
	import com.olcanic.ffmpeglib.FFmpeg;
	import com.olcanic.ffmpeglib.FFmpegEvent;
	import flash.display.Sprite;
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author polkaniatic
	 */
	public class Main extends Sprite {
		
		public function Main() {
			const ffmpeg:FFmpeg = new FFmpeg();
			ffmpeg.addEventListener(FFmpegEvent.FFMPEG_METADATA, ffmpeg_ffmpegMetadata);
			ffmpeg.addEventListener(FFmpegEvent.FFMPEG_EXIT, ffmpeg_ffmpegExit);
			ffmpeg.addEventListener(FFmpegEvent.FFMPEG_PROCESS_INFO, ffmpeg_ffmpegProcessInfo);
			ffmpeg.addEventListener(FFmpegEvent.FFMPEG_WARNING, ffmpeg_ffmpegWarning);
			ffmpeg.addEventListener(FFmpegEvent.FFMPEG_COMPLETE, ffmpeg_ffmpegComplete);
			
			FFmpeg.defaultExecutableFile = new File("C:/Programs/ffmpeg-4.2.2/bin/ffmpeg.exe");
			
			const args:Vector.<String> = new Vector.<String>();
			args.push("-i", "D:/Music/mp3.collection.cyberpunk/Arthur Distone - Cyberbeat.mp3", "-f", "flv", "-");
			
			ffmpeg.start(args);
		}
		
		private function ffmpeg_ffmpegComplete(e:FFmpegEvent):void {
			trace("ffmpeg_ffmpegComplete");
		}
		
		private function ffmpeg_ffmpegWarning(e:FFmpegEvent):void {
			trace("ffmpeg_ffmpegWarning");
		}
		
		private function ffmpeg_ffmpegProcessInfo(e:FFmpegEvent):void {
			trace("ffmpeg_ffmpegProcessInfo");
		}
		
		private function ffmpeg_ffmpegExit(e:FFmpegEvent):void {
			trace("ffmpeg_ffmpegExit");
		}
		
		private function ffmpeg_ffmpegMetadata(e:FFmpegEvent):void {
			trace("ffmpeg_ffmpegMetadata");
			//e.currentTarget.stop();
			//trace(JSON.stringify(e.data, null, "  "));
		}
		
	}
	
}