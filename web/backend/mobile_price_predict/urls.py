from django.contrib import admin
from django.urls import path
from .view import predict_view
urlpatterns = [
    path('predict/', predict_view)
]
