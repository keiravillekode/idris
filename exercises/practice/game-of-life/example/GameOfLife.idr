module GameOfLife

import Data.Vect

export
tick : (n : Nat) -> Vect n (Vect n (Fin 2)) -> Vect n (Vect n (Fin 2))
tick n matrix = matrix
