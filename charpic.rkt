#lang racket/base
(require 2htdp/image)

(define (get-luminosity-list #:path path #:width [width 96])
  (define img (bitmap/file path))
  (define scale-factor
    (/ width (image-width img)))
  (define scaled-image
    (scale/xy scale-factor (/ scale-factor 3) img))
  (define img-color-list
    (image->color-list scaled-image))
  (define luminosity-list
    (for/list ([color-value-list (in-list img-color-list)])
      (λ (r g b)
        (+ (* 0.21 r) (* 0.72 g) (* 0.07 b)))
      (color-red color-value-list)
      (color-blue color-value-list)
      (color-green color-value-list)))
    luminosity-list)
(provide get-luminosity-list)

(define (luminosity->char lum-val)
  (define norm-factor (/ 64 256))
  (define fill-chars
    "`^\",:;Il!i~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$")
  (string-ref fill-chars (round (* norm-factor lum-val))))

(define (luminosity-list->char-list lum-list)
  (for/list ([lum-val (in-list lum-list)])
    (luminosity->char lum-val)))
(provide luminosity-list->char-list)

(require racket/sequence)
(define (char-display char-list [line-width 96])
  (for ([chars (in-slice line-width char-list)])
    (for-each display chars)
    (newline)))
(provide char-display)

(module+ main
  (define char-list
    (luminosity-list->char-list
     (get-luminosity-list #:path "/home/atharva/Pictures/test2.JPG" #:width 361)))
  (char-display char-list 361))

(module+ test
  (require rackunit)

  (check-true (list? (get-luminosity-list
                       #:path "/home/atharva/Pictures/profcrop.jpg")))

  (test-case "checking the luminosity to character mapping"
    (check-equal? (luminosity->char 0) #\`)
    (check-equal? (luminosity->char 255) #\$)
    (check-equal? (luminosity->char 73) #\{)
    (check-true (list? (luminosity-list->char-list (list 73 255 2 124))))))
   
