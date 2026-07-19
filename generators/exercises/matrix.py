def generate_test(case):
    property = case["property"]
    expected = case["expected"]
    string = case["input"]["string"].replace("\n", "\\n")
    index = case["input"]["index"]
    return f'assertEq ({property} "{string}" {index}) $ Just {expected}'
