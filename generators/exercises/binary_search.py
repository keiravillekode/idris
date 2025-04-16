
def header():
    return "import Data.Vect\n"

def generate_test(case):
    def to_vect(array):
        if array == []:
            return "(the (Vect 0 Int) [])"
        return str(list(array))

    property = case["property"]
    value = case["input"]["value"]

    array = case["input"]["array"]
    n = len(array)
    array = to_vect(array)

    expected = case["expected"]
    if expected.__class__ == int:
        expected = f"$ Just {expected}"
    else:
        expected = "Nothing"

    return f'assertEq ({property} {n} {array} {value}) {expected}'
