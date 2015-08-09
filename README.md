# CumulonimbusFS

A FUSE-based ruby library that may be use to turn any kind of web storage into your own file system. See [thiébaud.fr](http://xn--thibaud-dya.fr/cumulonimbusfs.html).

## Installation and Usage

To install, run: `bundle install`

To mount a file system based on pastie.org to `tmp`: `bundle exec ./bin/pastiefs tmp/`

Same with Cube Upload: `bundle exec ./bin/cubeuploadfs tmp/`

Remount a file system using an origin key: `bundle exec ./bin/pastiefs tmp/ 10326623_kixdlsebnr2oyjltfnkxuw`

# Using EncFS layer

    mkdir tmp encrypted
    bundle exec ./bin/pastiefs tmp/
    encfs -f tmp encrypted

## Extensions

Write a class that extends either TextKeyValueStore or ImageKeyValueStore and implements store(content) and retrieve(key). See `lib/cumulonimbusfs/store/*` for examples.
