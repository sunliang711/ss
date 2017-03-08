#!/bin/bash
# 检测出当前系统的版本，形如ubuntu-16.10,archlinux,fedora-23,centos-6.8,debian-8,macos

detectOS(){
    Platform=
    OStype=
    OSversion=
    case "$(uname)" in
        Linux)
            Platform="Linux"
            ;;
        Darwin)
            Platform="Darwin"
            ;;
        *)
            ;;
    esac

    if [ -z "$Platform" ];then
        exit 1
    fi

    case "$(Platform)" in
        Linux)
            if command -v pacman >/dev/null 2>&1;then
                OStype="archlinux"
            fi
            if command -v apt-get >/dev/null 2>&1;then
                OStype="debian"
            fi
            if command -v yum >/dev/null 2>&1;then
                OStype="redhat"
            fi
            if command -v dnf >/dev/null 2>&1;then
                OStype="redhat"
            fi
            ;;
        Darwin)
            ;;
        *)
            ;;
    esac

    case "$(OStype)" in
        archlinux)
            # 输出archlinux并退出
            echo "archlinux"
            exit 0
            ;;
        debian)
            # 判断debian版本或者ubuntu版本并输出
            ;;
        redhat)
            # 判断fedora版本或者centos版本并输出
            ;;
    esac
}
