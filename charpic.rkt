#lang racket/base
(require 2htdp/image)

(define (get-luminosity-list name path)
  (define img-color-list
    (image->color-list (scale 0.1 (bitmap/file path))))
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

(define (char-display char-list line-width)
  (for ([char (in-list char-list)]
        [i (in-naturals 1)])
    (for ([j (in-range 3)]) (display char))
    (when (zero? (modulo i line-width))
      (display #\newline))))
(provide char-display)

(module+ main
  (define char-list
    (luminosity-list->char-list
     (get-luminosity-list "somename" "/home/atharva/Pictures/profcrop.jpg")))
  (char-display char-list 91))

(module+ test
  (require rackunit)

  (check-true (list? (get-luminosity-list
                      "somename" "/home/atharva/Pictures/profcrop.jpg")))

  (test-case "checking the luminosity to character mapping"
    (check-equal? (luminosity->char 0) #\`)
    (check-equal? (luminosity->char 255) #\$)
    (check-equal? (luminosity->char 73) #\{)
    (check-true (list? (luminosity-list->char-list (list 73 255 2 124))))))
   
