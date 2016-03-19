from __future__ import print_function

from model import Token, XMLRPCMethod
from gen_src import generate_source
from gen_test import generate_test

import ast
import sys
import tokenize
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


if __name__ == '__main__':
    with open('master_api.py', 'r') as src_file:
        source = src_file.read()
    with open('master_api.py', 'r') as src_file:
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




