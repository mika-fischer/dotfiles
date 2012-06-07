#!/bin/bash

GLOBAL=$HOME/.mypackages.arch.global
LOCAL=$HOME/.mypackages.arch.local

FILES="$GLOBAL"
[ -e "$LOCAL" ] && FILES="$FILES $LOCAL"

wanted_groups()
{
    cat $FILES | grep "^group: " | sed 's/^group: //'
}

wanted_packages()
{
    cat $FILES | egrep -v '^#|^group:|^aur:'
}

wanted_aur_packages()
{
    cat $FILES | grep '^aur: ' | sed 's/^aur: //'
}

all_pkgs()
{
    local pkgs
    for g in $(wanted_groups); do
        pkgs="$pkgs $(pacman -Qgq $g)"
    done
    echo $pkgs $(wanted_packages) $(wanted_aur_packages)
}

install_groups()
{
    echo "Syncing package groups..."
    local groups=$(wanted_groups)
    for g in $groups; do
        pkgs=$(pacman -Qgq $g | sed 's/ \(absbsbab\|gcc\) //g')
        echo -ne "$g: "
        yaourt -S --needed $pkgs 2>&1 | egrep -v -- '-- skipping'
    done
}

install_official_packages()
{
    echo "Syncing official packages..."
    sudo pacman -S --needed $(wanted_packages) 2>&1 | egrep -v -- '-- skipping'
}

install_aur_packages()
{
    echo "Syncing AUR packages..."
    for p in $(wanted_aur_packages); do
        if ! pacman -Qi $p >/dev/null 2>&1; then
            yaourt -S $p
        fi
    done
}

upgrade()
{
    echo "Upgrading installed packages"
    yaourt -Syua
}

print_extra_packages()
{
    installed=$(pacman -Qqe)
    wanted=$(all_pkgs)

    extra=$(comm -1 -3 <(for i in $wanted; do echo $i; done | sort) <(for i in $installed; do echo $i; done | sort))
    for e in $extra; do
        if pacman -Si $e >/dev/null 2>&1; then
            echo $e
        else
            echo aur: $e
        fi
    done
}

remove_orphans()
{
    sudo pacman -Rs $(pacman -Qtdq)
}

opt=${1:-sync}

case $opt in
    extra)
        print_extra_packages
        ;;
    remove-orphans)
        remove_orphans
        ;;
    opt)
        install_groups
        install_official_packages
        install_aur_packages
        upgrade
        print_extra_packages
        ;;
    *)
        echo Unknown command: $opt
        exit 1
        ;;
esac
