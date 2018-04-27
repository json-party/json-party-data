graphql = require 'graphql'
{randomChoice, randomString, capitalize} = require './helpers'
Promise = require 'bluebird'

# TODO If env
somata = require 'somata-lambda'
client = new somata.Client

graphql_schema = graphql.buildSchema """

type User {
    name: String
    email: String
    age: Int
    friends: [User]
    pets: [Pet]
}

type Pet {
    name: String
    age: Int
    type: String
    owner: User
}

type Query {
    user: User
    users: [User]
    pet: Pet
    pets: [Pet]
}

"""

# Classes
# ------------------------------------------------------------------------------

class User
    constructor: ->
        @name = "#{capitalize randomString()} #{capitalize randomString()}"
        @email = "#{randomString()}@#{randomString()}.#{randomString(3)}"

    age: ->
        client.remotePromise 'json-party-engine', 'randomInt', 100

    friends: ->
        getMany getUser

    pets: ->
        getMany getPet, 3

pet_types = ['dog', 'cat', 'fish', 'bird']

class Pet
    constructor: ->
        @name = capitalize randomString()
        @type = randomChoice pet_types

    age: ->
        client.remotePromise 'json-party-engine', 'randomInt', 20

# Supporting methods
# ------------------------------------------------------------------------------

getMany = (getType, n=10) ->
    client.remotePromise 'json-party-engine', 'randomInt', n
        .then (n_items) ->
            [0...n_items].map getType

getUser = -> new User
findUsers = -> getMany getUser

getPet = -> new Pet
findPets = -> getMany getPet

graphql_root = {
    user: getUser
    users: findUsers
    pet: getPet
    pets: findPets
}

# ------------------------------------------------------------------------------

runQuery = (query, cb) ->
    graphql.graphql(graphql_schema, query, graphql_root)
        .then ({errors, data}) ->
            cb errors, data

module.exports = {
    runQuery
}
