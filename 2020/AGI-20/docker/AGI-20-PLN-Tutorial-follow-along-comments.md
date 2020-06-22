====================================================================

** Talking

For now we don't need to define what is the sample space, we just
events, that is subsets over that sample space and their
relationships.  Later we'll see how to precisely define a sample
space, if we want to, cause most of the time you actually don't need
to, or at least in principle.

** Resources

Repositories:

opencog/singnet policy for merging code is more strict

https://github.com/singnet/atomspace
https://github.com/singnet/pln
https://github.com/singnet/miner

or

https://github.com/opencog/atomspace
https://github.com/opencog/pln
https://github.com/opencog/miner

OpenCog Wiki:

https://wiki.opencog.org/w/The_Open_Cognition_Project

* Install OpenCog
** Install Docker
sudo apt install docker.io
** Pull opencog image
sudo docker pull ngeiswei/opencog:agi20
** Run opencog image
sudo docker run -it ngeiswei/opencog:agi20 bash
* Run OpenCog
** Import opencog in guile
guile
(use-modules (opencog) (opencog exec))
** Populate the atomspace
(Concept "A")                           ; Add concept A
(cog-prt-atomspace)                     ; Print content of the atomspace
(Concept "A" (stv 0.2 0.3)))            ; Add A with tv
(Concept "B" (stv 0.1 0.4)))            ; Add B with tv
(Concept "C" (stv 0.3 0.2)))            ; Add C with tv
(Subset (stv 0.6 0.1)                   ; Add P(B|A) ~= 0.6
  (Concept "A")
  (Concept "B"))
** Query simple example
(define X (Variable "$X"))
(define Y (Variable "$Y"))
(define Z (Variable "$Z"))

(Get                                    ; Fetch all concepts
  (TypedVariable X (Type 'Concept))
  (Present X))

(Get                                    ; Fetch all subsets
  (VariableList
    (TypedVariable X (Type 'Concept))
    (TypedVariable Y (Type 'Concept)))
  (Present (Subset X Y)))

(Bind                                   ; 1-step transitive closure of subset
  (VariableSet
    (TypedVariable X (Type 'Concept))
    (TypedVariable Y (Type 'Concept))
    (TypedVariable Z (Type 'Concept)))
  (Present
    (Subset X Y)
    (Subset Y Z))
  (Subset X Z))

# OK, this is a very simple example here, there's a lot more stuff
# that can happen, it's actually an entire programming language call
# atomese.

# So you may see that the last example looks like an inference rule,
# (Subset X Y) and (Subset Y Z) are the premises and (Subset X Z) is
# the conclusion. So what PLN is gonna do is take a bunch of these
# rules, they are gonna more sophisticated because they also need to
# modify the truth value of the conclusion, and it's gonna glue these
# rules together to build an inference chain, or inference tree.

** Run simple PLN inference (indirect evidence)
# RB
(use-modules (opencog) (opencog exec) (opencog pln))
(pln-load 'empty)             ; Load empty rule-base
(pln-add-rules 'subset-deduction 'subset-modus-ponens)
(pln-prt-atomspace)
(pln-rules)
(pln-weighted-rules)

# KB
(define A (Concept "A" (stv 0.1 0.6)))
(define B (Concept "B" (stv 0.2 0.2)))
(define C (Concept "C"))
(Subset (stv 0.8 0.1) A B)
(Subset (stv 0.5 0.4) B C)

# Verify
(cog-prt-atomspace)

# Call PLN in backward chainer mode on C
(pln-bc C)

# Now we are gonna redo the same but this time we are gonna enable
# logging, just to get a glimpse of what is happening under the
# cover.

# OK, let's change the log level to debug, that should be enough
(ure-logger-set-level! "debug")

# and we're gonna have it being displayed right in front of our eyes
(ure-logger-set-stdout! #t)

# Let's reset the truth value of C
(cog-set-tv! C (stv 1 0))

# And rerun PLN on C
(pln-bc C)

# OK, so that's a lot of information, I'm not gonna explain everything
# but we can have a selective look at some places.

** Run simple PLN inference (direct evidence)
(use-modules (opencog) (opencog exec) (opencog logger) (opencog ure) (opencog pln))
(ure-logger-set-level! "debug")
(ure-logger-set-stdout! #t)
(cog-logger-set-level! "debug")
(cog-logger-set-stdout! #t)
(clear)
(pln-load 'empty)
(pln-rules)

; Sample space:
;
; Instances of individuals (individuals at certain times). for example
;
; Eve1, Eve2, etc. which represent the same individual in different
; states, at different times. This is gonna be out sample space.

(define E1 (Node "Eve1"))
(define E2 (Node "Eve2"))
(define G1 (Node "Gus1"))
(define G2 (Node "Gus2"))

;
; Concepts over this sample space:
;
; Man, Woman, Pandemic, Beard, as well Eve and Gus, etc
(define Man (Concept "Man"))
(define Woman (Concept "Woman"))
(define Pandemic (Concept "Pandemic"))
(define Beard (Concept "Beard"))
(define Eve (Concept "Eve"))
(define Gus (Concept "Gus"))

; Individuals
(Member (stv 1 1)
  E1
  Eve)
(Member (stv 1 1)
  E2
  Eve)
(Member (stv 1 1)
  G1
  Gus)
(Member (stv 1 1)
  G2
  Gus)

; Gender
(Subset (stv 1 1)
  Eve
  Woman)
(Subset (stv 1 1)
  Gus 
  Man)

; Traits
(Member (stv 1 1)
  G2
  Beard)

; Pandemic
(Member (stv 1 1)
  E2
  Pandemic)
(Member (stv 1 1)
  G2
  Pandemic)

; What is the probability of growing a beard during a pandemic
(define Pandemic->Beard (Subset Pandemic Beard))

; Call PLN
(pln-add-rule 'subset-direct-introduction)
(pln-bc Pandemic->Beard)

; What is the probability for a man of growing a beard during a pandemic
(define ManPandemic->Beard (Subset (And Man Pandemic) Beard))

; Call PLN again
(pln-bc ManPandemic->Beard)

; It didn't manage to infer the truth value, and that's because it
; doesn't know how to deal with the conjunction of man and pandemic,
; so we're gonna add a few more rules
;
; 1. conjunction-direct-introduction
; 2. concept-direct-evaluation
; 3. member-deduction
(pln-add-rule 'conjunction-direct-introduction)
(pln-add-rule 'concept-direct-evaluation)
(pln-add-rule 'member-deduction)

; Call PLN again
(pln-bc ManPandemic->Beard #:complexity-penalty 1)

# Expected results

# (SetLink
#   (SubsetLink (stv 1 0.00124844)
#     (AndLink (stv 0.25 0.00497512)
#       (ConceptNode "Man" (stv 0.5 0.00497512))
#       (ConceptNode "Pandemic" (stv 0.5 0.00497512)))
#     (ConceptNode "Beard")))

# With inference tree

# [2020-06-21 17:04:23:983] [DEBUG] [URE] Iteration 79/100
# [2020-06-21 17:04:24:229] [DEBUG] [URE] With inference tree:
#
# [a493546cc19e040e][a] [cf40e1ad977b6b6e][a] [ee78dea3ab2a3e4a][a] [f8d8ff0b0322ac38][a]
# -------------member-deduction-------------- -------------member-deduction--------------
#            [b288aa0e6e5f70a5][a]                       [bf4c12cbc3ec042b][a]
#            ====================concept-direct-evaluation====================
# [5a31d4447bafb9a8][1]            [449c5b4225dc3e3f][1]
# ===========conjunction-direct-introduction============
#                 [d1789a42e65af957][1] [4517724b99b0800b][1]
#                 --------subset-direct-introduction---------
#                            [ffc532e999d08bbe][1]

** Pattern Miner simple example
(use-modules (opencog) (opencog exec) (opencog miner))

; KB
(define A (Concept "A"))
(define B (Concept "B"))
(define C (Concept "C"))
(define D (Concept "D"))
(define E (Concept "E"))
(Subset A B)
(Subset A C)
(Subset A D)
(Subset B E)
(Subset C E)
(Subset D E)

; Miner
(cog-mine (cog-atomspace) #:minsup 3)
** Pattern Miner less simple example
