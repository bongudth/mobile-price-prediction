from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from .serializers import MobileSerializer
from .predict import get_predict_price


@api_view(['POST'])
def predict_view(request):
    serializer = MobileSerializer(data=request.data)
    if serializer.is_valid():
        mobile = serializer.data
        price = get_predict_price(typ=mobile["scr_type"], chip=mobile["chip"], RAM=mobile["RAM"], ROM=mobile["ROM"],
                                  bat=mobile["battery"], OS=mobile["OS"], scr=mobile["scr_res"], net=mobile["net"])
        return Response({"price": price}, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
