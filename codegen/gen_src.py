from gen_common import generator


@generator("""
module.exports = (server) ->
           """)
def generate_source(name, api):
    comment = '\n'.join(map(lambda x: '  # ' + x.strip(), api.comment.split('\n'))[1:-1])
    return """{}
  server.on {!r}, (err, params, callback) ->
    callback null, [1, "success", params]

        """.format(comment, name)
