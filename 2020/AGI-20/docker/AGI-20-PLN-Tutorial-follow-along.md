# AGI-20 OpenCog, PLN, Miner Tutorial

## Run docker

```bash
sudo docker run -it ngeiswei/opencog:agi20 bash
```

## Start the guile interpreter

```bash
guile
```

## AtomSpace

### Load OpenCog and Atomese interpreter

```scheme
(use-modules (opencog) (opencog exec))
```

### Populate the atomspace

```scheme
(Concept "A")                           ; Add concept A
(Concept "A" (stv 0.2 0.3)))            ; Add A with tv
(Concept "B" (stv 0.1 0.4)))            ; Add B with tv
(Concept "C" (stv 0.3 0.2)))            ; Add C with tv
(Subset (stv 0.6 0.1)                   ; Add P(B|A) ~= 0.6
  (Concept "A")
  (Concept "B"))
```

### Display atomspace content

```scheme
(cog-prt-atomspace)
```

### Query the atomspace

```scheme
;; Helper
(define X (Variable "$X"))
(define Y (Variable "$Y"))
(define Z (Variable "$Z"))

;; Fetch all concepts
(Get
  (TypedVariable X (Type 'Concept))
  (Present X))

;; Fetch all subsets
(Get
  (VariableList
    (TypedVariable X (Type 'Concept))
    (TypedVariable Y (Type 'Concept)))
  (Present (Subset X Y)))

;; 1-step transitive closure of subset
(Bind
  (VariableSet
    (TypedVariable X (Type 'Concept))
    (TypedVariable Y (Type 'Concept))
    (TypedVariable Z (Type 'Concept)))
  (Present
    (Subset X Y)
    (Subset Y Z))
  (Subset X Z))
```

## PLN

### Clear the atomspace

```scheme
(clear)
```

### Load PLN

```scheme
(use-modules (opencog) (opencog exec) (opencog pln))
```

### Load rules

```scheme
(pln-load 'empty)
(pln-add-rules 'subset-deduction 'subset-modus-ponens)
```

### Display PLN atomspace content and rules

```scheme
(pln-prt-atomspace)
(pln-rules)
(pln-weighted-rules)
```

### PLN example 1 (deduction and modus ponens)

#### Populate atomspace

```scheme
(define A (Concept "A" (stv 0.1 0.6)))
(define B (Concept "B" (stv 0.2 0.2)))
(define C (Concept "C"))
(Subset (stv 0.8 0.1) A B)
(Subset (stv 0.5 0.4) B C)
(cog-prt-atomspace)
```

#### Call PLN in backward chainer mode on C

```scheme
(pln-bc C)
```

#### Enable logging

```scheme
(ure-logger-set-level! "debug")
(ure-logger-set-stdout! #t)
```

#### Recall PLN on C

```scheme
(cog-set-tv! C (stv 1 0))   ; Reset C
(pln-bc C)
```

### PLN example 2 (direct evidence)

#### Clear atomspace and rule base

```scheme
(clear)
(pln-load 'empty)
```

#### Populate atomspace

```scheme
; Sample space: individual instances. For example:
;
; Eve1, Eve2, etc. representing the same individual in different
; states, at different times.

(define E1 (Node "Eve1"))
(define E2 (Node "Eve2"))
(define G1 (Node "Gus1"))
(define G2 (Node "Gus2"))

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
```

#### Define target

Probability of growing a beard during a pandemic.

```scheme
(define Pandemic->Beard (Subset Pandemic Beard))
```

#### Add rule

```scheme
(pln-add-rule 'subset-direct-introduction)
```

#### Call in backward chainer mode on the target

```scheme
(pln-bc Pandemic->Beard)
```

#### Define new target

Probability for a man of growing a beard during a pandemic.

```scheme
(define ManPandemic->Beard (Subset (And Man Pandemic) Beard))
```

#### Call PLN on new target

```scheme
(pln-bc ManPandemic->Beard)
```

#### Add more rules

```scheme
(pln-add-rule 'conjunction-direct-introduction)
(pln-add-rule 'concept-direct-evaluation)
(pln-add-rule 'member-deduction)
```

#### Call PLN again

```scheme
(pln-bc ManPandemic->Beard #:complexity-penalty 1)
```

## Miner

### Miner example 1

#### Clear the atomspace, disable logger

```scheme
(clear)
(ure-logger-set-stdout! #f)
```

#### Load the pattern miner

```scheme
(use-modules (opencog) (opencog exec) (opencog miner))
```

#### Populate atomspace

```scheme
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
```

#### Call miner

```scheme
(cog-mine (cog-atomspace) #:minsup 3)
```

### Miner example 2

TODO
