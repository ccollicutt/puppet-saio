TODO
====

* files seem to be in the swift repo, use those: https://github.com/openstack/swift/tree/master/doc/saio
* try to use puppet's version of lineinefile instead of so many templates and files
* use hiera?
* rebuild swift/swiftclient when new code is pulled in by vcsrepo
* make swift_hash a requirement to set, can't figure out any other way to do that
* have vagrant create the init.pp file? then hash could be created once, also IP/hostanme could be set
* add a link in the users home dir back to /usr/local/src/swift
