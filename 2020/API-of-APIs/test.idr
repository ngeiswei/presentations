module Main

data T : Nat -> Type where TC : (n : Nat) -> (T n)
test : ((T n) -> (T m)) -> (T (n + m))
-- test f = -- ?

inc : Int -> Int
inc x = (x + 1)

dec : Int -> Int
dec x = (x - 1)

myeq : (Int -> Int) -> (Int -> Int) -> Bool
myeq f g = (f 1) == (g 1)

myshow : Type -> String
myshow Int = "Int"

myshow : {a : Type} -> (a -> a) -> String
myshow {a} f = if (a == Int)
               then "Int -> Int"
               else "a -> a"

show : (T n) -> String
show (TC n) = "(TC " ++ (show n) ++ ")"

-- Main
main : IO ()
main = do
  putStrLn (show (TC 100))
  putStrLn (show (S Z))
  putStrLn (myshow inc)
  putStrLn (myshow dec)
