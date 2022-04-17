from django.apps import AppConfig
from django.conf import settings
import os, pickle
from keras.models import load_model
from pickle import load


class CoreConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'core'


class ModelConfig(AppConfig):
    model_path = os.path.join(settings.MODELS_FOLDER, 'model.h5')
    tokenizer_path = os.path.join(settings.MODELS_FOLDER, 'tokenizer.p')

    tokenizer = load(open(settings.MODELS_FOLDER+"tokenizer.p","rb"))
    model = load_model(settings.MODELS_FOLDER+"model.h5")