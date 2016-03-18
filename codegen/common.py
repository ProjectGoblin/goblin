def type_filter(klass, xs):
    return filter(lambda x: isinstance(x, klass), xs)
