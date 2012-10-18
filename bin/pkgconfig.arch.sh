#!/bin/bash

BLACKLIST=($(cat /home/mfischer/.mypackages.configfiles.arch.global))

check_blacklist()
{
    local file
    for file in ${BLACKLIST[@]}; do
        if [[ $1 == $file ]]; then
            return 0
        fi
    done
    return 1
}

for pkgdir in /var/lib/pacman/local/*; do
    pkgname=${pkgdir##*/}
    if grep -q "%BACKUP%" $pkgdir/files; then
        files=()
        while read filename md5; do
            currmd5=$(md5sum /$filename 2>/dev/null | awk '{ print $1 }')
            if [[ $currmd5 != $md5 ]]; then
                files+=($filename)
            fi
        done < <(sed '0,/\%BACKUP\%/d' $pkgdir/files | egrep -v '^\S*$')
        files2=()
        for file in ${files[@]}; do
            if ! check_blacklist $file; then
                files2+=($file)
            fi
        done
        if [[ ${#files2[@]} -gt 0 ]]; then
            echo ---------------------------------------------------------------------
            echo $pkgname
            pkgs=(/var/cache/pacman/pkg/$pkgname-*.pkg.tar.xz)
            if [[ ${#pkgs[@]} -gt 0 ]] && [[ ${pkgs[0]} != *\** ]]; then
                pkg=${pkgs[0]}
                tmpdir=$(mktemp -d)
                for file in ${files2[@]}; do
                    if ! [[ -e /$file ]]; then
                        echo "$file does not exist"
                    else
                        tar xf $pkg -C $tmpdir $file >/dev/null 2>&1
                        diff -u $tmpdir/$file /$file
                    fi
                done
                rm -rf $tmpdir
            else
                for file in ${files2[@]}; do
                    echo $file
                done
            fi
            echo
        fi
    fi
done
