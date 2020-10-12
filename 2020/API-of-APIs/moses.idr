module Main

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

-- Lifted increment function. Input fund must be at least 1.
inc : (FndType (S fund) Int) -> (FndType fund Int)
inc = upliftFun (\x => (x + 1))

-- Lifted decrement function. Input fund must be at least 1.
dec : (FndType (S fund) Int) -> (FndType fund Int)
dec = upliftFun (\x => (x - 1))

-- Main
rich_42 : FndType 1000 Int
rich_42 = FT 42
poor_42 : FndType 1 Int
poor_42 = FT 42
main : IO ()
main = do
  putStrLn (show rich_42)
  putStrLn (show (inc rich_42)) -- Decrement the fund while incrementing the content
  putStrLn (show (inc poor_42)) -- Just enough fund
  putStrLn (show ((compose inc dec) rich_42)) -- Decrement the fund by 2
  -- putStrLn (show ((compose inc dec) poor_42)) -- Not enough fund
