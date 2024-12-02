#!/bin/bash

# 版本信息
VERSION="1.0.0"
SCRIPT_NAME="系统管理脚本"

# 设置颜色输出
red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}
green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue() {
    echo -e "\033[34m\033[01m$1\033[0m"
}
NC='\033[0m'

# 打印函数
print_message() { green "[INFO] $1"; }
print_warning() { yellow "[WARN] $1"; }
print_error() { red "[ERROR] $1"; }

# 等待用户按键
wait_for_key() {
    echo
    read -n 1 -s -r -p "按任意键继续..."
    echo
}

# 检查是否为root用户
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "请使用 sudo 或 root 权限运行此脚本"
        print_error "某些功能需要 root 权限才能正常工作"
        exit 1
    fi
    
    # 检查是否有写入系统配置的权限
    if ! touch /etc/test_permission 2>/dev/null; then
        print_error "无法写入系统配置目录，某些功能可能无法正常工作"
        exit 1
    else
        rm -f /etc/test_permission
    fi
}

# 显示主菜��
show_main_menu() {
    clear
    blue "${SCRIPT_NAME} v${VERSION}"
    echo "========================================"
    echo
    echo "请选择要管理的模块："
    echo "1) Docker 管理"
    echo "2) 系统监控"
    echo "3) 网络工具"
    echo "4) 服务管理"
    echo "5) 系统配置"
    echo "6) Nginx管理"
    echo "7) 系统优化与维护"
    echo "8) 退出"
    echo
    echo "========================================"
    read -p "请输入选项 [1-8]: " choice

    case $choice in
        1) 
            docker_management
            ;;
        2) show_system_info ;;
        3) network_tools ;;
        4) service_management ;;
        5) system_config ;;
        6) nginx_management ;;
        7) system_optimization_maintenance ;;
        8) 
            echo "退出脚本"
            exit 0
            ;;
        *) 
            print_error "无效的选项"
            sleep 2
            ;;
    esac
}

# 系统监控函数优化
show_system_info() {
    while true; do
        clear
        echo -e "${BLUE}系统监控${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择监控项目："
        echo "1) 系统详细信息"
        echo "2) 实时系统负载"
        echo "3) 系统资源监控"
        echo "4) 进程管理"
        echo "5) 磁盘管理"
        echo "6) 网络监控"
        echo "7) 系统日志"
        echo "8) 性能统计"
        echo "9) 返回主菜单"
        echo
        read -p "请输入选项 [1-9]: " choice

        case $choice in
            1) show_system_details ;;
            2) show_system_load ;;
            3) monitor_resources ;;
            4) process_management ;;
            5) disk_management ;;
            6) network_monitoring ;;
            7) system_logs ;;
            8) show_performance_stats ;;
            9) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 显示系统详细信息
show_system_details() {
    clear
    echo -e "${BLUE}系统详细信息${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    
    # 系统基本信息
    echo -e "${GREEN}系统基本信息:${NC}"
    echo "操作系统: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "内核版本: $(uname -r)"
    echo "主机名: $(hostname)"
    echo "系统架构: $(uname -m)"
    echo "系统时间: $(date)"
    echo "运行时间: $(uptime -p)"
    echo
    
    # CPU信息
    echo -e "${GREEN}CPU信息:${NC}"
    echo "处理器型号: $(cat /proc/cpuinfo | grep 'model name' | head -n1 | cut -d':' -f2)"
    echo "CPU核心数: $(nproc)"
    echo "CPU使用率: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
    echo
    
    # 内存信息
    echo -e "${GREEN}内存信息:${NC}"
    free -h
    echo
    
    # 磁盘信息
    echo -e "${GREEN}磁盘使用情况:${NC}"
    df -h
    echo
    
    # 网络信息
    echo -e "${GREEN}网络接口信息:${NC}"
    ip -br addr
    echo
    
    # 系统负载
    echo -e "${GREEN}系统负载:${NC}"
    uptime
    echo
    
    wait_for_key
}

# 系统资源监控
monitor_resources() {
    clear
    echo -e "${BLUE}系统资源实时监控${NC}"
    echo -e "${BLUE}================================${NC}"
    echo "按 Ctrl+C 退出监控"
    echo
    
    while true; do
        clear
        # CPU使用率
        echo -e "${GREEN}CPU使用率:${NC}"
        mpstat 1 1 | tail -n 1
        echo
        
        # 内存使用
        echo -e "${GREEN}内存使用情况:${NC}"
        free -h
        echo
        
        # 磁盘IO
        echo -e "${GREEN}磁盘IO:${NC}"
        iostat -x 1 1
        echo
        
        # 网络流量
        echo -e "${GREEN}网络流量:${NC}"
        sar -n DEV 1 1
        
        sleep 2
    done
}

# 新增性能统计功能
show_performance_stats() {
    clear
    echo -e "${BLUE}系统性能统计${NC}"
    echo -e "${BLUE}================================${NC}"
    
    # CPU使用率历史
    echo -e "${GREEN}CPU使用率历史（最近5分钟）:${NC}"
    sar -u 1 5
    echo
    
    # 内存使用历史
    echo -e "${GREEN}内存使用历史:${NC}"
    vmstat 1 5
    echo
    
    # IO统计
    echo -e "${GREEN}磁盘IO统计:${NC}"
    iostat -x 1 5
    echo
    
    # 网络统计
    echo -e "${GREEN}网络流量统计:${NC}"
    sar -n DEV 1 5
    
    wait_for_key
}

# 显示基础系统信息
show_basic_info() {
    clear
    echo -e "${BLUE}基础系统信息${NC}"
    echo -e "${BLUE}================================${NC}"
    
    # CPU信息
    echo -e "${GREEN}CPU 信息:${NC}"
    echo "处理器: $(grep "model name" /proc/cpuinfo | head -n1 | cut -d: -f2)"
    echo "核心数: $(nproc)"
    echo "CPU使用率: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
    echo
    
    # 内存信息
    echo -e "${GREEN}内存信息:${NC}"
    free -h
    echo
    
    # 系统负载
    echo -e "${GREEN}系统负载:${NC}"
    uptime
    echo
    
    # 系统信息
    echo -e "${GREEN}系统信息:${NC}"
    echo "操作系统: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "内核版本: $(uname -r)"
    echo "系统时间: $(date)"
    echo "运行时间: $(uptime -p)"
    echo "登录用户: $(who | wc -l) 个"
    echo
    
    wait_for_key
}

# 显示实时系统负载
show_system_load() {
    clear
    echo -e "${BLUE}实时系统负载监控${NC}"
    echo -e "${BLUE}================================${NC}"
    echo "按 Ctrl+C 退出监控"
    echo
    
    # 使用 watch 命令实时显示系统负载
    watch -n 1 "echo '系统负载:'; uptime; \
                echo; \
                echo 'CPU使用率:'; top -bn1 | head -n3 | tail -n2; \
                echo; \
                echo '内存使用:'; free -h | head -n2; \
                echo; \
                echo '磁盘IO:'; iostat -x 1 1 | tail -n3"
}

# 进程管理
process_management() {
    while true; do
        clear
        echo -e "${BLUE}进程管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看所有进程"
        echo "2) 查看资源占用前10进程"
        echo "3) 查找特定进程"
        echo "4) 结束进程"
        echo "5) 改进程优先级"
        echo "6) 返回上级菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1)
                ps aux
                ;;
            2)
                echo "CPU占用前10的进程："
                ps aux --sort=-%cpu | head -n 11
                echo
                echo "内存占用前10的进程："
                ps aux --sort=-%mem | head -n 11
                ;;
            3)
                read -p "请输入进程名称或关键字: " process_name
                ps aux | grep "$process_name" | grep -v grep
                ;;
            4)
                read -p "请输入要结束的进程PID: " pid
                read -p "确认结束进程 $pid? (y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    kill -15 $pid
                    print_message "已发送终止信号给进程 $pid"
                fi
                ;;
            5)
                read -p "请输入进程PID: " pid
                read -p "请输入新的优先级(-20到19): " priority
                renice $priority $pid
                print_message "已修改进程 $pid 的优先级为 $priority"
                ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# 磁盘管理
disk_management() {
    while true; do
        clear
        echo -e "${BLUE}磁盘管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看磁盘使用情况"
        echo "2) 查看磁盘分区信息"
        echo "3) 查看目录大小"
        echo "4) 查看IO状态"
        echo "5) 文件系统检查"
        echo "6) 返回上级菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1)
                df -h
                ;;
            2)
                fdisk -l
                ;;
            3)
                read -p "请输入目录路径: " dir_path
                du -sh "$dir_path"/*
                ;;
            4)
                iostat -x 1 5
                ;;
            5)
                read -p "请输入要检查的分区（如 /dev/sda1）: " partition
                fsck -f $partition
                ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# 网络工具优化
network_tools() {
    while true; do
        clear
        echo -e "${BLUE}网络工具${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择工具："
        echo "1) 网络连接测试"
        echo "2) 网络接口管理"
        echo "3) 防火墙管理"
        echo "4) 网络诊断"
        echo "5) 网络优化"
        echo "6) 返回主菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1) network_test ;;
            2) interface_management ;;
            3) firewall_management ;;
            4) network_diagnostics ;;
            5) network_optimization ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 新增网络诊断功能
network_diagnostics() {
    clear
    echo -e "${BLUE}网络诊断${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    
    # 检查DNS
    echo -e "${GREEN}DNS 检查:${NC}"
    cat /etc/resolv.conf
    echo
    
    # 检查路由
    echo -e "${GREEN}路由表检查:${NC}"
    ip route
    echo
    
    # 检查网络接口
    echo -e "${GREEN}网络接口状态:${NC}"
    ip -s link
    echo
    
    # 检查网络连接
    echo -e "${GREEN}网络连���状态:${NC}"
    ss -tuln
    
    wait_for_key
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
        echo "5) 时区和时间设置"
        echo "6) 返回主菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1)
                echo
                read -p "请输入新的主机名: " new_hostname
                if [ -n "$new_hostname" ]; then
                    hostnamectl set-hostname "$new_hostname"
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
                        read -p "请输入要修����的主机��: " old_hostname
                        read -p "请输入新的IP地址: " new_ip
                        sed -i "s/.*$old_hostname/$new_ip    $old_hostname/" /etc/hosts
                        print_message "hosts记录已修改"
                        ;;
                    3) ;;
                    *) print_error "无效的选项" ;;
                esac
                wait_for_key
                ;;
            4)
                echo
                echo "当前hosts文件内容:"
                cat /etc/hosts
                wait_for_key
                ;;
            5)
                while true; do
                    clear
                    echo -e "${BLUE}时区和时间设置${NC}"
                    echo -e "${BLUE}================================${NC}"
                    echo
                    echo "当前时区: $(timedatectl | grep "Time zone")"
                    echo "当前时间: $(date)"
                    echo
                    echo "请选择操作："
                    echo "1) 设置时区"
                    echo "2) 同步系统时间"
                    echo "3) 手动设置时间"
                    echo "4) 返回上级菜单"
                    echo
                    read -p "请输入选项 [1-4]: " time_choice
                    
                    case $time_choice in
                        1)
                            select_timezone
                            ;;
                        2)
                            if [ -f /etc/debian_version ]; then
                                apt install -y ntpdate
                            elif [ -f /etc/redhat-release ]; then
                                yum install -y ntpdate
                            fi
                            ntpdate pool.ntp.org
                            hwclock --systohc
                            print_message "系统时间已同步"
                            ;;
                        3)
                            read -p "请输入日期和时间 (格式: YYYY-MM-DD HH:MM:SS): " datetime
                            date -s "$datetime"
                            hwclock --systohc
                            print_message "系统时间已设置"
                            ;;
                        4) break ;;
                        *)
                            print_error "无效的选项"
                            sleep 2
                            ;;
                    esac
                    wait_for_key
                done
                ;;
            6) return ;;
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
                        *) print_error "效的选项" ;;
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
                            echo "访问量最大的IP："
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

# Docker 管理主函数
docker_management() {
    while true; do
        clear
        echo -e "${BLUE}Docker 管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择要管理的内容："
        echo "1) Docker 安装与更新"
        echo "2) Docker Compose 管理"
        echo "3) 容器管理"
        echo "4) 镜像管理"
        echo "5) 网络管理"
        echo "6) 资源管理"
        echo "7) 系统信息"
        echo "8) 返回主菜单"
        echo
        read -p "请输入选项 [1-8]: " choice

        case $choice in
            1) docker_installation_menu ;;
            2) docker_compose_menu ;;
            3) manage_docker_containers ;;
            4) docker_image_management ;;
            5) docker_network_management ;;
            6) docker_resource_management ;;
            7) show_docker_status ;;
            8) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# Docker 安装与更新菜单
docker_installation_menu() {
    while true; do
        clear
        echo -e "${BLUE}Docker 安装与更新${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 安装 Docker"
        echo "2) 更新 Docker"
        echo "3) 卸载 Docker"
        echo "4) 配置镜像加速"
        echo "5) 返回上级菜单"
        echo
        read -p "请输入选项 [1-5]: " choice

        case $choice in
            1) install_docker && configure_docker_mirror && verify_docker_installation ;;
            2) update_docker ;;
            3) uninstall_docker ;;
            4) configure_docker_mirror ;;
            5) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# Docker Compose 管理菜单
docker_compose_menu() {
    while true; do
        clear
        echo -e "${BLUE}Docker Compose 管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 安装 Docker Compose"
        echo "2) 更新 Docker Compose"
        echo "3) 卸载 Docker Compose"
        echo "4) Compose 项目管理"
        echo "5) 返回上级菜单"
        echo
        read -p "请输入选项 [1-5]: " choice

        case $choice in
            1) install_docker_compose ;;
            2) update_docker_compose ;;
            3) uninstall_docker_compose ;;
            4) docker_compose_project_management ;;
            5) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# 安装 Docker Compose
install_docker_compose() {
    print_message "开始安装 Docker Compose..."
    
    if command -v docker-compose &> /dev/null; then
        print_warning "Docker Compose 已经安装"
        docker-compose --version
        return
    fi

    # 获取最新版本
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)
    
    # 下载安装
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # 添加执行权限
    chmod +x /usr/local/bin/docker-compose
    
    print_message "Docker Compose 安装完成"
    docker-compose --version
}

# 更新 Docker Compose
update_docker_compose() {
    print_message "开始更新 Docker Compose..."
    
    # 获取当前版本
    CURRENT_VERSION=$(docker-compose --version | cut -d' ' -f3 | tr -d ',')
    print_message "当前版本: $CURRENT_VERSION"
    
    # 获取最新版本
    LATEST_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)
    print_message "最新版本: $LATEST_VERSION"
    
    if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
        print_message "已经是最新版本"
        return
    fi
    
    # 备份当前版本
    mv /usr/local/bin/docker-compose /usr/local/bin/docker-compose.bak
    
    # 下载新版本
    curl -L "https://github.com/docker/compose/releases/download/${LATEST_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # 添加执行权限
    chmod +x /usr/local/bin/docker-compose
    
    print_message "Docker Compose 更新完成"
    docker-compose --version
}

# 卸载 Docker Compose
uninstall_docker_compose() {
    print_message "开始卸载 Docker Compose..."
    
    if ! command -v docker-compose &> /dev/null; then
        print_warning "Docker Compose 未安装"
        return
    fi
    
    # 删除二进制文件
    rm -f /usr/local/bin/docker-compose
    
    print_message "Docker Compose 卸载完成"
}

# Docker Compose 项目管理
docker_compose_project_management() {
    while true; do
        clear
        echo -e "${BLUE}Compose 项目管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看运行中的项目"
        echo "2) 启动项目"
        echo "3) 停止项目"
        echo "4) 重启项目"
        echo "5) 查看项目日志"
        echo "6) 删除项目"
        echo "7) 返回上级菜单"
        echo
        read -p "请输入选项 [1-7]: " choice

        case $choice in
            1)
                docker compose ls
                ;;
            2)
                read -p "请输入项目目录路径: " project_path
                if [ -f "${project_path}/docker-compose.yml" ] || [ -f "${project_path}/compose.yaml" ]; then
                    cd "$project_path" && docker compose up -d
                    print_message "项目已启动"
                else
                    print_error "未找到 docker-compose.yml 或 compose.yaml 文件"
                fi
                ;;
            3)
                read -p "请输入项目目录路径: " project_path
                if [ -f "${project_path}/docker-compose.yml" ] || [ -f "${project_path}/compose.yaml" ]; then
                    cd "$project_path" && docker compose down
                    print_message "项目已停止"
                else
                    print_error "未找到 docker-compose.yml 或 compose.yaml 文件"
                fi
                ;;
            4)
                read -p "请输入项目目录路径: " project_path
                if [ -f "${project_path}/docker-compose.yml" ] || [ -f "${project_path}/compose.yaml" ]; then
                    cd "$project_path" && docker compose restart
                    print_message "项目已重启"
                else
                    print_error "未找到 docker-compose.yml 或 compose.yaml 文件"
                fi
                ;;
            5)
                read -p "请输入项目目录路径: " project_path
                if [ -f "${project_path}/docker-compose.yml" ] || [ -f "${project_path}/compose.yaml" ]; then
                    cd "$project_path" && docker compose logs -f
                else
                    print_error "未找到 docker-compose.yml 或 compose.yaml 文件"
                fi
                ;;
            6)
                read -p "请输入项目目录路径: " project_path
                if [ -f "${project_path}/docker-compose.yml" ] || [ -f "${project_path}/compose.yaml" ]; then
                    read -p "是否同时删除数据卷？(y/n): " del_volumes
                    if [ "$del_volumes" = "y" ] || [ "$del_volumes" = "Y" ]; then
                        cd "$project_path" && docker compose down -v
                    else
                        cd "$project_path" && docker compose down
                    fi
                    print_message "项目已删除"
                else
                    print_error "未找到 docker-compose.yml 或 compose.yaml 文件"
                fi
                ;;
            7) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
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
        print_error "Docker 未安装请先安装"
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

# Docker镜像管理函数
docker_image_management() {
    while true; do
        clear
        echo -e "${BLUE}Docker 镜像管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看所有镜像"
        echo "2) 拉取新镜像"
        echo "3) 删除镜像"
        echo "4) 清理未使用的镜像"
        echo "5) 导出镜像"
        echo "6) 导入镜像"
        echo "7) 镜像详细信息"
        echo "8) 返回上级菜单"
        echo
        read -p "请输入选项 [1-8]: " choice

        case $choice in
            1)
                echo "当前系统的 Docker 镜像列表："
                docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
                ;;
            2)
                read -p "请输入要拉取的镜像名称: " image_name
                read -p "请输入标签(默认latest): " image_tag
                image_tag=${image_tag:-latest}
                docker pull ${image_name}:${image_tag}
                ;;
            3)
                echo "当前镜像列表："
                docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}"
                read -p "请输入要删除的镜像ID: " image_id
                docker rmi $image_id
                ;;
            4)
                echo "清理未使用的镜像..."
                docker image prune -f
                ;;
            5)
                read -p "请输入要导出的镜像名称: " image_name
                read -p "保存的文件名(.tar): " file_name
                docker save -o "${file_name}.tar" $image_name
                ;;
            6)
                read -p "请输入要导入的镜像文件(.tar): " file_name
                docker load -i $file_name
                ;;
            7)
                read -p "请输入镜像ID: " image_id
                docker image inspect $image_id
                ;;
            8) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# Docker网络管理函数
docker_network_management() {
    while true; do
        clear
        echo -e "${BLUE}Docker 网络管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看所有网络"
        echo "2) 创建新网络"
        echo "3) 删除网络"
        echo "4) 连接容器到网络"
        echo "5) 断开容器与网络的连接"
        echo "6) 网络详细信息"
        echo "7) 返回上级菜单"
        echo
        read -p "请输入选项 [1-7]: " choice

        case $choice in
            1)
                echo "Docker 网络列表："
                docker network ls
                ;;
            2)
                read -p "请输入网络名称: " net_name
                read -p "请选择网络驱动(bridge/overlay/host/none): " net_driver
                docker network create --driver ${net_driver:-bridge} $net_name
                ;;
            3)
                echo "当前网络列表："
                docker network ls
                read -p "请输入要删除的网络名称: " net_name
                docker network rm $net_name
                ;;
            4)
                echo "容器列表："
                docker ps --format "table {{.Names}}\t{{.ID}}"
                read -p "请输入容器名称: " container_name
                echo "网络列表："
                docker network ls
                read -p "请输入网络名称: " net_name
                docker network connect $net_name $container_name
                ;;
            5)
                echo "容器列表："
                docker ps --format "table {{.Names}}\t{{.ID}}"
                read -p "请输入容器名称: " container_name
                echo "网络列表："
                docker network ls
                read -p "请输入网络名称: " net_name
                docker network disconnect $net_name $container_name
                ;;
            6)
                echo "网络列表："
                docker network ls
                read -p "请输入网络名称: " net_name
                docker network inspect $net_name
                ;;
            7) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# Docker 容器资源管理函数
docker_resource_management() {
    while true; do
        clear
        echo -e "${BLUE}Docker 容器资源管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看容器资源使用情况"
        echo "2) 设置容器资源限制"
        echo "3) 更新容器资源限制"
        echo "4) 容器资源统计"
        echo "5) 设置容器重启策略"
        echo "6) 返回上级菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1)
                echo "容器资源使用情况："
                docker stats --no-stream
                ;;
            2)
                echo "容器列表："
                docker ps --format "table {{.Names}}\t{{.ID}}"
                read -p "请输入容器名称: " container_name
                echo
                echo "请设置资源限制："
                read -p "CPU限制(如: 1.5): " cpu_limit
                read -p "内存限制(如: 512m): " memory_limit
                read -p "交换空间限制(如: 1g): " swap_limit
                
                docker update \
                    --cpus="$cpu_limit" \
                    --memory="$memory_limit" \
                    --memory-swap="$swap_limit" \
                    "$container_name"
                
                print_message "资源限制已设置"
                ;;
            3)
                echo "容器列表："
                docker ps --format "table {{.Names}}\t{{.ID}}"
                read -p "请输入容器名称: " container_name
                
                # 显示当前限制
                echo "当前资源限制："
                docker inspect "$container_name" | grep -A 8 "HostConfig"
                
                echo
                read -p "是否更新资源限制？(y/n): " update_confirm
                if [ "$update_confirm" = "y" ] || [ "$update_confirm" = "Y" ]; then
                    read -p "CPU限制(如: 1.5): " cpu_limit
                    read -p "内存限制(如: 512m): " memory_limit
                    read -p "交换空间限制(如: 1g): " swap_limit
                    
                    docker update \
                        --cpus="$cpu_limit" \
                        --memory="$memory_limit" \
                        --memory-swap="$swap_limit" \
                        "$container_name"
                    
                    print_message "资源限制已更新"
                fi
                ;;
            4)
                clear
                echo "容器资源统计信息："
                echo "----------------"
                echo "CPU 使用率前5名："
                docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | head -n 6
                echo
                echo "内存使用量前5名："
                docker stats --no-stream --format "table {{.Name}}\t{{.MemPerc}}\t{{.MemUsage}}" | sort -k 2 -r | head -n 6
                ;;
            5)
                echo "容器列表："
                docker ps --format "table {{.Names}}\t{{.ID}}"
                read -p "请输入容器名称: " container_name
                echo
                echo "重启策略选项："
                echo "1) no - 不自动重启"
                echo "2) always - 总是重启"
                echo "3) unless-stopped - 除非手动停止，否则不重启"
                echo "4) on-failure - 非正常退出时重启"
                read -p "请选择重启策略 [1-4]: " restart_choice
                
                case $restart_choice in
                    1) policy="no" ;;
                    2) policy="always" ;;
                    3) policy="unless-stopped" ;;
                    4) policy="on-failure" ;;
                    *) 
                        print_error "无效的选项"
                        continue
                        ;;
                esac
                
                docker update --restart="$policy" "$container_name"
                print_message "重启策略已更新"
                ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# 网络监控函数
network_monitoring() {
    while true; do
        clear
        echo -e "${BLUE}网络监控${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 实时网络流量监控"
        echo "2) 网络连接统计"
        echo "3) 端口监听状态"
        echo "4) 网络带宽测试"
        echo "5) 网络延迟监控"
        echo "6) 返回主菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1)
                echo "按 Ctrl+C 退出监控"
                sleep 2
                iftop -P
                ;;
            2)
                echo "活动连接统计："
                ss -s
                echo
                echo "TCP 连接状态统计："
                netstat -n | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key,"\t",state[key]}'
                ;;
            3)
                echo "当前监听的端口："
                netstat -tulpn | grep LISTEN
                ;;
            4)
                read -p "请输入目标服务器地址: " target_server
                echo "开始测试带宽..."
                iperf3 -c $target_server
                ;;
            5)
                read -p "请输入要监控的目标地址: " target_host
                echo "开始监控网络延迟(按 Ctrl+C 停止)..."
                ping $target_host
                ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# 系统日志管理函数
system_logs() {
    while true; do
        clear
        echo -e "${BLUE}系统日志管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看系统日志"
        echo "2) 查看认证日志"
        echo "3) 查看应用日志"
        echo "4) 日志分析"
        echo "5) 日志清理"
        echo "6) 返回主菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1)
                echo "系统日志最后100行："
                journalctl -n 100 --no-pager
                ;;
            2)
                echo "认证日志最后50行："
                tail -n 50 /var/log/auth.log
                ;;
            3)
                echo "可用的日志文件："
                ls -l /var/log/*.log
                echo
                read -p "请输入要查看的日志文件名: " log_file
                if [ -f "/var/log/$log_file" ]; then
                    tail -n 50 "/var/log/$log_file"
                else
                    print_error "日志文件不存在"
                fi
                ;;
            4)
                echo "日志分析："
                echo "1) 登录失败统计"
                echo "2) 系统错误统计"
                echo "3) 磁盘错误统计"
                read -p "请选择分析类型 [1-3]: " analysis_type
                case $analysis_type in
                    1)
                        echo "登录失败记录："
                        grep "Failed password" /var/log/auth.log | tail -n 20
                        ;;
                    2)
                        echo "系统错误记录："
                        journalctl -p err --no-pager | tail -n 20
                        ;;
                    3)
                        echo "磁盘错误记录："
                        grep -i "error" /var/log/syslog | grep -i "disk" | tail -n 20
                        ;;
                esac
                ;;
            5)
                echo "警告：此操作将清理旧日志"
                read -p "确认清理？(y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    journalctl --vacuum-time=7d
                    find /var/log -type f -name "*.log.*" -mtime +7 -delete
                    print_message "日志清理完成"
                fi
                ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# 系统性能优化函数
system_performance() {
    while true; do
        clear
        echo -e "${BLUE}系统性能优化${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 系统参数优化"
        echo "2) 内存管理优化"
        echo "3) 磁盘IO优化"
        echo "4) 网络性能优化"
        echo "5) 服务优化"
        echo "6) 性能测试"
        echo "7) 安装BBR加速"
        echo "8) 返回主菜单"
        echo
        read -p "请输入选项 [1-8]: " choice

        case $choice in
            1)
                system_params_optimization
                ;;
            2)
                memory_optimization
                ;;
            3)
                disk_io_optimization
                ;;
            4)
                network_optimization
                ;;
            5)
                service_optimization
                ;;
            6)
                performance_test
                ;;
            7)
                install_bbr
                ;;
            8) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 系统参数优化
system_params_optimization() {
    clear
    echo -e "${BLUE}系统参数优化${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    echo "正在优化系统参数..."

    # 备份原始配置
    cp /etc/sysctl.conf /etc/sysctl.conf.backup

    # 添加优化参数
    cat >> /etc/sysctl.conf <<EOF
# 文件系统和内存优化
fs.file-max = 2097152
vm.swappiness = 10
vm.dirty_ratio = 60
vm.dirty_background_ratio = 2

# 网络优化
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_fin_timeout = 20
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_max_tw_buckets = 262144
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_fastopen = 3

# 内核优化
kernel.pid_max = 65535
kernel.shmmax = 68719476736
EOF

    # 应用新参数
    sysctl -p

    print_message "系统参数优化完成"
    wait_for_key
}

# 内存管理优化
memory_optimization() {
    clear
    echo -e "${BLUE}内存管理优化${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    echo "正在优化内存管理..."

    # 清理缓存
    sync
    if ! echo 3 > /proc/sys/vm/drop_caches 2>/dev/null; then
        print_warning "清理缓存失败，可能需要root权限"
    fi
    
    # 优化 SWAP 使用
    if [ -f /proc/sys/vm/swappiness ]; then
        if ! sysctl -w vm.swappiness=10 >/dev/null 2>&1; then
            print_warning "设置 swappiness 失败，尝试直接写入"
            echo 10 > /proc/sys/vm/swappiness 2>/dev/null || print_warning "写入 swappiness 失败"
        fi
    else
        print_warning "未找到 swappiness 配置文件"
    fi
    
    # 设置最大打开文件数
    if ! ulimit -n 65535 2>/dev/null; then
        print_warning "设置文件描述符限制失败，尝试通过配置文件设置"
    fi
    
    # 添加到系统配置
    if [ -w /etc/security/limits.conf ]; then
        cat >> /etc/security/limits.conf <<EOF
* soft nofile 65535
* hard nofile 65535
* soft nproc 65535
* hard nproc 65535
EOF
        # 确保配置生效
        if [ -d /etc/security/limits.d ]; then
            echo "* soft nofile 65535" > /etc/security/limits.d/90-nproc.conf
            echo "* hard nofile 65535" >> /etc/security/limits.d/90-nproc.conf
        fi
    else
        print_warning "无法写入 limits.conf，请检查权限"
    fi

    # 优化虚拟内存参数
    if [ -f /etc/sysctl.conf ]; then
        {
            echo "vm.swappiness = 10"
            echo "vm.vfs_cache_pressure = 50"
            echo "vm.dirty_ratio = 10"
            echo "vm.dirty_background_ratio = 5"
        } >> /etc/sysctl.conf
        sysctl -p >/dev/null 2>&1 || print_warning "应用 sysctl 参数失败"
    fi

    # 检查优化结果
    echo "当前内存配置："
    echo "Swappiness: $(cat /proc/sys/vm/swappiness 2>/dev/null || echo '未知')"
    echo "最大文件描述符: $(ulimit -n 2>/dev/null || echo '未知')"
    echo "当前内存使用情况："
    free -h

    print_message "内存管理优化完成"
    wait_for_key
}

# 磁盘IO优化
disk_io_optimization() {
    clear
    echo -e "${BLUE}磁盘IO优化${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    echo "正在优化磁盘IO..."

    # 获取所有磁盘设备
    disks=$(lsblk -d -o NAME | tail -n +2)
    
    for disk in $disks; do
        echo "优化磁盘 $disk..."
        # 设置磁盘调度器为 deadline
        echo deadline > /sys/block/$disk/queue/scheduler
        # 优化读写队列
        echo 1024 > /sys/block/$disk/queue/nr_requests
        # 优化预读大小
        echo 4096 > /sys/block/$disk/queue/read_ahead_kb
    done

    print_message "磁盘IO优化完成"
    wait_for_key
}

# 网络性能优化
network_optimization() {
    clear
    echo -e "${BLUE}网络性能优化${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    echo "正在优化网络性能..."

    # 优化网络接口
    for interface in $(ip -o link show | awk -F': ' '{print $2}'); do
        if [ "$interface" != "lo" ]; then
            echo "优化网络接口 $interface..."
            # 开启网卡多队列
            ethtool -L $interface combined $(nproc) 2>/dev/null || true
            # 优化网卡参数
            ethtool -G $interface rx 4096 tx 4096 2>/dev/null || true
        fi
    done

    print_message "网络性能优化完成"
    wait_for_key
}

# 服务优化
service_optimization() {
    clear
    echo -e "${BLUE}服务优化${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    echo "正在优化系统服务..."

    # 禁用不必要的服务
    unnecessary_services=(
        "bluetooth.service"
        "cups.service"
        "avahi-daemon.service"
    )

    for service in "${unnecessary_services[@]}"; do
        if systemctl is-active --quiet $service; then
            systemctl stop $service
            systemctl disable $service
            print_message "已禁用服务: $service"
        fi
    done

    print_message "服务优化完成"
    wait_for_key
}

# 性能测试
performance_test() {
    clear
    echo -e "${BLUE}系统性能测试${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    echo "进行性能测试..."

    # CPU性能测试
    echo "CPU性能测试："
    sysbench cpu --cpu-max-prime=20000 run

    # 内存性能测试
    echo -e "\n内存性能测试："
    sysbench memory --memory-block-size=1K --memory-total-size=100G run

    # 磁盘IO性能测试
    echo -e "\n磁盘IO性能测试："
    sysbench fileio --file-test-mode=rndrw prepare
    sysbench fileio --file-test-mode=rndrw run
    sysbench fileio --file-test-mode=rndrw cleanup

    print_message "性能测试完成"
    wait_for_key
}

# BBR加速安装函数
install_bbr() {
    clear
    echo -e "${BLUE}BBR加速安装${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    # 下载并运行外部BBR脚本
    wget -O tcp.sh "https://git.io/coolspeeda" && chmod +x tcp.sh && ./tcp.sh
    wait_for_key
}

# 系统工具函数
function system_tools() {
    while true; do
        clear
        blue "系统工具"
        blue "================================"
        echo
        echo "请选择操作："
        echo "1) 系统更新"
        echo "2) 安装常用工具"
        echo "3) 清理系统"
        echo "4) 系统时间同步"
        echo "5) 查看系统信息"
        echo "6) 返回主菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1)
                system_update
                ;;
            2)
                install_tools
                ;;
            3)
                system_clean
                ;;
            4)
                time_sync
                ;;
            5)
                system_info
                ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 系统更新
function system_update() {
    clear
    blue "系统更新"
    blue "================================"
    echo
    
    if [ -f /etc/debian_version ]; then
        apt update -y
        apt upgrade -y
    elif [ -f /etc/redhat-release ]; then
        yum update -y
    fi
    
    print_message "系统更新完成"
    wait_for_key
}

# 安装常用工具
function install_tools() {
    clear
    blue "安装常用工具"
    blue "================================"
    echo
    
    if [ -f /etc/debian_version ]; then
        apt install -y wget curl vim nano htop net-tools iftop iotop
    elif [ -f /etc/redhat-release ]; then
        yum install -y wget curl vim nano htop net-tools iftop iotop
    fi
    
    print_message "工具安装完成"
    wait_for_key
}

# 系统清理
function system_clean() {
    clear
    blue "系统清理"
    blue "================================"
    echo
    
    if [ -f /etc/debian_version ]; then
        apt clean
        apt autoclean
        apt autoremove -y
    elif [ -f /etc/redhat-release ]; then
        yum clean all
        yum autoremove -y
    fi
    
    # 清理日志
    find /var/log -type f -name "*.log*" -exec rm -f {} \;
    
    # 清理系统临时文件
    rm -rf /tmp/*
    
    print_message "系统清理完成"
    wait_for_key
}

# 系统时间同步
function time_sync() {
    clear
    blue "系统时间同步"
    blue "================================"
    echo
    
    if [ -f /etc/debian_version ]; then
        apt install -y ntpdate
    elif [ -f /etc/redhat-release ]; then
        yum install -y ntpdate
    fi
    
    ntpdate pool.ntp.org
    hwclock --systohc
    
    print_message "时间同步完成"
    wait_for_key
}

# 系统信息
function system_info() {
    clear
    blue "系统信息"
    blue "================================"
    echo
    
    echo "操作系统：$(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "内核版本：$(uname -r)"
    echo "CPU型号：$(cat /proc/cpuinfo | grep 'model name' | head -n1 | cut -d':' -f2)"
    echo "CPU核心数：$(nproc)"
    echo "内存总量：$(free -h | grep Mem | awk '{print $2}')"
    echo "磁盘使用：$(df -h /)"
    echo "系统时间：$(date)"
    echo "运行时间：$(uptime -p)"
    echo "当前用户：$(whoami)"
    
    wait_for_key
}

# 时区选择函数
select_timezone() {
    clear
    echo -e "${BLUE}时区选择${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    echo "常用时区："
    echo "1) 亚洲/上海 (UTC+8)"
    echo "2) 亚洲/东京 (UTC+9)"
    echo "3) 美国/纽约 (UTC-5)"
    echo "4) 欧洲/伦敦 (UTC+0)"
    echo "5) 手动输入时区"
    echo
    read -p "请选择时区 [1-5]: " choice

    case $choice in
        1) timezone="Asia/Shanghai" ;;
        2) timezone="Asia/Tokyo" ;;
        3) timezone="America/New_York" ;;
        4) timezone="Europe/London" ;;
        5)
            # 显示可用时区列表
            timedatectl list-timezones
            read -p "请输入时区名称: " timezone
            ;;
        *)
            print_error "无效的选项"
            return 1
            ;;
    esac

    # 设置时区
    timedatectl set-timezone $timezone
    
    # 同步时间
    # 停止NTP服务以避免端口冲突
    systemctl stop systemd-timesyncd 2>/dev/null
    systemctl stop ntp 2>/dev/null
    
    # 安装并使用chrony进行时间同步
    if [ -f /etc/debian_version ]; then
        apt install -y chrony
    elif [ -f /etc/redhat-release ]; then
        yum install -y chrony
    fi
    
    # 启动chrony服务
    systemctl start chronyd
    systemctl enable chronyd
    
    # 强制同步时间
    chronyc makestep
    
    # 将系统时间同步到硬件时钟
    hwclock --systohc
    
    print_message "时区已设置为: $timezone"
    print_message "系统时间已同步"
    
    # 显示当前时间信息
    echo
    echo "当前系统信息："
    timedatectl status
    wait_for_key
}

# 系统优化与维护菜单
system_optimization_maintenance() {
    while true; do
        clear
        echo -e "${BLUE}系统优化与维护${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 系统优化"
        echo "2) 系统维护"
        echo "3) 系统备份与还原"
        echo "4) 定时任务管理"
        echo "5) 安全审计"
        echo "6) 返回主菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1) system_optimization_menu ;;
            2) system_maintenance_menu ;;
            3) backup_restore_menu ;;
            4) cron_management ;;
            5) security_audit ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 系统优化菜单
system_optimization_menu() {
    while true; do
        clear
        echo -e "${BLUE}系统优化${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择优化项目："
        echo "1) 系统参数优化"
        echo "2) 内存管理优化"
        echo "3) 磁盘IO优化"
        echo "4) 网络性能优化"
        echo "5) 服务优化"
        echo "6) BBR加速安装"
        echo "7) 返回上级菜单"
        echo
        read -p "请输入选项 [1-7]: " choice

        case $choice in
            1) system_params_optimization ;;
            2) memory_optimization ;;
            3) disk_io_optimization ;;
            4) network_optimization ;;
            5) service_optimization ;;
            6) install_bbr ;;
            7) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 系统维护菜单
system_maintenance_menu() {
    while true; do
        clear
        echo -e "${BLUE}系统维护${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择维护项目："
        echo "1) 系统更新"
        echo "2) 系统清理"
        echo "3) 系统修复"
        echo "4) 日志管理"
        echo "5) 磁盘检查"
        echo "6) 返回上级菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1) system_update ;;
            2) system_clean ;;
            3) system_repair ;;
            4) log_management ;;
            5) disk_check ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 备份还原菜单
backup_restore_menu() {
    while true; do
        clear
        echo -e "${BLUE}系统备份与还原${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 系统备份"
        echo "2) 系统还原"
        echo "3) 备份管理"
        echo "4) 自动备份设置"
        echo "5) 返回上级菜单"
        echo
        read -p "请输入选项 [1-5]: " choice

        case $choice in
            1) system_backup ;;
            2) system_restore ;;
            3) backup_management ;;
            4) auto_backup_config ;;
            5) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
    done
}

# 定时任务管理
cron_management() {
    while true; do
        clear
        echo -e "${BLUE}定时任务管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看现有任务"
        echo "2) 添加新任务"
        echo "3) 编辑任务"
        echo "4) 删除任务"
        echo "5) 返回上级菜单"
        echo
        read -p "请输入选项 [1-5]: " choice

        case $choice in
            1)
                crontab -l
                ;;
            2)
                echo "添加新的定时任务"
                echo "格式: 分 时 日 月 星期 命令"
                read -p "请输入定时任务: " new_task
                (crontab -l 2>/dev/null; echo "$new_task") | crontab -
                ;;
            3)
                crontab -e
                ;;
            4)
                echo "当前定时任务："
                crontab -l
                read -p "确认要删除所有任务吗？(y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    crontab -r
                    print_message "所有定时任务已删除"
                fi
                ;;
            5) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# 安全审计
security_audit() {
    clear
    echo -e "${BLUE}系统安全审计${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    
    # 检查系统更新状态
    echo -e "${GREEN}检查系统更新状态:${NC}"
    if [ -f /etc/debian_version ]; then
        apt-get -s upgrade | grep -P "^\d+ upgraded"
    elif [ -f /etc/redhat-release ]; then
        yum check-update | grep -v "^$" | wc -l
    fi
    echo
    
    # 检查开放端口
    echo -e "${GREEN}检查开放端口:${NC}"
    netstat -tuln
    echo
    
    # 检查登录失败记录
    echo -e "${GREEN}最近的登录失败记录:${NC}"
    grep "Failed password" /var/log/auth.log | tail -n 5
    echo
    
    # 检查系统用户
    echo -e "${GREEN}系统用户列表:${NC}"
    awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd
    echo
    
    # 检查sudo权限
    echo -e "${GREEN}具有sudo权限的用户:${NC}"
    grep -Po '^sudo.+:\K.*$' /etc/group
    echo
    
    # 检查最后修改的文件
    echo -e "${GREEN}最近24小时内修改的重要文件:${NC}"
    find /etc -type f -mtime -1
    echo
    
    wait_for_key
}

# 主循环
main() {
    check_root
    
    # 基本兼容性检查
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian|centos|rhel|fedora)
                print_message "检测到支持的操作系统: $PRETTY_NAME"
                ;;
            *)
                print_warning "未经完全测试的操作系统: $PRETTY_NAME"
                print_warning "某些功能可能无法正常工作"
                wait_for_key
                ;;
        esac
    else
        print_error "无法识别的操作系统"
        exit 1
    fi
    
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

# 错误处理函数
handle_error() {
    local exit_code=$?
    local error_message=$1
    
    if [ $exit_code -ne 0 ]; then
        print_error "$error_message (错误代码: $exit_code)"
        log_error "$error_message" $exit_code
        return 1
    fi
    return 0
}

# 日志记录函数
log_error() {
    local message=$1
    local code=$2
    local log_file="/var/log/system_manage.log"
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $message (代码: $code)" >> "$log_file"
}

# 防火墙管理函数
firewall_management() {
    while true; do
        clear
        echo -e "${BLUE}防火墙管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看防火墙状态"
        echo "2) 启用防火墙"
        echo "3) 禁用防火墙"
        echo "4) 添加规则"
        echo "5) 删除规则"
        echo "6) 查看所有规则"
        echo "7) 返回上级菜单"
        echo
        read -p "请输入选项 [1-7]: " choice

        case $choice in
            1)
                if command -v ufw &> /dev/null; then
                    ufw status verbose
                elif command -v firewalld &> /dev/null; then
                    firewall-cmd --state
                    firewall-cmd --list-all
                else
                    iptables -L -n -v
                fi
                ;;
            2)
                if command -v ufw &> /dev/null; then
                    ufw enable
                elif command -v firewalld &> /dev/null; then
                    systemctl start firewalld
                    systemctl enable firewalld
                else
                    systemctl start iptables
                    systemctl enable iptables
                fi
                print_message "防火墙已启用"
                ;;
            3)
                if command -v ufw &> /dev/null; then
                    ufw disable
                elif command -v firewalld &> /dev/null; then
                    systemctl stop firewalld
                    systemctl disable firewalld
                else
                    systemctl stop iptables
                    systemctl disable iptables
                fi
                print_message "防火墙已禁用"
                ;;
            4)
                echo "添加防火墙规则："
                read -p "请输入端口号: " port
                read -p "请选择协议(tcp/udp): " protocol
                if command -v ufw &> /dev/null; then
                    ufw allow $port/$protocol
                elif command -v firewalld &> /dev/null; then
                    firewall-cmd --permanent --add-port=$port/$protocol
                    firewall-cmd --reload
                else
                    iptables -A INPUT -p $protocol --dport $port -j ACCEPT
                    service iptables save
                fi
                print_message "规则已添加"
                ;;
            5)
                echo "删除防火墙规则："
                read -p "请输入端口号: " port
                read -p "请选择协议(tcp/udp): " protocol
                if command -v ufw &> /dev/null; then
                    ufw delete allow $port/$protocol
                elif command -v firewalld &> /dev/null; then
                    firewall-cmd --permanent --remove-port=$port/$protocol
                    firewall-cmd --reload
                else
                    iptables -D INPUT -p $protocol --dport $port -j ACCEPT
                    service iptables save
                fi
                print_message "规则已删除"
                ;;
            6)
                if command -v ufw &> /dev/null; then
                    ufw status numbered
                elif command -v firewalld &> /dev/null; then
                    firewall-cmd --list-all
                else
                    iptables -L -n -v
                fi
                ;;
            7) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# 网络接口管理函数
interface_management() {
    while true; do
        clear
        echo -e "${BLUE}网络接口管理${NC}"
        echo -e "${BLUE}================================${NC}"
        echo
        echo "请选择操作："
        echo "1) 查看所有接口"
        echo "2) 启用接口"
        echo "3) 禁用接口"
        echo "4) 配置IP地址"
        echo "5) 配置DNS"
        echo "6) 返回上级菜单"
        echo
        read -p "请输入选项 [1-6]: " choice

        case $choice in
            1)
                ip addr show
                ;;
            2)
                ip -br link show
                read -p "请输入要启用的接口名称: " interface
                ip link set $interface up
                print_message "接口已启用"
                ;;
            3)
                ip -br link show
                read -p "请输入要禁用的接口名称: " interface
                ip link set $interface down
                print_message "接口已禁用"
                ;;
            4)
                ip -br link show
                read -p "请输入要配置的接口名称: " interface
                read -p "请输入IP地址(例如: 192.168.1.100/24): " ip_addr
                ip addr add $ip_addr dev $interface
                print_message "IP地址已配置"
                ;;
            5)
                echo "当前DNS配置："
                cat /etc/resolv.conf
                read -p "请输入新的DNS服务器(用空格分隔): " dns_servers
                for server in $dns_servers; do
                    echo "nameserver $server" >> /etc/resolv.conf
                done
                print_message "DNS已配置"
                ;;
            6) return ;;
            *)
                print_error "无效的选项"
                sleep 2
                ;;
        esac
        wait_for_key
    done
}

# 执行主函数
main 
