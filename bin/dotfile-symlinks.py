#!/usr/bin/env python

from __future__ import print_function
from collections import defaultdict
from os import listdir, makedirs, symlink, unlink
from os.path import abspath, dirname, exists, expanduser, isabs, isdir, islink, join, relpath
from sys import argv

XDG_CONFIG_DIRS = ('awesome', 'fontconfig', 'gtk3', 'qtile', 'taffybar',
                   'volumeicon', 'zathura')

class App(object):
    def __init__(self, home_dir=None):
        if not home_dir:
            home_dir = abspath(expanduser('~'))
        self.home_dir = home_dir
        self.dotfiles_dir = join(self.home_dir, '.dotfiles')
        self.bin_dir = join(self.home_dir, 'bin')
        self.xdg_config_dir = join(self.home_dir, '.config')

        self.handlers = defaultdict(lambda: self.handle_default)
        for d in XDG_CONFIG_DIRS:
            self.handlers[d] = self.handle_xdg_config
        self.handlers['bin'] = self.handle_bin

    def run(self):
        for fn in sorted(listdir(self.dotfiles_dir)):
            if fn.startswith('.'):
                continue
            self.handlers[fn](fn)

    def handle_default(self, dn):
        """ dn/fn -> ~/.fn """
        for fn in sorted(listdir(join(self.dotfiles_dir, dn))):
            self.symlink(join(self.dotfiles_dir, dn, fn),
                         join(self.home_dir, '.' + fn))

    def handle_xdg_config(self, dn):
        """ dn -> ~/.config/dn """
        self.ensure_directory_exists(self.xdg_config_dir)

        self.symlink(join(self.dotfiles_dir, dn),
                     join(self.xdg_config_dir, dn))

    def handle_bin(self, dn):
        """ dn/fn -> ~/bin/fn """
        self.ensure_directory_exists(self.bin_dir)

        for fn in sorted(listdir(join(self.dotfiles_dir, dn))):
            self.symlink(join(self.dotfiles_dir, dn, fn),
                         join(self.home_dir, dn, fn))

    @staticmethod
    def ensure_directory_exists(dn):
        if not exists(dn):
            makedirs(dn)
        if not isdir(dn):
            raise Exception('{} is not a directory!'.format(dn))

    @staticmethod
    def symlink(target, link):
        assert isabs(target)
        assert isabs(link)

        if islink(link):
            unlink(link)
        if exists(link):
            print('Error: {} exists and is not a symlink!'.format(link))
            return

        rel_target = relpath(target, dirname(link))
        #print('{} -> {}'.format(link, rel_target))
        symlink(rel_target, link)


if __name__ == '__main__':
    # Check if python version is >= 3.3 on Windows
    app = App(home_dir=(argv[1] if len(argv) > 1 else None))
    app.run()
