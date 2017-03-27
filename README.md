
# Installation

Put it under the folder "~/.emacs.d/lisp/" and add the following codes into .emacs init file
``` elisp
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'popup-edit-menu)
(global-set-key [mouse-3] 'popup-edit-menu)
```

# Usage

![screenshot](images/screenshot.png)

