#!/bin/bash

USAGE="usage: $(basename $0) {install|uninstall|reinstall}"

if (($# == 0));then
    echo "$USAGE" >& 2
    exit 0
fi
destPath=""
OS=""
case $(uname) in
    "Darwin")
        OS="darwin"
        ;;
    "Linux")
        OS="linux"
        ;;
    *)
        echo "Unknown os,Quit!"
        exit 1;;
esac

while read -p "For zsh or bash ? [default: zsh] " whichshell;do
    if [[ -z "$whichshell" ]];then
        whichshell=zsh
    fi
    case $whichshell in
        "zsh")
            destPath=$HOME/.zshrc
            if command -v pacman >/dev/null 2>&1;then
                sudo pacman -Syu --noconfirm --needed
                sudo pacman -S zsh-syntax-highlighting --noconfirm --needed
            fi
            break
            ;;
        "bash")
            case $(uname) in
                "Darwin")
                    destPath=$HOME/.bash_profile
                    ;;
                "Linux")
                    destPath=$HOME/.bashrc
            esac 
            break
            ;;
        *)
            echo 'Enter zsh or bash !' >&2
            ;;
    esac
done

startLine="#custom begin"
endLine="#custom end"

install(){
    cp custom-shell  ~/.custom-shell
    #install custom config
    #the actual config is in file ~/.bashrc(for linux) or ~/.bash_profile(for mac)

    if grep  -q "$startLine" $destPath;then
        echo "Already installed,Quit!"
        read -p "already????" xxx
        exit 1
    else
        #insert header
        echo "$startLine" >> $destPath

        #insert body
        echo "[ -f ~/.custom-shell ] && source ~/.custom-shell" >> $destPath

        #insert tailer
        echo "$endLine" >> $destPath

        echo "Done."
    fi

    if [[ "$OS" == "darwin" ]];then
        read -p "Change default shell to zsh? [Y/n]" defzsh
        if [[ "$defzsh" != [nN] ]];then
            sudo echo "$(which zsh)" >>/etc/shells
            chsh -s $(which zsh)
        fi
    fi
}

uninstall(){
    #uninstall custom config
    #delete lines from header to tailer
    if [ "$OS" == "darwin" ];then
        sed -i bak "/$startLine/,/$endLine/ d" $destPath
        rm ${destPath}bak
    else
        sed -i "/$startLine/,/$endLine/ d" $destPath
    fi
    if [ -f $HOME/.custom-shell ];then
        rm $HOME/.custom-shell
    fi
    echo "Uninstall Done."
}

reinstall(){
    uninstall
    install
}

case "$1" in
    install | ins*)
        install
        exit 0
        ;;
    uninstall | unins*)
        uninstall
        exit 0
        ;;
    reinstall | reins*)
        reinstall
        exit 0
        ;;
    --help | -h | --h* | *)
        echo "$USAGE" >& 2
        exit 0
        ;;
esac
#vim setf sh
