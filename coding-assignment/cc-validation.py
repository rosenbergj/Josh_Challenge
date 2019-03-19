#!/usr/bin/env python3

import re, sys

def looksvalid(ccnum):
    #Note: LOOKS valid. Like, to someone who hasn't read the assignment.
    if re.match(r'\d{16}$', ccnum):
        return True
    if re.match(r'(\d{4}-){3}\d{4}$', ccnum):
        return True
    return False

def leadingdigitok(ccnum):
    if re.match(r'[456]', ccnum):
        return True
    return False
def toomanyconsecutive(ccnum):
    # note reverse sense from previous functions
    if re.search(r'(\d)\1\1\1', ccnum):
        return True
    return False


if __name__ == "__main__":
    for ccnum in map(str.rstrip, sys.stdin):
        if not looksvalid(ccnum):
            print("Invalid")
            continue
        if not leadingdigitok(ccnum):
            print("Invalid")
            continue
        ccnum = re.sub(r'-', '', ccnum)
        if toomanyconsecutive(ccnum):
            # note reverse sense from previous calls
            print("Invalid")
            continue
        print("Valid")
