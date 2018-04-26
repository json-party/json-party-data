graphql = require 'graphql'
{randomString} = require './helpers'
Promise = require 'bluebird'

# TODO If env
somata = require 'somata-lambda'
client = new somata.Client

graphql_schema = graphql.buildSchema """

type User {
    email: String
    name: String
    age: Int
}

type Query {
    user: User
}

"""

class User
    constructor: ->
        @name = randomString()
        @email = "#{randomString()}@#{randomString()}.#{randomString(3)}"

    age: ->
        client.remotePromise 'json-party-engine', 'randomInt', 100

graphql_root = {
    user: ->
        new User
}

runQuery = (query, cb) ->
    graphql.graphql(graphql_schema, query, graphql_root)
        .then ({errors, data}) ->
            cb errors, data

module.exports = {
    runQuery
}
