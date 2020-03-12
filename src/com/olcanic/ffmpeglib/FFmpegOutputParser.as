package com.olcanic.ffmpeglib {
	
	/**
	 * ...
	 * @author olcanic
	 */
	public class FFmpegOutputParser {
	
		/**
		 * ... (default)
		 * ... (attached pic)
		 */
		private static const REGEXP_STREAM_ADDITIONAL_SPECIFIER:RegExp = /^(.+)\s\(([a-z\s]+)\)$/;
		
		/**
		 * Stream #0:0: Audio: mp3, 44100 Hz, stereo, fltp, 320 kb/s
		 */
		private static const REGEXP_STREAM:RegExp = /^Stream\s*(#\d+\D+\d+)\s*:\s*(\S+):\s*(.+)?/;
		
		/**
		 * mjpeg (Baseline), yuvj444p(pc, bt470bg/unknown/unknown), 500x500, 90k tbr, 90k tbn, 90k tbc (attached pic)
		 */
		private static const REGEXP_STREAM_PARAM:RegExp = /([^,(]+(\s*(\([^)]+\)|\[[^\]]\]))*)(,\s)?/g;
		
		/**
		 * Stream #0:0 -> #0:0 (mp3 (mp3float) -> mp3 (libmp3lame))
		 */
		private static const REGEXP_STREAM_MAPPING:RegExp = /^(?:Stream\s*)(\S+)\s*->\s*(\S+)/;
		
		/**
		 * size=    2777kB time=00:02:51.12 bitrate= 132.9kbits/s speed=6.77x
		 */
		private static const REGEXP_PROCESS:RegExp = /(\s*)([^=]+)(\s*=\s*)(\S*)/g;
		
		/**
		 * TODO:
		 * Input #0, mp3, from 'D:/Temp/soundplayer/doma.mp3'
		 */
		private static const REGEXP_SOURCE_FORMAT:RegExp = /(?:(?:In|Out)put\s*#)(?:\d+)(?:\,\s*)([^,]+).+/;
		
		/**
		 *
		 */
		private static const REGEXP_LINE_LEVEL:RegExp = /^\s*/;
		
		/**
		 *
		 */
		private static const REGEXP_ERRORS:RegExp = /(Invalid data found when processing input|does not contain any stream|Unknown error|Invalid duration specification |Protocol not found|Input\/output error)/g;
		
		/**
		 * Duration: 00:02:56.98, start: 0.000000, bitrate: 323 kb/s
		 */
		private static const REGEXP_DURATION:RegExp = /^Duration:\s*(\d{2}:\d{2}:\d{2}\.\d{2}),\s*start:\s(\d+\.\d+),\s*bitrate:\s*(\d+)\s*kb(it)?\/s/;
		
		/**
		 * 500x500 [SAR 1:1 DAR 32:76]
		 * 1280x720
		 * 
		 */
		private static const REGEXP_RESOLUTION:RegExp = /^(\d+)x(\d+)(?:\s*\[SAR\s*(\d+)\:(\d+)\s*DAR\s*(\d+)\:(\d+)\])?.*/;
		
		/**
		 * 23.3 fps
		 * 50 fps
		 */
		private static const REGEXP_FPS:RegExp = /^(\d+(\.\d+))?\sfps.*/;
		
		/**
		 * TODO: sampling_rate
		 * 
		 * 44100 Hz
		 */
		private static const REGEXP_SAMPLING_RATE:RegExp = /^(\d+)\sHz.*/;
		
		/**
		 * 
		 * TODO: 
		 * 
		 * 120 kb/s
		 * 256kbits/s
		 */
		private static const REGEXP_BITRATE:RegExp = /^(\d+(?:\.\d+)?)\s*?kb(?:its?)?\/s.*/i;
		
		/**
		 * 
		 * TODO:
		 * 
		 * mono
		 * stereo
		 * 5.0(side)
		 * 5.1(side)
		 * 6.0(front)
		 * 7.1(wide)
		 * 7.1(wide-side)
		 * octagonal
		 * hexadecagonal
		 * downmix
		 */
		private static const REGEXP_CHANNELS:RegExp = /^(mono|stereo|octagonal|hexadecagonal|downmix|\d+\.\d+)(?:\((side|front|back|wide(?:-side)?)\))?/;
		
		/**
		 * key : value
		 */
		private static const REGEXP_KEY_VALUE:RegExp = /([^:\s]+)\s*:\s*(.+)/;
		
		///([^:]+):\s?(\d+(?:\.\d+)?)([kmgt]?B|%)\s?/g
		private static const REGEXP_PROCESS_COMPLETE:RegExp = /video:(\d+)([a-zA-Z]+)\saudio:(\d+)([a-zA-Z]+)\ssubtitle:(\d+)([a-zA-Z]+)\sother streams:(\d+)([a-zA-Z]+)\sglobal headers:(\d+)([a-zA-Z]+)\smuxing overhead:\s(\d+\.\d+)%/;
		
		//(\s*)([^:]+)(\s*:\s*)(\S*)
		//video:0kB audio:2674kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 3.842732%
		//
		
		public static const KEY_USOURCE:String = "_source";
		public static const KEY_METADATA:String = "metadata";
		public static const KEY_OUPUT:String = "output";
		public static const KEY_INPUT:String = "input";
		public static const KEY_STREAM_MAPPING:String = "stream_mapping";
		public static const KEY_TYPE:String = "type";
		public static const KEY_PARAMS:String = "params";
		public static const KEY_FORMAT:String = "format";
		public static const KEY_STREAM:String = "stream";
		public static const KEY_WIDTH:String = "width";
		public static const KEY_HEIGHT:String = "height";
		public static const KEY_DAR:String = "dar";
		public static const KEY_SAR:String = "sar";
		public static const KEY_VALUE:String = "value";
		public static const KEY_DURATION:String = "duration";
		public static const KEY_START:String = "start";
		public static const KEY_CODEC:String = "codec";
		public static const KEY_HZ:String = "hz";
		public static const KEY_FPS:String = "fps";
		public static const KEY_CHANNELS:String = "channels";
		public static const KEY_PIXEL_FORMAT:String = "pixel_format";
		public static const KEY_DEFAULT:String = "default";
		public static const KEY_ID:String = "id";
		public static const KEY_ADDITIONAL_SPECIFIER:String = "additional_specifier";
		public static const KEY_FROM_ID:String = "from_id";
		public static const KEY_TO_ID:String = "to_id";
		public static const KEY_TIME:String = "time";
		public static const KEY_SIZE:String = "size";
		public static const KEY_FRAME:String = "frame";
		public static const KEY_BITRATE:String = "bitrate";
		public static const KEY_SPEED:String = "speed";
		
		public static const TYPE_VIDEO:String = "Video";
		public static const TYPE_AUDIO:String = "Audio";
		
		public static const PART_STREAM:String = "Stream #";
		public static const PART_CHAPTER:String = "Chapter #";
		public static const PART_OUTPUT:String = "Output #";
		public static const PART_INPUT:String = "Input #";
		public static const PART_STREAM_MAPPING:String = "Stream mapping:";
		public static const PART_METADATA:String = "Metadata:";
		public static const PART_DURATION:String = "Duration:";
		public static const PART_SIDE_DATA:String = "Side data:";
		public static const PART_WARNING:String = "[";
		public static const PART_PROCESS_SIZE:String = "size=";
		public static const PART_PROCESS_COMPLETE:String = "muxing overhead";
		
		public static const TIME_NA:String = "N/A";
		
		private var _ffmpeg:FFmpeg;
		private var _inProgress:Boolean;
		private var _parseStreamInfoEnabled:Boolean;
		
		private var _metadata:Object;
		private var _sourceObject:Object;
		private var _streamObject:Object;
		private var _sourceMetadataObject:Object;
		private var _streamMetadataObject:Object;
		private var _streamMappingArray:Array;
		
		public function FFmpegOutputParser(ffmpeg:FFmpeg) {
			_ffmpeg = ffmpeg;
			clear();
			parseStreamParamsEnabled = true;
		}
		
		private function clearTmpSourceData():void {
			_sourceObject = null;
			_streamObject = null;
			_sourceMetadataObject = null;
			_streamMetadataObject = null;
			_streamMappingArray = null;
		}
		
		private function clear():void {
			clearTmpSourceData();
			_metadata = {};
			_metadata[KEY_INPUT] = [];
			_metadata[KEY_OUPUT] = [];
			_metadata[KEY_STREAM_MAPPING] = [];
			_inProgress = false;
		}
		
		public function parsePart(part:String):void {
			const rawLevel:Array = REGEXP_LINE_LEVEL.exec(part);
			if (rawLevel == null || rawLevel.length == 0) {
				return;
			}
			const levelString:String = rawLevel[0] as String;
			const levelLength:uint = levelString.length;
			const level:uint = levelLength / 2;
			part = part.substring(levelLength);
			switch (level) {
			case 0: 
				if (REGEXP_ERRORS.test(part)) {
					dispatchFFmpegEvent(FFmpegEvent.FFMPEG_ERROR, part);
					return;
				} else if (part.charAt(0) == PART_WARNING) {
					dispatchFFmpegEvent(FFmpegEvent.FFMPEG_WARNING, part);
					return;
				}
				if (!_inProgress) {
					clearTmpSourceData();
					if (part.indexOf(PART_INPUT) == 0) {
						_sourceObject = {};
						_sourceObject[KEY_STREAM] = [];
						_sourceObject[KEY_FORMAT] = parseInputOutputFormat(part);
						_metadata[KEY_INPUT].push(_sourceObject);
						return;
					} else if (part.indexOf(PART_OUTPUT) == 0) {
						_sourceMetadataObject = null;
						_streamObject = null;
						_sourceObject = {};
						_sourceObject[KEY_STREAM] = [];
						_sourceObject[KEY_FORMAT] = parseInputOutputFormat(part);
						_metadata[KEY_OUPUT].push(_sourceObject);
						return;
					} else if (part.indexOf(PART_STREAM_MAPPING) == 0) {
						_streamMappingArray = [];
						_metadata[KEY_STREAM_MAPPING] = _streamMappingArray;
						return;
					}
				}
				const processCompleteResult:Object = parseProcessCompelete(part);
				if (processCompleteResult != null) {
					dispatchFFmpegEvent(FFmpegEvent.FFMPEG_COMPLETE, processCompleteResult);
					return;
				} else if (part.indexOf(PART_PROCESS_SIZE) != -1) {
					const startProcess:Boolean = !_inProgress;
					if (startProcess) {
						_inProgress = true;
					}
					if (startProcess && hasFFmpegEventListener(FFmpegEvent.FFMPEG_METADATA)) {
						dispatchFFmpegEvent(FFmpegEvent.FFMPEG_METADATA, _metadata);
					}
					if (hasFFmpegEventListener(FFmpegEvent.FFMPEG_PROCESS_INFO)) {
						dispatchFFmpegEvent(FFmpegEvent.FFMPEG_PROCESS_INFO, parseProcessParams(part));
					}
					return;
				}
				break;
			case 1: 
				_sourceMetadataObject = null;
				_streamObject = null;
				if (_sourceObject != null) {
					if (part.indexOf(PART_METADATA) == 0) {
						_sourceMetadataObject = {};
						_sourceObject[KEY_METADATA] = _sourceMetadataObject;
						return;
					} else if (part.indexOf(PART_SIDE_DATA) == 0) {
						/**
						 * target: (next line) cpb: bitrate max/min/avg: 0/0/0 buffer size: 0 vbv_delay: -1
						 */
						return;
					} else if (part.indexOf(PART_DURATION) == 0) {
						const duration:Object = {};
						_sourceObject[KEY_DURATION] = duration;
						duration[KEY_USOURCE] = part;
						const durationExec:Array = REGEXP_DURATION.exec(part);
						if (durationExec != null) {
							duration[KEY_VALUE] = parseTime(durationExec[1]);
							duration[KEY_START] = Number(durationExec[2]);
							duration[KEY_BITRATE] = Number(durationExec[3]);
						}
						return;
					}
				} else if (_streamMappingArray != null) {
					if (part.indexOf(PART_STREAM) == 0) {
						const mapping:Object = parseStreamMapping(part);
						if (mapping != null) {
							_streamMappingArray.push(mapping);
						}
						return;
					}
				}
				break;
			case 2: 
				_streamMetadataObject = null;
				if (part.indexOf(PART_STREAM) == 0) {
					if (_sourceObject != null) {
						_streamObject = {};
						parseStream(_streamObject, part, parseStreamParamsEnabled);
						_sourceObject[KEY_STREAM].push(_streamObject);
					}
					return;
				} else if (part.indexOf(PART_METADATA) == 0) {
					if (_streamObject != null) {
						_streamMetadataObject = {};
						_streamObject[KEY_METADATA] = _streamMetadataObject;
						return;
					}
				} else if (part.indexOf(PART_CHAPTER) == 0) {
					/**
					 * TODO: 
					 * target: Chapter #0:0: start 0.000000, end 179.000000
					 */
					return;
				} else if (_sourceMetadataObject != null) {
					parseKeyValue(_sourceMetadataObject, part);
				}
				break;
			case 3: 
				if (_streamMetadataObject != null) {
					parseKeyValue(_streamMetadataObject, part);
				}
				break;
			}
			return;
		}
		
		private function parseProcessCompelete(part:String):Object {
			const processCompleteResult:Array = REGEXP_PROCESS_COMPLETE.exec(part);
			if (processCompleteResult != null) {
				const result:Object = {};
				return result;
			}
			return null;
		}
		
		private function parseStreamMapping(part:String):Object {
			const streamMappingResult:Array = REGEXP_STREAM_MAPPING.exec(part);
			if (streamMappingResult != null) {
				const object:Object = {};
				object[KEY_FROM_ID] = streamMappingResult[1];
				object[KEY_TO_ID] = streamMappingResult[2];
				return object;
			}
			return object;
		}
		
		private function parseProcessParams(part:String):Object {
			const object:Object = {};
			object[KEY_USOURCE] = part;
			var i:uint = 0;
			while (true) {
				const exec:Array = REGEXP_PROCESS.exec(part);
				if (exec != null) {
					const key:String = exec[2];
					const value:String = exec[4];
					switch (key) {
					case KEY_SPEED: 
						object[key] = Number(value.substring(0, value.length - 1));
						break;
					case KEY_FPS: 
					case KEY_FRAME: 
						object[key] = Number(value);
						break;
					case KEY_TIME: 
						object[key] = parseTime(value);
						break;
					case KEY_BITRATE: 
						const bitrateResult:Array = REGEXP_BITRATE.exec(value);
						if (bitrateResult != null) {
							object[key] = Number(bitrateResult[1]);
						} else {
							object[key] = value;
						}
						break;
					default: 
						object[key] = value;
						break;
					}
				} else {
					break;
				}
			}
			return object;
		}
		
		private static function parseInputOutputFormat(part:String):String {
			const sourceResult:Array = REGEXP_SOURCE_FORMAT.exec(part);
			if (sourceResult != null) {
				return sourceResult[1];
			}
			return null;
		}
		
		public static function parseKeyValue(object:Object, string:String):void {
			const result:Array = REGEXP_KEY_VALUE.exec(string);
			if (result != null) {
				const key:String = result[1] as String;
				const value:String = result[2] as String;
				object[key] = value;
			}
		}
		
		//
		public static function parseStream(object:Object, string:String, extended:Boolean):void {
			const streamResult:Array = REGEXP_STREAM.exec(string);
			if (streamResult != null) {
				const streamID:String = streamResult[1];
				const streamType:String = streamResult[2];
				var streamParams:String = streamResult[3];
				const indexOfDefault:int = streamParams.length - 10;
				
				const additionalSpecifierResult:Array = REGEXP_STREAM_ADDITIONAL_SPECIFIER.exec(streamParams);
				if (additionalSpecifierResult != null) {
					streamParams = additionalSpecifierResult[1];
					object[KEY_ADDITIONAL_SPECIFIER] = additionalSpecifierResult[2];
				}
				
				object[KEY_ID] = streamID;
				object[KEY_TYPE] = streamType;
				object[KEY_USOURCE] = string;
				
				if (!extended) {
					return;
				}
				const info:Array = [];
				var index:uint = 0;
				while (true) {
					const execArray:Array = REGEXP_STREAM_PARAM.exec(streamParams);
					if (execArray != null) {
						const param:String = execArray[1] as String;
						if (!parseStreamParam(object, index, streamType, param)) {
							info.push(param);
						}
					} else {
						break;
					}
					index++;
				}
				object[KEY_PARAMS] = info;
			}
		}
		
		private static function parseStreamParam(object:Object, index:uint, type:String, value:String):Boolean {
			if (index == 0) {
				if (type == TYPE_VIDEO || type == TYPE_AUDIO) {
					object[KEY_CODEC] = value;
					return true;
				}
			} else {
				if (type == TYPE_VIDEO || type == TYPE_AUDIO) {
					if (type == TYPE_VIDEO) {
						if (index == 1) {
							object[KEY_PIXEL_FORMAT] = value;
							return true;
						}
						const resolutionResult:Array = REGEXP_RESOLUTION.exec(value);
						if (resolutionResult != null) {
							object[KEY_WIDTH] = Number(resolutionResult[1]);
							object[KEY_HEIGHT] = Number(resolutionResult[2]);
							if (resolutionResult.length > 6) {
								object[KEY_SAR] = Number(resolutionResult[3]) / Number(resolutionResult[4]);
								object[KEY_DAR] = Number(resolutionResult[5]) / Number(resolutionResult[6]);
							}
							return true;
						}
						const fpsResult:Array = REGEXP_FPS.exec(value);
						if (fpsResult != null) {
							object[KEY_FPS] = Number(fpsResult[1]);
							return true;
						}
					} else if (type == TYPE_AUDIO) {
						const hzResult:Array = REGEXP_SAMPLING_RATE.exec(value);
						if (hzResult != null) {
							object[KEY_HZ] = Number(hzResult[1]);
							return true;
						}
						const channelsResult:Array = REGEXP_CHANNELS.exec(value);
						if (channelsResult != null) {
							object[KEY_CHANNELS] = value;
							return true;
						}
					}
					const kbpsResult:Array = REGEXP_BITRATE.exec(value);
					if (kbpsResult != null) {
						object[KEY_BITRATE] = Number(kbpsResult[1]);
						return true;
					}
				}
			}
			return false;
		}
		
		private static function parseTime(timeStr:String):Number {
			if (timeStr == TIME_NA) {
				return NaN;
			}
			const hours:int = int(timeStr.substr(0, 2));
			const minutes:int = int(timeStr.substr(3, 2));
			const seconds:Number = Number(timeStr.substr(6));
			return (hours * 3600 + minutes * 60 + seconds) * 1000;
		}
		
		private function dispatchFFmpegEvent(eventType:String, data:Object = null):void {
			_ffmpeg.dispatchEvent(new FFmpegEvent(eventType, data));
		}
		
		private function hasFFmpegEventListener(eventType:String):Boolean {
			return _ffmpeg.hasEventListener(eventType);
		}
		
		public function get parseStreamParamsEnabled():Boolean {
			return _parseStreamInfoEnabled;
		}
		
		public function set parseStreamParamsEnabled(value:Boolean):void {
			_parseStreamInfoEnabled = value;
		}
	
	}

}