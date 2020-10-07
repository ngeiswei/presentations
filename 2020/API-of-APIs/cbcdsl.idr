module Main

-- Funded type
data FndType : Nat -> Type -> Type where
  FT : (fund : Nat) -> (datum : a) -> (FndType fund a)

-- Overload show for FndType
show : (FndType fund Nat) -> String
show (FT fund datum) = "FT " ++ (show fund) ++ " " ++ (show datum)

-- Fund accessor
getFund : (FndType fund a) -> Nat
getFund (FT fund datum) = fund

-- Datum accessor
getDatum : (FndType fund a) -> a
getDatum (FT fund datum) = datum

-- Uplift function
upliftFun : (infund : Nat) ->  (outfund : Nat) -> (a -> b)
          -> ((FndType infund a) -> (FndType outfund b))
upliftFun f = (\x => (f (getDatum x)) --TODO

-- Down-lifted function accessor
downliftFun : ((FndType infund a) -> (FndType outfund b)) -> a -> b
downliftFun f = (\x => (getDatum (f (FT infund x))))

-- Lifted increment function. Input fund must be at least 1.
inc : (FndType (S fund) Nat) -> (FndType fund Nat)
inc (FT (S fund) i) = (FT fund (i + 1))

-- -- Lifted composition
-- -- compose : ((FndType infund_b b) -> (FndType outfund_c c)) -> ((FndType infund_a a) -> (FndType outfund_b b))
-- --   -> (FndType (infund_a + infund_b) a) -> (FndType (outfund_b + outfund_c) c)
-- compose : ((FndType fundb b) -> (FndType fundc c)) -> ((FndType funda a) -> (FndType fundb b))
--           -> (FndType funda a) -> (FndType fundc c)
-- compose f g = (\x => (FT (f (g x)))
-- -- compose f g = f . g            --TODO

-- Main
main : IO ()
main = do
  putStrLn (show (FT 100 42))
  putStrLn (show (inc (FT 100 42))) -- Decrement the fund while incrementing the content
