from flask import Flask, request, jsonify, Response, send_file
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from keras.applications.xception import Xception
from keras.models import load_model
from pickle import load
import numpy as np
from PIL import Image
import json
import base64
import time

app = Flask(__name__)
static_dir = 'images/'



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


@app.route("/")
def predict(img_path):
    max_length = 32
    tokenizer = load(open("tokenizer.p","rb"))
    model = load_model('model_9.h5')
    xception_model = Xception(include_top=False, pooling="avg")

    photo = extract_features(img_path, xception_model)

    description = generate_desc(model, tokenizer, photo, max_length)
    description = description[6:-4]

    return description

@app.route('/api', methods=['GET', 'POST'])
def apiHome():
    r = request.method
    if r=="GET":
        with open("text/data.json") as f:
            data = json.load(f)
        return data
    elif r == 'POST':
        timestamp = int(time.time())
        with open(static_dir+str(timestamp)+'.jpg', "wb") as fh:
            fh.write(base64.decodebytes(request.data))
        filename = static_dir+str(timestamp)+'.jpg'

        max_length = 32
        tokenizer = load(open("tokenizer.p","rb"))
        model = load_model('model_9.h5')
        xception_model = Xception(include_top=False, pooling="avg")

        photo = extract_features(filename, xception_model)

        description = generate_desc(model, tokenizer, photo, max_length)
        description = description[6:-4]

        cap={"captions": description}
        with open("text/data.json", "w") as fjson:
            json.dump(cap, fjson)
        return description
    else:
        return jsonify({"captions": description})

@app.route('/result')
def sendImage():
    timestamp = int(time.time())
    return send_file(static_dir+str(timestamp)+'.jpg', mimetype='image/gif')

if __name__=='__main__':
    app.run(debug=True, host='172.16.4.171', port=8000)