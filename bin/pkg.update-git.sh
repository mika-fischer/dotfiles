#!/bin/bash

yaourt -S $(yaourt -Qq | egrep -- "-(git|svn|hg)$")
