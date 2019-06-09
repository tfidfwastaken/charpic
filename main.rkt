#lang racket/base
(require "charpic.rkt")
(require racket/cmdline)

(define line-width (make-parameter 361))

(define image-path
  (command-line
   #:program "charpic"
   #:once-each
   [("-w" "--width") lw
                     "Set the width of pictures in characters"
                     (line-width (string->number lw))]
   #:args (path) path))

(define char-list
  (luminosity-list->char-list
   (get-luminosity-list #:path image-path #:width (line-width))))

(char-display char-list (line-width))
