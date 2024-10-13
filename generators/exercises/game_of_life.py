
def header():
    return "import Data.Vect\n"

def generate_test(case):
    def multiline(matrix):
        return (str(matrix)
                  .replace("[[",    "\n      [ [")
                  .replace("], [", "]\n      , [")
                  .replace("]]",   "]\n      ]")
                  .replace("[]",   " []"))

    property = case["property"]
    matrix = case["input"]["matrix"]
    expected = case["expected"]
    n = len(matrix)

    matrix = multiline(matrix)
    expected = multiline(expected)
    return f'assertEq ({property} {n}{matrix}){expected}'
