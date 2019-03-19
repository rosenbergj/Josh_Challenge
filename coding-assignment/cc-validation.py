#!/usr/bin/env python3

import re, sys

def looksvalid(ccnum):
    #Note: LOOKS valid. Like, to someone who hasn't read the assignment.
    if re.match('\d{16}$', ccnum):
        return True
    if re.match('(\d{4}-){3}\d{4}$', ccnum):
        return True
    return False

if __name__ == "__main__":
    for ccnum in map(str.rstrip, sys.stdin):
        if not looksvalid(ccnum):
            print("Invalid")
            continue
        # More stuff here
        print("Valid")
