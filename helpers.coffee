exports.randomString = (len) ->
    if !len?
        len = Math.ceil Math.random() * 10
    s = ''
    while s.length < len
        s += Math.random().toString(36).slice(2, len-s.length+2)
    return s
