#lang racket
(require racket/trace)
(define (f lst)
; checks to make sure that the list isn't empty ;
(if (null? lst)
;returns an empty list ;
    '()
;Makes a new list, adds 1 to the first element in the previous list, and recursively
;calls the function again with the list, minus the previous first element;
    (cons (+ 1 (car lst)) (f (cdr lst)))))
;traces through each step of the function and prints out what is going on;
(trace f)

(define (member? e lst)
  ;Checks to make sure the list isn't null, and if so returns false;
  (if (null? lst) #f 
  ;if the element e is the same as the first element in the list returns true;
  ;otherwise calls the method again checking the rest of the list;
      (if (eqv? e (car lst)) #t (member? e (cdr lst)))))

(define (set? lst)
  ;if the list is empty that means it returns true, as in it is a valid set (no repeats);
  (if (null? lst) #t
      ;checks to make sure the first element in the list isn't in the rest of the list;
      (if (member? (car lst) (cdr lst))
          ;returns false if the first element repeats, so the set isn't valid.;
          #f
          ;recursively calls itself with the list, minus the first element;
          (set? (cdr lst)))))

(define (union lst1 lst2)
  ;if lst2 is empty, returns lst1;
  (cond ((null? lst2) lst1)
        ;checks if the first element in lst2 is in lst1, and if it is, it will skip that element in lst2 then tries to add in the next element in lst2 to lst1;
        ((member? (car lst2) lst1) 
        (union lst1 (cdr lst2)))
        ;if first element of lst2 isn't in lst1, adds it to lst1 and then calls union again with the new lst1 and lst2, minus the first element;
        (#t(union (cons (car lst2) lst1) (cdr lst2)))))
                                     
(define (intersect lst1 lst2)
  (if (null? lst2) '()
      ;checks if there are two elements in lst2 or more to decide what needs to be done;
        (if (null? (cdr lst2))
            ;if there is only one element in lst2 it checks if it is also in lst1 or not.
             (if (member? (car lst2) lst1) lst2 '())
             ;if there are more than one elements in lst2, sees if each element is in lst1 or not. If it is, adds it to a list that will contain all repeats;
             (if (member? (car lst2) lst1) (cons (car lst2) (intersect (cdr lst2) lst1))
                 (intersect lst1 (cdr lst2))))))
