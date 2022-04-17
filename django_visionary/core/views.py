from django.conf import settings
from django.http import Http404
from django.shortcuts import render

# rest_framework imports
from rest_framework import status, authentication, permissions
from rest_framework.decorators import api_view, authentication_classes,permission_classes
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.response import Response

# models.py imports
from .apps import CaptionerConfig
# from .models import ExampleModel
# from .serializers import ExampleModelSerializer

# ML imports
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from keras.applications.xception import Xception
from keras.models import load_model
from pickle import load
import numpy as np
from PIL import Image
import base64, time, json, io

def extract_features(filename, model):
    try:
        image = Image.open(filename)

    except:
        print("ERROR: Couldn't open image! Make sure the image path and extension is correct")

    image = image.resize((299,299))
    image = np.array(image)
    # for images that has 4 channels, we convert them into 3 channels
    if image.shape[2] == 4: 
        image = image[..., :3]
    image = np.expand_dims(image, axis=0)
    image = image/127.5
    image = image - 1.0
    feature = model.predict(image)
    return feature

def word_for_id(integer, tokenizer):
    for word, index in tokenizer.word_index.items():
        if index == integer:
            return word
    return None

def generate_desc(model, tokenizer, photo, max_length):
    in_text = 'start'
    for i in range(max_length):
        sequence = tokenizer.texts_to_sequences([in_text])[0]
        sequence = pad_sequences([sequence], maxlen=max_length)
        pred = model.predict([photo,sequence], verbose=0)
        pred = np.argmax(pred)
        word = word_for_id(pred, tokenizer)
        if word is None:
            break
        in_text += ' ' + word
        if word == 'end':
            break
    return in_text


class predict(APIView):

    def post(self, request):

        if request.method == 'POST':
            # get data from request object (what we passed in from the frontend)
            data = request.data
            image = data['image']

            filename = "media/uploads/{}".format(time.time_ns()) + '.jpg'
            with open(filename, "wb") as fh:
                fh.write(base64.b64decode(image))

            max_length = 32
            xception_model = Xception(include_top=False, pooling="avg")

            photo = extract_features(filename, xception_model)

            description = generate_desc(CaptionerConfig.model, CaptionerConfig.tokenizer, photo, max_length)
            description = description[6:-4]

            result = {
                "description": description.capitalize(),
            }

            return Response(result, status=status.HTTP_200_OK)


