
# 📱 Dự đoán giá điện thoại

## ⚒ Các thư viện cần cài đặt

| Thư viện  | Lệnh cài đặt                  | Mô tả          |
| :-------  | :---------------------------- | :------------- |
| `bs4`     | `pip install bs4`             | Beautiful Soup |
| `sklearn` | `pip install -U scikit-learn` | scikit-learn   |
| `xgboost` | `pip install xgboost`         | XGBoost        |

## 🚀 Trình tự chạy chương trình

Crawl dữ liệu từ 4 trang web

```bash
  crawl.ipynb
```

Folder lưu trữ các file dữ liệu thô

```bash
  raw_data/
```

Làm sạch đúng kiểu dữ liệu và xử lý dữ liệu trống

```bash
  clean.ipynb
```

Folder lưu trữ dữ liệu được làm sạch

```bash
  clean_data/
```

Chia bộ dữ liệu thành tập train và test, xử lý ngoại lệ, chuẩn hóa dữ liệu, lựa chọn đặc trưng

```bash
  feature_engineering.ipynb
```

Folder lưu trữ các file dữ liệu huấn luyện và kiểm thử

```bash
  train_test_data/
```

Xây dựng mô hình dự đoán giá điện thoại

```bash
  modeling.ipynb
```

## 👨🏽‍💻 Thành viên

- [Ngô Văn Đông](https://github.com/ngovandong)
- [Huỳnh Thị Khánh Linh](https://github.com/bongudth)
- [Nguyễn Minh Dũng](https://github.com/dungngminh)

## ✍🏽 Dữ liệu
 Bộ dữ liệu bao gồm các thông số kỹ thuật, giá bán của điện thoại di động, được thu thập từ:
 - [Thế Giới Di Động](https://www.thegioididong.com/)
 - [CellphoneS](https://cellphones.com.vn/)
 - [Hoàng Hà Mobile](https://hoanghamobile.com/)
 - [Nguyễn Kim](https://www.nguyenkim.com/dien-thoai-di-dong)

## 🔨 Feature engineering
 - Thay thế dữ liệu trống bằng giá trị **mean** cho **dữ liệu dạng số**
 - Thay thế dữ liệu trống bằng giá trị **random** cho **dữ liệu phân loại**
 - Chuyển dữ liệu phân loại thành dữ liệu dạng số sử dụng **LabelEncoder** của *sklearn*
 - Xử lý ngoại lệ sử dụng **IQR** để tìm biên trên và biên dưới của dữ liệu
 - Chuẩn hóa dữ liệu sử dụng **StandardScaler** của *sklearn*

## 💡 Mô hình dự đoán
 - Sử dụng **LinearRegression** của *sklearn*
 - Cải tiến dùng **XGBRegressor** của *xgboost*

## 🧠 Các metrics đánh giá
 - **R2**
 - **RMSE**
 - **MAE**

## ☃️ Kết quả dự đoán

| Mô hình          | R2     | RMSE      | MAE       |
| :--------------- | :----- | :-------- | :-------- |
| LinearRegression | 73.17% | 5241.0791 | 3947.1287 |
| XGBRegressor     | 94.45% | 2383.5217 | 1057.4660 |
