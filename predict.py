import pickle
import pandas as pd

with open('number_normal_scaler.pkl', 'rb') as f:
    number_normal_scaler = pickle.load(f)
with open('regressor_model.pkl', 'rb') as f:
    regressor_model = pickle.load(f)

vars_normalizing = ['RAM', 'ROM', 'Batery', 'Screen resolution']


def get_predict_price(typ=1, chip=0, RAM=0, ROM=0, bat=0, OS=0, scr=0, net=4.0):
    data = {'Screen type': [typ],
            'Chip': [chip],
            'RAM': [RAM],
            'ROM': [ROM],
            'Batery': [bat],
            'OS': [OS],
            'Screen resolution': [scr],
            'Mobile network': [net],
            }
    df = pd.DataFrame(data)

    df[vars_normalizing] = number_normal_scaler.transform(
        df[vars_normalizing])
    print(df)
    predict_price = regressor_model.predict(df)
    return predict_price[0]


print(get_predict_price(1, 3, 8192.000000,
      262144.000000, 5000.000000, 0, 2.592000e+06, 4.0))
print(get_predict_price(0, 0, 4096.000000,
      65536.000000, 3110.000000, 1, 1.483776e+06, 4.0))
