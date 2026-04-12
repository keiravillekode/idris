def tree_to_idris(t):
    if t is None:
        return "Leaf"
    v = t["value"]
    l = tree_to_idris(t["left"])
    r = tree_to_idris(t["right"])
    return f"(Node {l} {v} {r})"


def apply_op(op, expr):
    name = op["operation"]
    if name == "to_tree":
        return f"(map toTree {expr})"
    elif name in ("value", "left", "right", "up"):
        return f"({expr} >>= {name})"
    elif name == "set_value":
        item = op["item"]
        return f"(map (setValue {item}) {expr})"
    elif name == "set_left":
        item = tree_to_idris(op["item"])
        return f"(map (setLeft {item}) {expr})"
    elif name == "set_right":
        item = tree_to_idris(op["item"])
        return f"(map (setRight {item}) {expr})"
    else:
        raise ValueError(f"Unknown operation: {name}")


def chain_ops(tree, ops):
    expr = f"(Just (fromTree {tree_to_idris(tree)}))"
    for op in ops:
        expr = apply_op(op, expr)
    return expr


def header():
    return """
export
Eq a => Eq (Tree a) where
  (==) Leaf Leaf = True
  (==) (Node l1 v1 r1) (Node l2 v2 r2) = l1 == l2 && v1 == v2 && r1 == r2
  (==) _ _ = False

export
Show a => Show (Tree a) where
  show Leaf = "Leaf"
  show (Node l v r) = "(Node " ++ show l ++ " " ++ show v ++ " " ++ show r ++ ")"

"""


def generate_test(case):
    prop = case["property"]
    tree = case["input"]["initialTree"]
    ops = case["input"]["operations"]

    if prop == "sameResultFromOperations":
        expected = case["expected"]
        exp_tree = expected["initialTree"]
        exp_ops = expected["operations"]
        actual = chain_ops(tree, ops + [{"operation": "to_tree"}])
        expected_expr = chain_ops(exp_tree, exp_ops + [{"operation": "to_tree"}])
        return f"assertEq {actual} {expected_expr}"

    expected = case["expected"]
    etype = expected["type"]

    if etype == "tree":
        actual = chain_ops(tree, ops)
        exp_tree = tree_to_idris(expected["value"])
        return f"assertEq {actual} (Just {exp_tree})"
    elif etype == "int":
        actual = chain_ops(tree, ops)
        exp_val = expected["value"]
        return f"assertEq {actual} (Just {exp_val})"
    elif etype == "zipper":
        if expected["value"] is None:
            actual = chain_ops(tree, ops + [{"operation": "to_tree"}])
            return f"assertEq {actual} (the (Maybe (Tree Int)) Nothing)"
        else:
            raise ValueError("Unexpected non-null zipper expected value")
    else:
        raise ValueError(f"Unknown expected type: {etype}")
