package com.olcanic.ffmpeglib {
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.errors.IOError;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author olcanic
	 */
	[Event(name = "ffmpegError", type = "com.olcanic.ffmpeglib.FFmpegEvent")]
	[Event(name = "ffmpegExit", type = "com.olcanic.ffmpeglib.FFmpegEvent")]
	[Event(name = "ffmpegProcess", type = "com.olcanic.ffmpeglib.FFmpegEvent")]
	[Event(name = "ffmpegMetadata", type = "com.olcanic.ffmpeglib.FFmpegEvent")]
	[Event(name = "ffmpegComplete", type = "com.olcanic.ffmpeglib.FFmpegEvent")]
	[Event(name = "ffmpegWarning", type = "com.olcanic.ffmpeglib.FFmpegEvent")]
	[Event(name = "ffmpegProcessInfo", type = "com.olcanic.ffmpeglib.FFmpegEvent")]
	
	public class FFmpeg extends EventDispatcher {
		
		public static var defaultExecutableFile:File;
		
		private var _nativeProcess:NativeProcess;
		private var _executableFile:File;
		private var _byteArray:ByteArray;
		private var _parser:FFmpegOutputParser;
		private var _standartErrorDataBuffer:String;
		
		public function FFmpeg() {
			_byteArray = new ByteArray();
			_parser = new FFmpegOutputParser(this);
		}
		
		public function start(args:Vector.<String>):void {
			disposeNativeProcess();
			
			_standartErrorDataBuffer = "";
			
			const info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.executable = executableFile == null ? defaultExecutableFile : executableFile;
			info.workingDirectory = File.applicationDirectory;
			
			info.arguments = args;
			
			_nativeProcess = new NativeProcess();
			
			_nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, nativeProcess_standardOutputData);
			_nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, nativeProcess_standardErrorData);
			_nativeProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, nativeProcess_standardErrorIoError);
			_nativeProcess.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, nativeProcess_standardInputIoError);
			_nativeProcess.addEventListener(NativeProcessExitEvent.EXIT, nativeProcess_exit);
			
			_nativeProcess.start(info);
		}
		
		public function stop():void {
			disposeNativeProcess();
		}
		
		private function nativeProcess_standardInputIoError(e:IOErrorEvent):void {
			dispatchEvent(new FFmpegEvent(FFmpegEvent.FFMPEG_ERROR, new IOError(e.text, e.errorID)));
		}
		
		private function nativeProcess_standardErrorIoError(e:IOErrorEvent):void {
			dispatchEvent(new FFmpegEvent(FFmpegEvent.FFMPEG_ERROR, new IOError(e.text, e.errorID)));
		}
		
		private function nativeProcess_exit(e:NativeProcessExitEvent):void {
			dispatchEvent(new FFmpegEvent(FFmpegEvent.FFMPEG_EXIT, e.exitCode));
		}
		
		private function nativeProcess_standardErrorData(e:ProgressEvent):void {
			const nativeProcess:NativeProcess = e.target as NativeProcess;
			var tracePart:String = nativeProcess.standardError.readUTFBytes(nativeProcess.standardError.bytesAvailable);
			
			_standartErrorDataBuffer += tracePart;
			
			while (true) {
				const index:int = _standartErrorDataBuffer.indexOf("\r");
				if (index == -1) {
					break;
				}
				
				const skipN:Boolean = _standartErrorDataBuffer.length > 0 && _standartErrorDataBuffer.charAt(0) == "\n";
				const part:String = _standartErrorDataBuffer.substring(skipN ? 1 : 0, index);
				_standartErrorDataBuffer = _standartErrorDataBuffer.substring(index + 1);
				_parser.parsePart(part);
			}
		}
		
		private function nativeProcess_standardOutputData(e:ProgressEvent):void {
			_nativeProcess.standardOutput.readBytes(_byteArray, _byteArray.length);
			dispatchEvent(new FFmpegEvent(FFmpegEvent.FFMPEG_PROCESS, null));
		}
		
		private function disposeNativeProcess():void {
			if (_nativeProcess != null) {
				_nativeProcess.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, nativeProcess_standardOutputData);
				_nativeProcess.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, nativeProcess_standardErrorData);
				_nativeProcess.removeEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, nativeProcess_standardErrorIoError);
				_nativeProcess.removeEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, nativeProcess_standardInputIoError);
				_nativeProcess.removeEventListener(NativeProcessExitEvent.EXIT, nativeProcess_exit);
				_nativeProcess.exit(true);
				_nativeProcess = null;
			}
		}
		
		public function get executableFile():File {
			return _executableFile;
		}
		
		public function set executableFile(value:File):void {
			_executableFile = value;
		}
		
		public function get byteArray():ByteArray {
			return _byteArray;
		}
	
	}

}