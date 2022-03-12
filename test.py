import ffmpeg
from flask import Flask,request,jsonify,make_response
from pydub import AudioSegment
import numpy as numpy
import wave
import speech_recognition as sr 

# given_audio = AudioSegment.from_file("audio.weba")                                                
# given_audio.export("output_audio.wav",format="wav")

# filename="output_audio.wav"
# r=sr.Recognizer()
# with sr.AudioFile(filename) as source:
# 	audio_data=r.record(source,duration=5)
# text=r.recognize_google(audio_data)
# print(type(text))

app=Flask(__name__)
@app.route('/')
def home():
	return 'home'

@app.route('/processaudio',methods=['POST','OPTIONS'])
def process():
	try:
		if request.method == "OPTIONS": # CORS preflight
			return _build_cors_preflight_response()
		elif request.method == "POST":
			print("post called")
			data=request.get_json()
			voice_list=data["audioBytes"]
			audio_bytes=[]
			for num in voice_list:
				audio_bytes.append(num.to_bytes(2,'big'))
			full_audio_bytes = b''.join(audio_bytes)  # this is my table of chunks of audio data        
			byte_list=bytearray(voice_list)
			audio_bytes=bytes(byte_list)
			with open('audio.weba','wb') as obj:
				obj.write(audio_bytes)
			given_audio = AudioSegment.from_file("audio.weba")                                                
			given_audio.export("output_audio.wav",format='wav')

		# your model code goes here
			filename="output_audio.wav"
			r=sr.Recognizer()
			with sr.AudioFile(filename) as source:
				audio_data=r.record(source)
			text=r.recognize_google(audio_data)
			print(text)
		else:
			raise RuntimeError("Weird - don't know how to handle method {}".format(request.method))
	except:
		return _corsify_actual_response(jsonify(error=True))

	return _corsify_actual_response(jsonify(response=text,error=False))
	

def _build_cors_preflight_response():
	response = make_response()
	response.headers.add("Access-Control-Allow-Origin", "*")
	response.headers.add('Access-Control-Allow-Headers', "*")
	response.headers.add('Access-Control-Allow-Methods', "*")
	return response

def _corsify_actual_response(response):
	response.headers.add("Access-Control-Allow-Origin", "*")
	return response


	

if __name__=="__main__":
	app.run()






# given_audio = AudioSegment.from_file("audio.weba")                                                
# given_audio.export("output_audio.mp3")
# given_audio.export("output_audio.flac")
# given_audio.export("output_audio.wav")


# from flask import Flask, request, jsonify, make_response

# flask_app = Flask(__name__)

# @flask_app.route('/processaudio', methods=["POST", "OPTIONS"])
# def process_audio():
#     if request.method == "OPTIONS": # CORS preflight
#         return _build_cors_preflight_response()
#     elif request.method == "POST": # The actual request following the preflight
#         print("post called")
# 		data=request.get_json()
# 		print(data)
#         return _corsify_actual_response(jsonify(data.to_dict()))
#     else:
#         raise RuntimeError("Weird - don't know how to handle method {}".format(request.method))

# def _build_cors_preflight_response():
#     response = make_response()
#     response.headers.add("Access-Control-Allow-Origin", "*")
#     response.headers.add('Access-Control-Allow-Headers', "*")
#     response.headers.add('Access-Control-Allow-Methods', "*")
#     return response

# def _corsify_actual_response(response):
#     response.headers.add("Access-Control-Allow-Origin", "*")
#     return response

# if __name__=="__main__":
# 	app.run()

