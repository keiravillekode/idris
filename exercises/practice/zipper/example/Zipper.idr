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
fromTree t = MkZipper t []

export
toTree : Zipper a -> Tree a
toTree (MkZipper t []) = t
toTree (MkZipper t (LeftCrumb v r :: cs)) = toTree (MkZipper (Node t v r) cs)
toTree (MkZipper t (RightCrumb v l :: cs)) = toTree (MkZipper (Node l v t) cs)

export
left : Zipper a -> Maybe (Zipper a)
left (MkZipper (Node l@(Node _ _ _) v r) cs) = Just (MkZipper l (LeftCrumb v r :: cs))
left _ = Nothing

export
right : Zipper a -> Maybe (Zipper a)
right (MkZipper (Node l v r@(Node _ _ _)) cs) = Just (MkZipper r (RightCrumb v l :: cs))
right _ = Nothing

export
up : Zipper a -> Maybe (Zipper a)
up (MkZipper t (LeftCrumb v r :: cs)) = Just (MkZipper (Node t v r) cs)
up (MkZipper t (RightCrumb v l :: cs)) = Just (MkZipper (Node l v t) cs)
up _ = Nothing

export
value : Zipper a -> Maybe a
value (MkZipper (Node _ v _) _) = Just v
value _ = Nothing

export
setValue : a -> Zipper a -> Zipper a
setValue v (MkZipper (Node l _ r) cs) = MkZipper (Node l v r) cs
setValue v (MkZipper Leaf cs) = MkZipper (Node Leaf v Leaf) cs

export
setLeft : Tree a -> Zipper a -> Zipper a
setLeft t (MkZipper (Node _ v r) cs) = MkZipper (Node t v r) cs
setLeft _ z = z

export
setRight : Tree a -> Zipper a -> Zipper a
setRight t (MkZipper (Node l v _) cs) = MkZipper (Node l v t) cs
setRight _ z = z
