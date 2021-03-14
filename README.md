# PokeAPI

A PokeAPI wrapper written in pure Dart. All operations are fully asynchronous and the results are saved in a json file located in `bin/output`.

## Usage

In the projects root directory, simply run `api`


### Arguments

* The range of pokémon the api needs to load. Load `amount` pokémon starting from `start`.

    `-r{start}-{amount}`
    example usage: `-r10-40`
* Run in verbose, this saves as much data as possible to the output.

    `-v`
* Include abilities in the output

    `-abilities`
* Include forms in the output

    `-forms`
* Include game indices in the output

    `-indices`
* Include items held by the pokémon in the output

    `-items`
* Include every move from the pokémon in the output

    `-moves`
* Include species data from the pokémon in the output

    `-species`
* Include sprite data from the pokémon in the output

    `-sprites`
* Include all the stats from the pokémon in the output

    `-stats`
  
* Include every type of the pokémon in the output

    `-types`
  
An error will be thrown when an invalid argument is entered.