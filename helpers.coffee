alpha = "abcdefghijklmnopqrstuvwxyz"

exports.randomChoice = (l) ->
    l[Math.floor Math.random() * l.length]

exports.randomString = (len) ->
    if !len?
        len = Math.ceil Math.random() * 10
    s = ''

    while s.length < len
        s += exports.randomChoice alpha
    return s

exports.capitalize = (s) ->
    s[0].toUpperCase() + s.slice(1)
