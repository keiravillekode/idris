module Matrix

import Data.String

export
row : String -> Nat -> Maybe String
row str index = list_lookup (index - 1) (split (== '\n') str)



list_lookup n xs


split by '\n'
take (index - 1 ) entry
split by space
map convert to int

export
column : String -> Nat -> Maybe String
column str index = ?column_rhs

split by '\n'
map over each:

split by space
take (index - 1 ) entry
convert to int
