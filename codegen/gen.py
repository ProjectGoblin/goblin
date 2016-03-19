from __future__ import print_function

from model import Token, XMLRPCMethod
from gen_src import generate_source
from gen_test import generate_test

import ast
import sys
import tokenize
import requests
import os
from collections import defaultdict


def type_filter(klass, xs):
    return filter(lambda x: isinstance(x, klass), xs)


def get_classes(source):
    classes = type_filter(ast.ClassDef, ast.parse(source).body)
    return {c.name: c for c in classes}


def public_methods(klass, tks):
    return {t.name: XMLRPCMethod(t, tks) for t
            in type_filter(ast.FunctionDef, klass.body)
            if not t.name.startswith('_')}


def get_apis(classes, tks):
    handler = classes.get('ROSMasterHandler', None)
    return public_methods(handler, tks)


def index_tokens(tokens):
    indexs = defaultdict(list)
    for token in tokens:
        tk = Token(token)
        indexs[tk.lineno].append(tk)
    return indexs

MASTER_API_PY = 'master_api.py'
GITHUB_RAW = 'https://raw.githubusercontent.com/ros/ros_comm/indigo-devel/tools/rosmaster/src/rosmaster/master_api.py'

if __name__ == '__main__':
    if not os.path.exists(MASTER_API_PY):
        res = requests.get(GITHUB_RAW)
        if res.status_code is 200:
            with open(MASTER_API_PY, 'w') as src_file:
                src_file.write(res.content)
        else:
            print('Cannot download master_api.py. Exiting.')
            exit(-1)
    with open(MASTER_API_PY) as src_file:
        source = src_file.read()
    with open(MASTER_API_PY) as src_file:
        tokgen = tokenize.generate_tokens(src_file.readline)
        tokens = index_tokens(tokgen)
    classes = get_classes(source)
    apis = get_apis(classes, tokens)
    if len(sys.argv) == 2:
        cmd = sys.argv[1]
        if cmd.startswith('s'):
            code = generate_source(apis)
            print(code)
        if cmd.startswith('t'):
            code = generate_test(apis)
            print(code)




