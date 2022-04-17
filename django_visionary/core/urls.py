from django.urls import path, include

from core import views

urlpatterns = [
    path('predict/', views.predict.as_view()),
]