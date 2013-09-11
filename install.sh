#!/bin/bash
mv -f ~/.vim ~/.vim.bak
cp -r vim ~/.vim

mv -f ~/.vimrc ~/.vimrc.bak
cp vimrc ~/.vimrc


mv -f ~/.vimrc.local ~/.vimrc.local.bak
cp vimrc.local ~/.vimrc.local

