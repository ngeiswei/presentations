-- Small prototype of a cost-based computational eDLS. Each operation
-- has a cost. Functions take a lifted type, FndType, that includes a
-- fund. The output type of each lifted operation contains the
-- remaining fund after the operation.

module Main

-- Funded type
data FndType : Nat -> Type -> Type where
  FT : {fund : Nat} -> (datum : a) -> (FndType fund a)

-- Overload show for FndType
show : (FndType fund Int) -> String
show (FT datum) = "FT " ++ (show fund) ++ " " ++ (show datum)

-- Fund accessor
getFund : (FndType fund a) -> Nat
getFund (FT datum) = fund

-- Datum accessor
getDatum : (FndType fund a) -> a
getDatum (FT datum) = datum

-- Uplift function as to use FndType, with cost of 1.
upliftFun : {fund : Nat} -> (a -> b) -> (FndType (S fund) a) -> (FndType fund b)
upliftFun f = (\x => (FT (f (getDatum x))))

-- Downlift function as to run over datum rather than FndType.
downliftFun : {infund : Nat} -> ((FndType infund a) -> (FndType outfund b)) -> a -> b
downliftFun f = (\x => (getDatum (f (FT x))))

-- Lifted increment function. Input fund must be at least 1.
inc : (FndType (S fund) Int) -> (FndType fund Int)
inc = upliftFun (\x => (x + 1))

-- Lifted decrement function. Input fund must be at least 1.
dec : (FndType (S fund) Int) -> (FndType fund Int)
dec = upliftFun (\x => (x - 1))

-- Lifted composition. Takes 2 filted functions and compose them
compose : ((FndType fund_b b) -> (FndType fund_c c))
        -> ((FndType fund_a a) -> (FndType fund_b b))
        -> (FndType fund_a a) -> (FndType fund_c c)
compose f g = (\x => (f (g x)))

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
