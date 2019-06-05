#lang racket/base
(require 2htdp/image)

(define (get-brightness-list name path)
  (define img-color-list
    (image->color-list (bitmap/file path)))
  (define luminosity-list
    (for/list ([color-value-list (in-list img-color-list)])
      (λ (r g b)
        (+ (* 0.21 r) (* 0.72 g) (* 0.07 b)))
      (color-red color-value-list)
      (color-blue color-value-list)
      (color-green color-value-list)))
    luminosity-list)
(provide get-brightness-list)

(module+ main
  (get-brightness-list "somename" "/home/atharva/Pictures/profcrop.jpg"))

(module+ test
  (require rackunit)
  (check-true (list? (get-brightness-list "somename" "/home/atharva/Pictures/profcrop.jpg"))))
