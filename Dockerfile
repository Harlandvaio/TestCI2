# 使用輕量級的 nginx alpine 版本
FROM nginx:alpine

# 將我們的設定檔複製到容器內
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 將網頁內容複製到 nginx 預設路徑
COPY html/ /usr/share/nginx/html/

# 暴露 80 埠
EXPOSE 80