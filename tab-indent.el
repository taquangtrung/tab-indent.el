  (if  mark-active
    (indent-block)
    (if (looking-at "\\>")
      (hippie-expand nil)
      (insert "\t"))))

(defun my-unindent()
  (interactive)
  (if mark-active
    (unindent-block)
    (progn
      (unless(bolp)
        (if (looking-back "^[ \t]*")
          (progn
            ;;"a" holds how many spaces are there to the beginning of the line
            (let ((a (length(buffer-substring-no-properties (point-at-bol) (point)))))
              (progn
                ;; delete backwards progressively in my-tab-width steps, but without going further of the beginning of line.
                (if (> a my-tab-width)
                  (delete-backward-char my-tab-width)
                  (backward-delete-char a)))))
          ;; delete tab and spaces first, if at least 2 exist, before removing words
          (progn
            (if(looking-back "[ \t]\\{2,\\}")
              (delete-horizontal-space)
              (backward-kill-word 1))))))))

(global-set-key (kbd "<tab>") 'indent-or-complete)
(global-set-key (kbd "<backtab>") 'my-unindent)

; while in minibuffer mode, reset <tab>'s keybinding to its default behaviour
(add-hook 'minibuffer-setup-hook
          (lambda () (global-unset-key (kbd "<tab>"))))
(add-hook 'minibuffer-exit-hook
          (lambda () (global-set-key (kbd "<tab>") 'indent-or-complete)))


;; mac and pc users would like selecting text this way
(defun dave-shift-mouse-select (event)
  "Set the mark and then move point to the position clicked on with
  the mouse. This should be bound to a mouse click event type."
  (interactive "e")
  (mouse-minibuffer-check event)
  (if mark-active (exchange-point-and-mark))
  (set-mark-command nil)
  ;; Use event-end in case called from mouse-drag-region.
  ;; If EVENT is a click, event-end and event-start give same value.
  (posn-set-point (event-end event)))

(define-key global-map [S-down-mouse-1] 'dave-shift-mouse-select)
