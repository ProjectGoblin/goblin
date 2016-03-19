def generator(header):
    def _generator(fn):
        def __generator(apis):
            pieces = [header]
            lines = []
            for name in sorted(apis.keys()):
                api = apis[name]
                pieces.append(fn(name, api))
            for piece in pieces:
                for line in piece.split('\n'):
                    if len(line.strip()) != 0 or len(line) == 0:
                        lines.append(line)
            return '\n'.join(lines)
        return __generator
    return _generator
