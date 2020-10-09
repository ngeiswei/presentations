-- Small prototype of a cost-based computational eDLS. Each operation
-- has a cost. Functions take a lifted type, FndType, that includes a
-- fund. The output type of each lifted operation contains the
-- remaining fund after the operation.

module Main

-- Funded type
data FndType : Nat -> Type -> Type where
  FT : (fund : Nat) -> (datum : a) -> (FndType fund a)

-- Overload show for FndType
show : (FndType fund Int) -> String
show (FT fund datum) = "FT " ++ (show fund) ++ " " ++ (show datum)

-- Fund accessor
getFund : (FndType fund a) -> Nat
getFund (FT fund datum) = fund

-- Datum accessor
getDatum : (FndType fund a) -> a
getDatum (FT fund datum) = datum

-- Uplift function as to use FndType, with cost of 1.
upliftFun : {fund : Nat} -> (a -> b) -> (FndType (S fund) a) -> (FndType fund b)
upliftFun {fund} f = (\x => (FT fund (f (getDatum x))))

-- Downlift function as to run over datum rather than FndType.
downliftFun : {infund : Nat} -> ((FndType infund a) -> (FndType outfund b)) -> a -> b
downliftFun {infund} f = (\x => (getDatum (f (FT infund x))))

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
main : IO ()
main = do
  putStrLn (show (FT 100 42))
  putStrLn (show (inc (FT 100 42))) -- Decrement the fund while incrementing the content
  putStrLn (show ((compose inc dec) (FT 100 42))) -- Decrement the fund by 2
