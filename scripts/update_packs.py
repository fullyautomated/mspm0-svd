#!/usr/bin/env python3
import io
import os
from urllib.error import HTTPError
import urllib.request
import xml.etree.ElementTree as ET
from zipfile import ZipFile

packs = {
    "MSPM0G1X0X_G3X0X_DFP": "1.2.1",
    "MSPM0L11XX_L13XX_DFP": "1.2.1",
    "MSPM0C110X_DFP": "1.0.1",
    "MSPS003FX_DFP": "1.0.1"
}


def process_pack(e: ET.Element):
    url = f"{e.attrib['url']}{e.attrib['vendor']}.{e.attrib['name']}.{e.attrib['version']}.pack"

    print(f"pack url: {url}")

    try:
        with urllib.request.urlopen(url) as f:
            buf = f.read()
    except HTTPError as e:
        print(f"could not download pack: {e}")
        return

    f = io.BytesIO(buf)
    ar = ZipFile(f)

    # extract all svd files
    for item in ar.infolist():
        if item.filename.endswith(".svd"):
            item.filename = os.path.basename(item.filename).lower()
            print(f"{item.filename}, {item.file_size}B")
            ar.extract(item, "svd")


with urllib.request.urlopen(
    "https://sadevicepacksprodus.blob.core.windows.net/idxfile/index.pidx"
) as f:
    text = f.read().decode("utf-8")

root = ET.fromstring(text)
pindex = root.find("pindex")
for pdsc in pindex:
    name = pdsc.attrib["name"]
    version = pdsc.attrib["version"]

    if name in packs:
        if packs[name] < pdsc.attrib["version"]:
            print(f"fetching {name}")
            process_pack(pdsc)
            print(f"new version {version} for {name} extracted")
        else:
            print(f"same version for {name}")
