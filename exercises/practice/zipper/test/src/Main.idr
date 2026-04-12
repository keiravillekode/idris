module Main

import System
import Tester
import Tester.Runner

import Zipper

export
Eq a => Eq (Tree a) where
  (==) Leaf Leaf = True
  (==) (Node l1 v1 r1) (Node l2 v2 r2) = l1 == l2 && v1 == v2 && r1 == r2
  (==) _ _ = False

export
Show a => Show (Tree a) where
  show Leaf = "Leaf"
  show (Node l v r) = "(Node " ++ show l ++ " " ++ show v ++ " " ++ show r ++ ")"


tests : List Test
tests =
  [ test "data is retained"                                   (assertEq (map toTree (Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf))))) (Just (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf))))
  , test "left, right and value"                              (assertEq ((((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left) >>= right) >>= value) (Just 3))
  , test "dead end"                                           (assertEq (map toTree (((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left) >>= left)) (the (Maybe (Tree Int)) Nothing))
  , test "tree from deep focus"                               (assertEq (map toTree (((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left) >>= right)) (Just (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf))))
  , test "traversing up from top"                             (assertEq (map toTree ((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= up)) (the (Maybe (Tree Int)) Nothing))
  , test "left, right, and up"                                (assertEq ((((((((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left) >>= up) >>= right) >>= up) >>= left) >>= right) >>= value) (Just 3))
  , test "test ability to descend multiple levels and return" (assertEq ((((((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left) >>= right) >>= up) >>= up) >>= value) (Just 1))
  , test "set_value"                                          (assertEq (map toTree (map (setValue 5) ((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left))) (Just (Node (Node Leaf 5 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf))))
  , test "set_value after traversing up"                      (assertEq (map toTree (map (setValue 5) ((((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left) >>= right) >>= up))) (Just (Node (Node Leaf 5 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf))))
  , test "set_left with leaf"                                 (assertEq (map toTree (map (setLeft (Node Leaf 5 Leaf)) ((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left))) (Just (Node (Node (Node Leaf 5 Leaf) 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf))))
  , test "set_right with null"                                (assertEq (map toTree (map (setRight Leaf) ((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left))) (Just (Node (Node Leaf 2 Leaf) 1 (Node Leaf 4 Leaf))))
  , test "set_right with subtree"                             (assertEq (map toTree (map (setRight (Node (Node Leaf 7 Leaf) 6 (Node Leaf 8 Leaf))) (Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))))) (Just (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node (Node Leaf 7 Leaf) 6 (Node Leaf 8 Leaf)))))
  , test "set_value on deep focus"                            (assertEq (map toTree (map (setValue 5) (((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left) >>= right))) (Just (Node (Node Leaf 2 (Node Leaf 5 Leaf)) 1 (Node Leaf 4 Leaf))))
  , test "different paths to same zipper"                     (assertEq (map toTree ((((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= left) >>= up) >>= right)) (map toTree ((Just (fromTree (Node (Node Leaf 2 (Node Leaf 3 Leaf)) 1 (Node Leaf 4 Leaf)))) >>= right)))
  ]

export
main : IO ()
main = do
  success <- runTests tests
  if success
     then putStrLn "All tests passed"
     else exitFailure
