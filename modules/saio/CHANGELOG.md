#CHANGELOG

##0.2.3

* Fixed up swift_start issue
* Added /var/cache/swift* directories to server_directories; they were in the rc.local file but unless the system is rebooted they won't be set

##0.2.2

* Add swift_start that runs remakerings, startmain, startrest if desired, default is not to start swift
* start_swift is set to true by default
* Issue with "raise TypeError, "dist must be a Distribution instance" error, so added installation of python-swiftclient test-requirements.txt file with pip


##0.2.1

* Fixup documentation
* Add stdlib dependency to Modulefile

##0.2.0

* Move everything out into its own class file, still more to do
* Add ability to decide to run unittests or not

##0.1.0

* move functions into functions directory and rename them 
* add parameters file

##0.0.5

* Move defines to separate files
* Fix puppet-lint warnings and errors
* Add class doc

##0.0.4

* Add apt-cache-ng  