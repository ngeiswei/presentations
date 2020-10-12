module Main

import Data.Vect
-- import Data.SortedMap
-- import Data.Matrix

import FndType

-- Split MOSES into 3 modules:

-- Vectorize -- Turn syntax tree into vector space (program subspace)
-- Optimize vector space -- Find good vector candidate
-- Meta-optimize -- Discover regularities in the vector space

-- Example: MOSES, evolve syntax trees, call external AI for the
-- optimization step in vector space.

-- * MOSES (very abstract) type signature:

-- moses : Fitness -> Population -> Population

-- data Candidate = ... -- Syntax tree
-- type Fitness = Candidate -> Float
-- type Population = Map Candidate Float

-- * Optimize Vector Space (very abstract) type signature:

-- VecFitness -> (Vector Float) -> VecPopulation
-- type VecFitness = Vector Float -> Float
-- type VecPopulation = Map (Vector Float) Float

-- * Meta-optimize (very abstract) type signature:

-- type OptimizationRecord = Map (Vector Float) Float = VecPopulation
-- data FitnessEstimate = ... -- Probabilistic model
-- moptimize : OptimizationRecord -> FitnessEstimate

-- data Candidate : (k : Nat) -> (vd : Vect k Double) -> Type where
--   C : (k : Nat) -> (vd : Vect k Double) -> (Candidate k vd)
data Candidate : (k : Nat) -> Type where
  C : (k : Nat) -> (Candidate k)
  
-- myshow : (Candidate k vd) -> String
myshow : (Candidate k) -> String
myshow c = "candidate"
  
-- data Candidate : (k : Nat) -> (Vect k Double) -> Type where
--   C : {k : Nat} -> (vd : Vect k Double) -> (Candidate k vd)

-- data ScoredCandidate : (n : Nat) -> (Vect n Double) -> Double -> Type where
--   SV : {n : Nat} -> (candidate : (Vect n Double)) -> (score : Double) -> (ScoredVect candidate score)

-- opt : (FndType (100 + fund) (Vect n Double -> Double)) 
--     -> (FndType fund (Vect 100 (Vect n Double) Double))
-- opt f = FT Empty

-- mopt : SortedMap (Vect Float) Float

-- Run backward from the fitness to the candidates.

-- * Putting it all together:

-- f : Fitness
-- v : Vectorize
-- s : Symbolize

-- vecopt : VecFitness -> (Vector Float) -> VecPopulation
-- vecopt_rec : VecFitness -> (Vector Float) -> Termination -> VecPopulation

-- i : Candidate -- Initial candidate
-- moses f i = vecopt_rec (f . s) (v i) t
--   where s, v, t ...

-- vf : VecFitness
-- fe : FitnessEstimate
-- vi : Vector Float
-- t : Termination
-- vecopt_rec vf fe vi t = (union sols (vecopt_rec vf nfe (decrease t)))
--   where sols = (vecopt vf vi),
--         new_fe = (join (moptimize sols) fe (select sols)),
--         join = ... -- merge 2 fitness estimates  

-- Main
vec : Vect 3 Double
vec = [4.0, 2.0, 42.0]
-- cnd : Candidate 3 vec
-- cnd = C 3 vec
cnd : Candidate 3
cnd = C 3
main : IO ()
main = do
  putStrLn "What?"
  putStrLn (show vec)
  -- putStrLn (show cnd)
