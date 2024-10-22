#!/usr/bin/env python3

"""
Script to remove all dimArrayIndex from registers which already have a dim element.

Hopefully this will be fixed by the vendor in the future in the source SVDs.
"""

import xml.etree.ElementTree as ET
import sys

tree = ET.parse(sys.argv[1])
root = tree.getroot()

print(f"patching dimArrayIndex for {sys.argv[1]}")

for reg in root.findall(".//register"):
    if reg.find("dim") is not None:
        e = reg.find("dimArrayIndex")
        if e is not None:
            reg.remove(e)

for reg in root.findall(".//cluster"):
    if reg.find("dim") is not None:
        e = reg.find("dimArrayIndex")
        if e is not None:
            reg.remove(e)

parents = {c: p for p in root.iter() for c in p}

for reg in root.findall(".//registers"):
    if len(reg) == 0:
        parent = parents[reg]
        parent.remove(reg)

tree.write(sys.argv[1])
