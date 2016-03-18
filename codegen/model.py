from fn import _


class XMLRPCMethod(object):
    def __init__(self, m, tokens):
        self.name = m.name
        self.arguments = m.args
        self.lineno = m.lineno
        self.comments = tokens[m.lineno + 2]
        self.comment = ''.join(map(_.content, self.comments))

    def __str__(self):
        return 'XMLRPCMethod \'{}\''.format(self.name)


class Token(object):
    def __init__(self, tk):
        (self.type_, self.content, (self.lineno, _), _, _) = tk
