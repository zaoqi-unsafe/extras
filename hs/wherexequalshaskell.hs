{-
running through learnxiny
this is a multiline comment
-}

-- this is a single-line comment
3 -- is three, a number
1 + 9 - (8 * (6 / 345)) -- 9.860869..etc....
9 `div` 4 -- 2

True
False -- primitives

-- commenting out the below because hlint wants me to just say True
-- not False -- True
1 == 1 -- True
10 > 1000 -- False

-- not is a function that takes one value.
-- arguments are just lined up after the function call (no parens)

"Here's a string."
'z' -- is a character
-- 'This is not valid.'
"This string " ++ "is concatenated with this one."
['T', 'h', 'i', 's', ' ', 'i', 's', ' '] -- a string (just arr of chars)
"String." !! 4 -- 'n'

-- lists need to be all the same type. destructuring works.
[1..10] == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
['a'..'c'] == ['a', 'b', 'c']
-- can skip
[2,4..8] == [2,4,6,8]
-- can't go backwards by default, so [10..0] breaks but the following is okay:
[10,8..0]
-- this could be infinite, so ['A'..], or [0..], for example. yeek.
-- can pass to get index of, like [0..] !! 100 is 100
[0..10] ++ [11..100]
1:[2..10] -- adds to beginning of list
head [0..4] -- 0
-- also last, for last of list
-- tail for all but first
-- init is... all except last?

-- list comprehensions: creating list based on extant list
[x+1 | x <- [2..8]] -- [3,4,5,6,7,8,9]
-- this has a conditional
[x+1 | x <- [2..8], x+2 > 4] -- [4,5,6,7,8,9]

-- tuples can be of mixed type. tuples have fixed length.
("things", 4) -- is a tuple
-- i think the below only work on sets of two.
fst ("things", 4) -- "things"
snd ("things", 4) -- 4

-- FUNCTIONS. THIS IS THE IMPORTANT BIT, OBVIOUSLY.
add x y = x + y
-- this works in source. with the repl, need the let keyword. for example:
-- let mult q r = q * r
-- fn call can be before or between (only two?) args
add 4 4 -- 8
16 `add` 16 -- 32
-- function definitions have few (or no?) restrictions, i think.
(**) t u = t * (t * u)
(**) 4 4 -- i think without parens in source, with in the repl
-- guards are like conditionals (if/if...else) ??
-- from the thing:
fib x
  | x < 2 = 1
  | otherwise = fib (x - 1) + fib (x - 2)
-- you can use a sort of pattern matching to choose which fn
-- definition to use?! i think this is the same thing as above.
fib 1 = 1
fib 2 = 2
fib x = fib (x - 1) + fib (x - 2)
-- that thing again, works on tuples and lists
bar (a, b) = (a * b, b + a)
-- writing map; x is first, xs is rest
aMap func [] = []
aMap func (x:xs) = func x:(aMap func xs)
-- anonymous functions: backslash, then args
aMap (\x -> x + x) [0..10]
-- fold (inject?): foldl1 means fold left, use first val in
-- list as initial for accumulator (wat?)
foldl1 (\acc x -> acc + x) [0..10]

-- currying(?) (or partial application, anyway... are they different?)
mult x y = x * y
quux = mult 4
quux 4 -- 16
-- different syntax for the same:
quux (4*)
quux 4

-- composition uses . to chain them
-- baz multiplies argument by 4, then adds 4 to tha
baz = (4+) . (4*)
baz 4 -- 20

-- there's a $ operator. it applies fn to param. it has priority of 0
-- and is 'right-associative' (wat?).
-- regular calls are 10 priority (highest) and are 'left-associative' (again, wat?)
-- so... expression on right is param to fn on left?
even (fib 7) -- false
even $ fib 7 -- same thing
even . fib $ 7 -- also false

-- TYPES! i mean, type signatures. or something. this matters a lot, i believe.
-- because it's haskell. which is strongly typed. which is important.
False :: Bool
4 :: Integer
"Yo" :: String
-- not :: Bool -> Bool -- takes Bool, returns Bool
-- mult :: Integer -> Integer -> Integer
triple :: Integer -> Integer
triple q = q * 3

-- if
something = if 1 == 1 then "asdf" else "ghjkl;" -- something = "asdf"
another = if 2 < 0
             then "wat"
             else "wut"
-- another = "wut"
-- note that the indentation is significant

-- case
case args of
  "halp" -> showHalp
  "start" -> doStuff
  _ -> putStrLn "do better naxt tym"

-- loops? what loops? we don't need loops. we recurse! ...and stuff.
map (+10) [1..10] -- MAP
for array func = map func array -- whaaaat is this
for [0..10] $ \i -> show i -- i don't know what's happening
for [0..10] show -- this is the same thing?
--foldl (or foldr) fn initial-value list
foldr (\x y -> 4*x + y) 4 [0..4] -- 44
foldl (\x y -> 4*x + y) 4 [0..4] -- 4208

-- data types
-- new:
data Foo = Bar | Quux | Baz
say :: Foo -> String
say Bar = "sup"
say Quux = "brah"
say Baz = "asdfghjkl;"
-- can take params
data Something x = Wat | Wut x
Wut "oi" -- type : Something String
Wut 8    -- type : Something Int
Wat      -- type : Something x (for any 'x')

-- io
-- when hs is run, main is called. it's of type IO x for some x.
main :: IO ()
main = putStrLn $ "sup " ++ (say Quux)
-- putStrLn :: String -> IO ()
-- interact takes fn of String -> String
-- interact :: (String -> String) -> IO ()
countStuff :: String -> String
countStuff = show . length . lines
main' = interact countStuff
-- so type IO () means it's a series of things for computer to do.
-- that sounds awfully imperative and procedural. do makes it even moreso.
sayHi :: IO ()
sayHi = do
  putStrLn "who are you?"
  name <- getLine -- gets line as name
  putStrLn $ "hey, " ++ name
-- getLine :: IO String
-- means that String is generated when getLine is executed
something :: IO String
something = do
  putStrLn "this is a string"
  input1 <- getLine
  input2 <- getLine
  return (input1 ++ "\n" ++ input2)
  -- return is not a keyword here! it's a function.
  -- return :: String -> IO String
  -- so, its type is implicit? i guess actual annotations are
  -- superfluous a lot of the time? i think?
main'' = do
  putStrLn "this is one line"
  return <- something
  putStrLn result
  putStrLn "this is the next line"
-- so, IO is a monad. uhm. this is where i get lost. what.
-- fns that interact with externals are IO in the type signature
-- (because they do IO).

-- ghci
-- needs the keyword let before things
-- :q, :t (type) (let foo = 4 ; :t foo : foo :: Num a => a)
-- :t (:) is (:) :: a -> [a] -> [a]
-- so you can inspect punctuation functions with parens, eg
-- (+), ($).
-- :i is info(?)
-- so :i (*) for example
-- all IO types can be run directly, i think.
