module BinarySearch

import Data.Vect

export
find : (n: Nat) -> Vect n Int -> Int -> Maybe Nat
find n array value = search 0 n array
  where search : Nat -> (n: Nat) -> Vect n Int -> Maybe Nat
        search _ 0 _ = Nothing
        search offset (S n) array = if index 0 array == value then Just offset
                                    else search (S offset) n (drop 1 array)
