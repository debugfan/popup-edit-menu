
# Introduction

This Elisp package used to display a popup convenient context edit menu in Emacs.

# Installation

1. If you want to install it manually, put it under some directory,
   then add that directory to the load path list, for example:
   
   ```elisp
   (add-to-list 'load-path "~/.emacs.d/lisp/")
   ```

2. Add the following codes into .emacs init file to load it.

   ```elisp
   (require 'popup-edit-menu)
   (global-set-key [mouse-3] 'popup-edit-menu)
   ```
   
   You can change the key binding as you want if you don't want to active it by mouse right click

# Usage

When you right click to active it, it show as following:

![screenshot](images/screenshot.png)
