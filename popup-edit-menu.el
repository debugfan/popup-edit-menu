;;; popup-edit-menu.el --- a popup context edit menu package                     -*- lexical-binding: t; -*-

;; Copyright (C) 2014  Debugfan Chin

;; Author: Debugfan Chin <debugfanchin@gmail.com>
;; Keywords: lisp, pop-up, context, edit, menu
;; Package-Requires: ((emacs "24"))
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Put a description of the package here

;;; Code:

(require 'mouse)

;;;###autoload
(defgroup popup-edit-menu nil
    "Display a popup enhanced context edit menu"
    :group 'convenience
)

;;;###autoload
(defcustom popup-edit-menu-keep-header nil
  "Non-nil means keep header in popup edit menu..."
  :type 'boolean
  :require 'popup-edit-menu
  :group 'popup-edit-menu)

(defun popup-edit-menu-map ()
  "Return a keymap associated with a enhanced context edit menu.
The menu items from global edit menu and various mode menus.
The contents are the items that would be in the menu bar whether or
not it is actually displayed."
  (run-hooks 'activate-menubar-hook 'menu-bar-update-hook)
  (let* ((local-menu (and (current-local-map)
			  (lookup-key (current-local-map) [menu-bar])))
	 (global-menu (lookup-key global-map [menu-bar edit]))
	 ;; If a keymap doesn't have a prompt string (a lazy
	 ;; programmer didn't bother to provide one), create it and
	 ;; insert it into the keymap; each keymap gets its own
	 ;; prompt.  This is required for non-toolkit versions to
	 ;; display non-empty menu pane names.
	 (minor-mode-menus
	  (mapcar
           (lambda (menu)
             (let* ((minor-mode (car menu))
                    (menu (cdr menu))
                    (title-or-map (cadr menu)))
               (or (stringp title-or-map)
                   (if popup-edit-menu-keep-header
                       (setq menu
                             (cons 'keymap
                                   (cons (concat
                                          (capitalize (subst-char-in-string
                                                       ?- ?\s (symbol-name
                                                               minor-mode)))
                                          " Menu")
                                         (cdr menu))))))
               menu))
	   (minor-mode-key-binding [menu-bar])))
	 (local-title-or-map (and local-menu (cadr local-menu)))
	 (global-title-or-map (cadr global-menu)))
    (or (null local-menu)
	(stringp local-title-or-map)
	(if popup-edit-menu-keep-header
    (setq local-menu (cons 'keymap
			       (cons (concat (format-mode-line mode-name)
                                             " Mode Menu")
				     (cdr local-menu))))))
    (or (stringp global-title-or-map)
	(setq global-menu (if popup-edit-menu-keep-header
                (cons 'keymap (cons "Edit Menu" (cdr global-menu)))
                (delete "Edit" global-menu))))
    ;; Supplying the list is faster than making a new map.
    ;; FIXME: We have a problem here: we have to use the global/local/minor
    ;; so they're displayed in the expected order, but later on in the command
    ;; loop, they're actually looked up in the opposite order.
    (apply 'append
           local-menu
           minor-mode-menus
           (list 'keymap (list 'popup-edit-menu-mode-separator "--"))
           global-menu
           nil)))
           
(defun popup-edit-menu (event prefix)
  "Popup a menu like either `popup-edit-menu-map' or `mouse-popup-menubar'.
Use the former if the menu bar is showing, otherwise the latter.
EVENT is an from an input event, passing to `popup-menu' as POSITION argument.
PREFIX is the prefix argument (if any) to pass to the command."
  (declare (obsolete nil "23.1"))
  (interactive "@e\nP")
  (run-hooks 'activate-menubar-hook 'menu-bar-update-hook)
  (popup-menu
   (if (zerop (or (frame-parameter nil 'menu-bar-lines) 0))
       (mouse-menu-bar-map)
     (popup-edit-menu-map))
   event prefix))

(provide 'popup-edit-menu)
;;; popup-edit-menu.el ends here
