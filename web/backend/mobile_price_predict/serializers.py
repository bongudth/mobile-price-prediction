from rest_framework import serializers

SCREEN_TYPES = [(0, 'LCD'), (1, 'OLED')]
CHIP_TYPES = [(0, 'apple'), (1, 'exynos'), (2, 'mediatek'), (3, 'snapdragon')]
OS_TYPES = [(0, 'android'), (1, 'ios')]


class MobileSerializer(serializers.Serializer):
    scr_type = serializers.ChoiceField(choices=SCREEN_TYPES)
    chip = serializers.ChoiceField(choices=CHIP_TYPES)
    OS = serializers.ChoiceField(choices=OS_TYPES)
    RAM = serializers.IntegerField()
    ROM = serializers.IntegerField()
    scr_res = serializers.IntegerField()
    battery = serializers.IntegerField()
    net = serializers.IntegerField()
