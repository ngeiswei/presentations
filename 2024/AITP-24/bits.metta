;; Bit strings
(= (bits Z) Nil)
(= (bits (S $k)) (Cons 0 (bits $k)))
(= (bits (S $k)) (Cons 1 (bits $k)))

;; Generate all 3-bit strings
;; !(bits (S (S (S Z))))
!(bits ($x ($y ($z Z))))

;; ;; Outputs
;; [(Cons 0 (Cons 0 (Cons 0 Nil)))
;;  (Cons 0 (Cons 0 (Cons 1 Nil)))
;;  (Cons 0 (Cons 1 (Cons 0 Nil)))
;;  (Cons 0 (Cons 1 (Cons 1 Nil)))
;;  (Cons 1 (Cons 0 (Cons 0 Nil)))
;;  (Cons 1 (Cons 0 (Cons 1 Nil)))
;;  (Cons 1 (Cons 1 (Cons 0 Nil)))
;;  (Cons 1 (Cons 1 (Cons 1 Nil)))]

(= (myand True $x) $x)
(= (myand False $_) False)

!(myand $x $y)
