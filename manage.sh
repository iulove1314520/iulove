#!/bin/bash

# 版本信息
VERSION="1.0.0"
SCRIPT_NAME="系统管理脚本"

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 打印函数
print_message() { echo -e "${GREEN}[INFO] $1${NC}"; }
print_warning() { echo -e "${YELLOW}[WARN] $1${NC}"; }
print_error() { echo -e "${RED}[ERROR] $1${NC}"; }

# 等待用户按键
wait_for_key() {
    echo
    read -n 1 -s -r -p "按任意键继续..."
    echo
}

# 检查是否为root用户
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "请使用root权限运行此脚本"
        exit 1
    fi
}

# 显示主菜单
show_main_menu() {
    clear
    echo -e "${BLUE}${SCRIPT_NAME} v${VERSION}${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    echo "请选择要管理的模块："
    echo "1) Docker 管理"
    echo "2) 系统信息"
    echo "3) 网络工具"
    echo "4) 服务管理"
    echo "5) 系统配置"
    echo "6) Nginx管理"
    echo "7) 退出"
    echo
    echo -e "${BLUE}================================${NC}"
    read -p "请输入选项 [1-7]: " choice

    case $choice in
        1) 
            docker_management
            ;;
        2) show_system_info ;;
        3) network_tools ;;
        4) service_management ;;
        5) system_config ;;
        6) nginx_management ;;
        7) 
            echo "退出脚本"
            exit 0
            ;;
        *) 
            print_error "无效的选项"
            sleep 2
            ;;
    esac
}

# 显示系统信息
show_system_info() {
    clear
    echo -e "${BLUE}系统信息${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    
    # CPU信息
    echo -e "${GREEN}CPU 信息:${NC}"
    echo "处理器: $(grep "model name" /proc/cpuinfo | head -n1 | cut -d: -f2)"
    echo "核心数: $(nproc)"
    echo
    
    # 内存信息
    echo -e "${GREEN}内存信息:${NC}"
    free -h
    echo
    
    # 磁盘信息
    echo -e "${GREEN}磁盘使用情况:${NC}"
    df -h
    echo
    
    # 系统信息
    echo -e "${GREEN}系统信息:${NC}"
    echo "操作系统: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "内核版本: $(uname -r)"
    echo "系统时间: $(date)"
    echo
    
    wait_for_key
}

# 网络工具
network_tools() {
    while true; do
        clear
        echo -e "${BLUE}网络工具${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择工具："
        echo "1) 网络连接测试"
        echo "2) 查看网络接口"
        echo "3) 查看路由表"
        echo "4) 查看网络连接状态"
        echo "5) 返回主菜单"
        echo
        read -p "请输入选项 [1-5]: " choice

        case $choice in
            1)
                echo
                read -p "请输入要测试的地址: " target
                ping -c 4 $target
                wait_for_key
                ;;
            2)
                echo
                ip addr show
                wait_for_key
                ;;
            3)
                echo
                ip route
                wait_for_key
                ;;
            4)
                echo
                netstat -tunlp
                wait_for_key
                ;;
            5) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 服务管理
service_management() {
    while true; do
        clear
        echo -e "${BLUE}服务管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看所有服务状态"
        echo "2) 启动服务"
        echo "3) 停止服务"
        echo "4) 重启服务"
        echo "5) 返回主菜单"
        echo
        read -p "请输入选项 [1-5]: " choice

        case $choice in
            1)
                systemctl list-units --type=service
                wait_for_key
                ;;
            2)
                echo
                read -p "请输入要启动的服务名称: " service_name
                systemctl start $service_name
                wait_for_key
                ;;
            3)
                echo
                read -p "请输入要停止的服务名称: " service_name
                systemctl stop $service_name
                wait_for_key
                ;;
            4)
                echo
                read -p "请输入要重启的服务名称: " service_name
                systemctl restart $service_name
                wait_for_key
                ;;
            5) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 系统配置管理
system_config() {
    while true; do
        clear
        echo -e "${BLUE}系统配置${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 修改主机名"
        echo "2) 查看当前主机名"
        echo "3) 修改hosts文件"
        echo "4) 查看hosts文件"
        echo "5) 返回主菜单"
        echo
        read -p "请输入选项 [1-5]: " choice

        case $choice in
            1)
                echo
                read -p "请输入新的主机名: " new_hostname
                if [ -n "$new_hostname" ]; then
                    # 修改主机名
                    hostnamectl set-hostname "$new_hostname"
                    # 自动更新hosts文件
                    sed -i "s/127.0.0.1.*/127.0.0.1       $new_hostname/" /etc/hosts
                    print_message "主机名已修改为: $new_hostname"
                    print_message "hosts文件已更新"
                else
                    print_error "主机名不能为空"
                fi
                wait_for_key
                ;;
            2)
                echo
                echo "当前主机名: $(hostname)"
                echo "主机名配置详情:"
                hostnamectl status
                wait_for_key
                ;;
            3)
                echo
                echo "当前hosts文件内容:"
                cat /etc/hosts
                echo
                echo "请选择操作："
                echo "1) 添加新的hosts记录"
                echo "2) 修改现有记录"
                echo "3) 返回上级菜单"
                read -p "请选择 [1-3]: " hosts_choice
                
                case $hosts_choice in
                    1)
                        read -p "请输入IP地址: " ip
                        read -p "请输入主机名: " hostname
                        if [ -n "$ip" ] && [ -n "$hostname" ]; then
                            echo "$ip       $hostname" >> /etc/hosts
                            print_message "hosts记录已添加"
                        else
                            print_error "IP或主机名不能为空"
                        fi
                        ;;
                    2)
                        read -p "请输入要修改的主机名: " old_hostname
                        read -p "请输入新的IP地址: " new_ip
                        if [ -n "$old_hostname" ] && [ -n "$new_ip" ]; then
                            sed -i "s/.*$old_hostname/$new_ip       $old_hostname/" /etc/hosts
                            print_message "hosts记录已更新"
                        else
                            print_error "输入不能为空"
                        fi
                        ;;
                    3) continue ;;
                    *) print_error "无效的选项" ;;
                esac
                wait_for_key
                ;;
            4)
                echo
                echo "hosts文件内容:"
                echo "----------------"
                cat /etc/hosts
                echo "----------------"
                wait_for_key
                ;;
            5) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# Nginx管理模块
nginx_management() {
    while true; do
        clear
        echo -e "${BLUE}Nginx管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 安装/更新 Nginx"
        echo "2) Nginx状态管理"
        echo "3) 配置管理"
        echo "4) SSL证书管理"
        echo "5) 日志管理"
        echo "6) 性能优化"
        echo "7) 安全配置"
        echo "8) 查看状态"
        echo "9) 卸载 Nginx"
        echo "10) 返回主菜单"
        echo
        read -p "请输入选项 [1-10]: " choice

        case $choice in
            1)
                clear
                echo "正在安装/更新Nginx..."
                apt-get update
                apt-get install -y nginx certbot python3-certbot-nginx nginx-extras
                systemctl enable nginx
                systemctl start nginx
                
                # 创建自定义配置目录
                mkdir -p /etc/nginx/conf.d/custom
                
                # 备份默认配置
                cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
                
                print_message "Nginx安装/更新完成"
                wait_for_key
                ;;
            2)
                while true; do
                    clear
                    echo "Nginx状态管理"
                    echo "1) 启动Nginx"
                    echo "2) 停止Nginx"
                    echo "3) 重启Nginx"
                    echo "4) 重新加载配置"
                    echo "5) 测试配置文件"
                    echo "6) 返回上级菜单"
                    read -p "请选择操作 [1-6]: " status_choice
                    
                    case $status_choice in
                        1) systemctl start nginx ;;
                        2) systemctl stop nginx ;;
                        3) systemctl restart nginx ;;
                        4) systemctl reload nginx ;;
                        5) nginx -t ;;
                        6) break ;;
                        *) print_error "无效的选项" ;;
                    esac
                    wait_for_key
                done
                ;;
            3)
                while true; do
                    clear
                    echo "配置管理"
                    echo "1) 创建新站点配置"
                    echo "2) 修改现有配置"
                    echo "3) 设置目录权限"
                    echo "4) 启用站点配置"
                    echo "5) 禁用站点配置"
                    echo "6) 返回上级菜单"
                    read -p "请选择操作 [1-6]: " config_choice
                    
                    case $config_choice in
                        1)
                            read -p "请输入域名: " domain
                            read -p "请输入后端容器IP: " container_ip
                            read -p "请输入后端容器端口: " container_port
                            
                            # 创建配置文件
                            cat > "/etc/nginx/sites-available/$domain" <<EOF
server {
    listen 80;
    server_name $domain;

    location / {
        proxy_pass http://${container_ip}:${container_port};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
                            print_message "配置文件已创建"
                            ;;
                        2)
                            read -p "请输入要修改的配置文件名: " config_file
                            if [ -f "/etc/nginx/sites-available/$config_file" ]; then
                                nano "/etc/nginx/sites-available/$config_file"
                            else
                                print_error "配置文件不存在"
                            fi
                            ;;
                        3)
                            read -p "请输入要设置权限的目录路径: " dir_path
                            if [ -d "$dir_path" ]; then
                                chown -R www-data:www-data "$dir_path"
                                print_message "目录权限已设置"
                            else
                                print_error "目录不存在"
                            fi
                            ;;
                        4)
                            read -p "请输入要启用的配置文件名: " config_file
                            if [ -f "/etc/nginx/sites-available/$config_file" ]; then
                                ln -s "/etc/nginx/sites-available/$config_file" "/etc/nginx/sites-enabled/"
                                print_message "配置已启用"
                            else
                                print_error "配置文件不存在"
                            fi
                            ;;
                        5)
                            read -p "请输入要禁用的配置文件名: " config_file
                            if [ -f "/etc/nginx/sites-enabled/$config_file" ]; then
                                rm "/etc/nginx/sites-enabled/$config_file"
                                print_message "配置已禁用"
                            else
                                print_error "配置文件不存在"
                            fi
                            ;;
                        6) break ;;
                        *) print_error "无效的选项" ;;
                    esac
                    wait_for_key
                done
                ;;
            4)
                while true; do
                    clear
                    echo "SSL证书管理"
                    echo "1) 申请新证书"
                    echo "2) 查看现有证书"
                    echo "3) 返回上级菜单"
                    read -p "请选择操作 [1-3]: " ssl_choice
                    
                    case $ssl_choice in
                        1)
                            read -p "请输入域名: " domain
                            certbot --nginx -d "$domain"
                            ;;
                        2)
                            certbot certificates
                            ;;
                        3) break ;;
                        *) print_error "无效的选项" ;;
                    esac
                    wait_for_key
                done
                ;;
            5)
                while true; do
                    clear
                    echo "日志管理"
                    echo "1) 查看访问日志"
                    echo "2) 查看错误日志"
                    echo "3) 清理日志文件"
                    echo "4) 配置日志轮转"
                    echo "5) 分析访问日志"
                    echo "6) 返回上级菜单"
                    read -p "请选择操作 [1-6]: " log_choice
                    
                    case $log_choice in
                        1)
                            tail -f /var/log/nginx/access.log
                            ;;
                        2)
                            tail -f /var/log/nginx/error.log
                            ;;
                        3)
                            echo > /var/log/nginx/access.log
                            echo > /var/log/nginx/error.log
                            print_message "日志已清理"
                            ;;
                        4)
                            cat > /etc/logrotate.d/nginx <<EOF
 /var/log/nginx/*.log {
     daily
     missingok
     rotate 14
     compress
     delaycompress
     notifempty
     create 0640 www-data adm
     sharedscripts
     prerotate
         if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
             run-parts /etc/logrotate.d/httpd-prerotate; \
         fi \
     endscript
     postrotate
         invoke-rc.d nginx rotate >/dev/null 2>&1
     endscript
 }
 EOF
                            print_message "日志轮转已配置"
                            ;;
                        5)
                            echo "访问统计："
                            echo "----------------"
                            echo "访量最大的IP："
                            awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -n 10
                            echo
                            echo "访问最多的URL："
                            awk '{print $7}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -n 10
                            ;;
                        6) break ;;
                        *) print_error "无效的选项" ;;
                    esac
                    wait_for_key
                done
                ;;
            6)
                while true; do
                    clear
                    echo "性能优化"
                    echo "1) 配置工作进程"
                    echo "2) 配置缓存"
                    echo "3) 配置Gzip压缩"
                    echo "4) 配置FastCGI缓存"
                    echo "5) 返回上级菜单"
                    read -p "请选择操作 [1-5]: " perf_choice
                    
                    case $perf_choice in
                        1)
                            worker_processes=$(nproc)
                            cat > /etc/nginx/conf.d/custom/performance.conf <<EOF
worker_processes $worker_processes;
worker_rlimit_nofile 65535;
events {
    worker_connections 65535;
    multi_accept on;
    use epoll;
}
EOF
                            print_message "工作进程已优化"
                            ;;
                        2)
                            cat > /etc/nginx/conf.d/custom/cache.conf <<EOF
proxy_cache_path /tmp/nginx_cache levels=1:2 keys_zone=my_cache:10m max_size=10g inactive=60m use_temp_path=off;
proxy_cache_key "\$scheme\$request_method\$host\$request_uri";
proxy_cache_valid 200 60m;
EOF
                            print_message "缓存已配置"
                            ;;
                        3)
                            cat > /etc/nginx/conf.d/custom/gzip.conf <<EOF
gzip on;
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_types text/plain text/css text/xml application/json application/javascript application/xml+rss application/atom+xml image/svg+xml;
EOF
                            print_message "Gzip压缩已配置"
                            ;;
                        4)
                            cat > /etc/nginx/conf.d/custom/fastcgi_cache.conf <<EOF
fastcgi_cache_path /tmp/nginx_cache_fastcgi levels=1:2 keys_zone=my_fastcgi_cache:10m max_size=10g inactive=60m use_temp_path=off;
fastcgi_cache_key "\$scheme\$request_method\$host\$request_uri";
fastcgi_cache_valid 200 60m;
EOF
                            print_message "FastCGI缓存已配置"
                            ;;
                        5) break ;;
                        *) print_error "无效的选项" ;;
                    esac
                    systemctl reload nginx
                    wait_for_key
                done
                ;;
            7)
                while true; do
                    clear
                    echo "安全配置"
                    echo "1) 配置基本安全头"
                    echo "2) 配置SSL安全参数"
                    echo "3) 配置访问限制"
                    echo "4) 配置防DDoS参数"
                    echo "5) 返回上级菜单"
                    read -p "请选择操作 [1-5]: " security_choice
                    
                    case $security_choice in
                        1)
                            cat > /etc/nginx/conf.d/custom/security_headers.conf <<EOF
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
EOF
                            print_message "安全头已配置"
                            ;;
                        2)
                            cat > /etc/nginx/conf.d/custom/ssl.conf <<EOF
ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers on;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;
EOF
                            print_message "SSL安全参数已配置"
                            ;;
                        3)
                            read -p "请输入允许访问的IP地址(用逗号分隔): " allowed_ips
                            cat > /etc/nginx/conf.d/custom/access_control.conf <<EOF
# 允许的IP
allow $allowed_ips;
# 禁止其他所有IP
deny all;
EOF
                            print_message "访问限制已配置"
                            ;;
                        4)
                            cat > /etc/nginx/conf.d/custom/ddos.conf <<EOF
# 限制每个IP的并发连接数
limit_conn_zone \$binary_remote_addr zone=conn_limit_per_ip:10m;
limit_conn conn_limit_per_ip 10;

# 限制请求频率
limit_req_zone \$binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;
limit_req zone=req_limit_per_ip burst=10 nodelay;
EOF
                            print_message "防DDoS参数已配置"
                            ;;
                        5) break ;;
                        *) print_error "无效的选项" ;;
                    esac
                    systemctl reload nginx
                    wait_for_key
                done
                ;;
            8)
                clear
                echo "Nginx状态信息："
                echo "----------------"
                echo "进程信息："
                ps -eo user,group,comm | grep nginx
                echo
                echo "监听端口："
                netstat -tulpn | grep nginx
                echo
                echo "资源使用："
                top -b -n 1 | grep nginx
                echo
                echo "配置文件语法检查："
                nginx -t
                wait_for_key
                ;;
            9)
                clear
                echo -e "${RED}警告: 此操作将完全删除Nginx及其所有配置文件${NC}"
                read -p "确定要卸载Nginx吗？(y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    # 停止Nginx服务
                    systemctl stop nginx
                    systemctl disable nginx
                    
                    # 卸载Nginx包
                    apt-get purge -y nginx nginx-common nginx-full nginx-extras certbot python3-certbot-nginx
                    apt-get autoremove -y
                    
                    # 删除配置文件和日志
                    rm -rf /etc/nginx
                    rm -rf /var/log/nginx
                    rm -rf /var/www/html
                    rm -f /etc/logrotate.d/nginx
                    
                    # 删除缓存目录
                    rm -rf /var/cache/nginx
                    
                    # 删除SSL证书（可选）
                    read -p "是否同时删除SSL证书？(y/n): " del_ssl
                    if [ "$del_ssl" = "y" ] || [ "$del_ssl" = "Y" ]; then
                        rm -rf /etc/letsencrypt
                    fi
                    
                    print_message "Nginx已完全卸载"
                else
                    print_message "取消卸载操作"
                fi
                wait_for_key
                ;;
            10)
                return
                ;;
            *) 
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# Docker管理模块
docker_management() {
    while true; do
        clear
        echo -e "${BLUE}Docker 管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 安装 Docker"
        echo "2) 卸载 Docker"
        echo "3) 更新 Docker"
        echo "4) 查看 Docker 状态"
        echo "5) 管理容器"
        echo "6) 返回主菜单"
        echo
        echo -e "${BLUE}================================${NC}"
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1)
                read -p "确认安装 Docker? (y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    check_network
                    detect_os
                    install_docker
                    configure_docker_mirror
                    verify_docker_installation
                else
                    print_message "取消安装"
                fi
                wait_for_key
                ;;
            2)
                read -p "警告：这将删除所有 Docker 数据！确认卸载? (y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    uninstall_docker
                else
                    print_message "取消卸载"
                fi
                wait_for_key
                ;;
            3)
                read -p "确认更新 Docker? (y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    check_network
                    detect_os
                    update_docker
                else
                    print_message "取消更新"
                fi
                wait_for_key
                ;;
            4)
                show_docker_status
                wait_for_key
                ;;
            5)
                manage_docker_containers
                ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 检测操作系统
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
        case "$OS" in
            *"Ubuntu"*) DISTRO="ubuntu" ;;
            *"Debian"*) DISTRO="debian" ;;
            *"CentOS"*|*"Red Hat"*|*"Fedora"*) DISTRO="centos" ;;
            *) 
                if [ -f /etc/redhat-release ]; then
                    DISTRO="centos"
                else
                    print_error "不支持的操作系统: $OS"
                    exit 1
                fi
                ;;
        esac
    elif [ "$(uname)" == "Darwin" ]; then
        DISTRO="darwin"
    else
        print_error "无法确定操作系统类型"
        exit 1
    fi
}

# 安装Docker
install_docker() {
    print_message "开始安装 Docker..."
    
    if command -v docker &> /dev/null; then
        print_warning "Docker 已经安装，跳过安装步骤"
        return
    fi

    case $DISTRO in
        "ubuntu"|"debian")
            # 安装依赖
            apt-get update
            apt-get install -y \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg \
                lsb-release

            # 添加 Docker 官方 GPG 密钥
            curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

            # 设置稳定版仓库
            echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$DISTRO \
                $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

            # 更新包索引
            apt-get update

            # 安装 Docker Engine
            apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
            
        "centos")
            yum install -y yum-utils
            yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
            
        "darwin")
            brew install --cask docker
            print_message "请手动启动 Docker Desktop"
            return
            ;;
    esac

    # 启动并启用 Docker 服务
    systemctl start docker
    systemctl enable docker
}

# 配置Docker镜像加速
configure_docker_mirror() {
    print_message "配置Docker镜像加速..."
    
    mkdir -p /etc/docker
    cat > /etc/docker/daemon.json <<'EOF'
{
    "registry-mirrors": [
        "https://docker.mirrors.ustc.edu.cn",
        "https://hub-mirror.c.163.com",
        "https://mirror.baidubce.com"
    ]
}
EOF
    
    systemctl daemon-reload
    systemctl restart docker
}

# 卸载Docker
uninstall_docker() {
    print_message "开始卸载 Docker..."
    
    if ! command -v docker &> /dev/null; then
        print_warning "Docker 未安装，无需卸载"
        return
    fi

    # 停止所有容器
    print_message "停止所有运行中的容器..."
    docker ps -q | xargs -r docker stop
    
    # 删除所有容器
    print_message "删除所有容器..."
    docker ps -a -q | xargs -r docker rm
    
    # 删除所有镜像
    print_message "删除所有镜像..."
    docker images -q | xargs -r docker rmi -f
    
    # 删除所有卷
    print_message "删除所有数据卷..."
    docker volume ls -q | xargs -r docker volume rm
    
    # 删除所有网络
    print_message "删除所有自定义网络..."
    docker network ls -q | xargs -r docker network rm

    case $DISTRO in
        "ubuntu"|"debian")
            apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            apt-get autoremove -y
            ;;
        "centos")
            yum remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
        "darwin")
            brew uninstall --cask docker
            print_message "请手动删除Docker Desktop应用"
            return
            ;;
    esac

    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
    rm -rf /etc/docker
    rm -rf ~/.docker
}

# 更新Docker
update_docker() {
    print_message "开始更新 Docker..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker 未安装，请先安装"
        return
    fi

    # 获取当前版本
    OLD_VERSION=$(docker --version | cut -d ' ' -f3 | tr -d ',')
    print_message "当前Docker版本: $OLD_VERSION"

    case $DISTRO in
        "ubuntu"|"debian")
            # 更新软件源
            apt-get update
            
            # 检查是否有可用更新
            if apt-cache policy docker-ce | grep -q "Installed: $(apt-cache policy docker-ce | grep Candidate | awk '{print $2}')"; then
                print_message "Docker 已经是最新版本"
                return
            fi
            
            print_message "发现新版本，开始更新..."
            apt-get install -y --only-upgrade \
                docker-ce \
                docker-ce-cli \
                containerd.io \
                docker-compose-plugin
            ;;
        "centos")
            # 检查更新
            if ! yum check-update docker-ce docker-ce-cli containerd.io docker-compose-plugin | grep -q '^docker-\|^containerd'; then
                print_message "Docker 已经是最新版本"
                return
            fi
            
            print_message "发现新版本，开始更新..."
            yum update -y \
                docker-ce \
                docker-ce-cli \
                containerd.io \
                docker-compose-plugin
            ;;
        "darwin")
            brew upgrade --cask docker
            print_warning "如果Docker Desktop有更新，请手动重启应用"
            ;;
    esac

    if [ "$DISTRO" != "darwin" ]; then
        print_message "重启 Docker 服务..."
        systemctl restart docker
        sleep 3
    fi

    # 获取新版本并显示对比
    NEW_VERSION=$(docker --version | cut -d ' ' -f3 | tr -d ',')
    if [ "$OLD_VERSION" = "$NEW_VERSION" ]; then
        print_message "更新完成，版本未变: $NEW_VERSION"
    else
        print_message "更新成功: $OLD_VERSION -> $NEW_VERSION"
    fi
}

# 验证Docker安装
verify_docker_installation() {
    print_message "验证安装..."
    
    # 等待服务完全启动
    sleep 3
    
    # 检查Docker版本
    if ! docker --version; then
        print_error "Docker 安装失败"
        exit 1
    fi
    
    # 检查Docker Compose版本
    if ! docker compose version; then
        print_error "Docker Compose 安装失败"
        exit 1
    fi
    
    print_message "安装验证完成"
}

# 显示Docker状态
show_docker_status() {
    print_message "Docker 状态信息："
    echo
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker 已安装${NC}"
        echo "Docker 版本："
        docker --version
        echo
        echo "Docker Compose 版本："
        docker compose version
        echo
        echo "运行中的容器："
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo
        echo "系统信息："
        docker info | grep -E "Server Version|Storage Driver|Operating System|CPUs|Total Memory"
    else
        echo -e "${RED}Docker 未安装${NC}"
    fi
}

# 管理Docker容器
manage_docker_containers() {
    while true; do
        clear
        echo -e "${BLUE}Docker 容器管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        
        # 检查Docker是否安装
        if ! command -v docker &> /dev/null; then
            print_error "Docker 未安装，请先安装 Docker"
            wait_for_key
            return
        fi

        # 显示容器列表
        echo "容器列表："
        echo -e "${BLUE}--------------------------------${NC}"
        printf "%-6s %-15s %-25s %-20s %-30s %-20s\n" "序号" "容器ID" "容器名称" "状态" "端口" "镜像"
        echo -e "${BLUE}--------------------------------${NC}"
        
        # 获取容器列表并编号
        containers=()
        i=1
        while IFS= read -r line; do
            containers+=("$line")
            container_id=$(echo "$line" | cut -f1)
            container_name=$(echo "$line" | cut -f2)
            container_status=$(echo "$line" | cut -f3)
            container_ports=$(echo "$line" | cut -f4)
            container_image=$(echo "$line" | cut -f5)
            # 格式化状态显示
            status_color="${GREEN}"
            if [[ "$container_status" == *"Exited"* ]]; then
                status_color="${RED}"
            elif [[ "$container_status" == *"Restarting"* ]]; then
                status_color="${YELLOW}"
            fi
            printf "%-6s %-15s %-25s ${status_color}%-20s${NC} %-30s %-20s\n" \
                "$i)" \
                "$container_id" \
                "$container_name" \
                "$container_status" \
                "${container_ports:-无}" \
                "$container_image"
            ((i++))
        done < <(docker ps -a --format "{{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}")

        if [ $i -eq 1 ]; then
            echo "当前没有任何容器"
        fi

        echo -e "${BLUE}================================${NC}"
        echo "操作选项："
        echo "1) 启动容器"
        echo "2) 停止容器"
        echo "3) 重启容器"
        echo "4) 删除容器"
        echo "5) 查看容器日志"
        echo "6) 进入容器内部"
        echo "7) 返回上级菜单"
        echo

        read -p "请选择操作 [1-7]: " op_choice
        
        if [ "$op_choice" = "7" ]; then
            return
        fi

        if [ ${#containers[@]} -eq 0 ]; then
            print_warning "没有可用的容器"
            wait_for_key
            continue
        fi

        echo
        read -p "请选择容器序号 [1-$((i-1))]: " container_num
        
        if [ "$container_num" -ge 1 ] && [ "$container_num" -lt "$i" ]; then
            selected_container=$(echo "${containers[$((container_num-1))]}" | awk '{print $1}')
            
            case $op_choice in
                1)
                    docker start $selected_container
                    print_message "容器已启动"
                    ;;
                2)
                    docker stop $selected_container
                    print_message "容器已停止"
                    ;;
                3)
                    docker restart $selected_container
                    print_message "容器已重启"
                    ;;
                4)
                    read -p "是否同时删除容器的数据卷？(y/n): " del_volumes
                    if [ "$del_volumes" = "y" ] || [ "$del_volumes" = "Y" ]; then
                        docker rm -v $selected_container
                    else
                        docker rm $selected_container
                    fi
                    print_message "容器已删除"
                    ;;
                5)
                    echo "按 Ctrl+C 退出日志查看"
                    sleep 2
                    docker logs -f $selected_container
                    ;;
                6)
                    echo "进入容器内部，输入 'exit' 退出"
                    echo "按 Enter 继续..."
                    read
                    docker exec -it $selected_container /bin/sh -c "if command -v bash >/dev/null; then bash; else sh; fi"
                    ;;
            esac
        else
            print_error "无效的容器序号"
        fi
        
        wait_for_key
    done
}

# 主循环
main() {
    check_root
    
    while true; do
        show_main_menu
    done
}

# 捕获Ctrl+C
trap_ctrlc() {
    echo
    print_message "检测到Ctrl+C，正在退出..."
    exit 0
}

# 设置Ctrl+C捕获
trap trap_ctrlc INT

# 执行主函数
main 