import os

# 設定目標資料夾的路徑
folder_path = 'image'

# 取得資料夾中的所有檔案名稱
file_list = os.listdir(folder_path)

# 過濾出所有的檔案（不包括子資料夾）
file_list = [f for f in file_list if os.path.isfile(os.path.join(folder_path, f))]

# 逐一更改檔名
for i, filename in enumerate(file_list):
    # 取得新檔名
    new_filename = f"{i + 1}img_.png"
    
    # 取得舊檔案的完整路徑和新檔案的完整路徑
    old_file = os.path.join(folder_path, filename)
    new_file = os.path.join(folder_path, new_filename)
    
    # 更改檔名
    os.rename(old_file, new_file)

print("檔名更改完成！")
