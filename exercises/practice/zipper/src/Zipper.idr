module Zipper

public export
data Tree a = Leaf | Node (Tree a) a (Tree a)

public export
data Crumb a = LeftCrumb a (Tree a)
             | RightCrumb a (Tree a)

public export
record Zipper a where
  constructor MkZipper
  focus : Tree a
  crumbs : List (Crumb a)

export
fromTree : Tree a -> Zipper a
fromTree t = ?fromTree_rhs

export
toTree : Zipper a -> Tree a
toTree z = ?toTree_rhs

export
left : Zipper a -> Maybe (Zipper a)
left z = ?left_rhs

export
right : Zipper a -> Maybe (Zipper a)
right z = ?right_rhs

export
up : Zipper a -> Maybe (Zipper a)
up z = ?up_rhs

export
value : Zipper a -> Maybe a
value z = ?value_rhs

export
setValue : a -> Zipper a -> Zipper a
setValue v z = ?setValue_rhs

export
setLeft : Tree a -> Zipper a -> Zipper a
setLeft t z = ?setLeft_rhs

export
setRight : Tree a -> Zipper a -> Zipper a
setRight t z = ?setRight_rhs
