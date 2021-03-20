# PokeAPI

A PokeAPI wrapper written in pure Dart. All operations are fully asynchronous and the results are saved in json files located in `bin/output`.

All the data is gathered from pokeapi.co. They did an amazing job with their API and this project wouldn't be possible without them.

## Usage

In the projects root directory, simply run `api` (optionally followed by your arguments). The models used by the api itself are located in [lib/api/model](../blob/master/lib/api/model/).

### Arguments

-   The range of pokémon the api needs to load. Load `amount` pokémon starting from `start`.

    `-r{start}-{amount}`

    example usage: `-r10-40`

-   Run in verbose, this saves as much data as possible to the output.

    `-v`

-   Include abilities in the output. Ability data will be saved in `bin/output/all_abilities.json`.

    `-abilities`

-   Include evolutions in the output. Evolution data will be saved in `bin/output/all_evolutions.json`

    `-evolutions`


An error will be thrown when an invalid argument is entered.
