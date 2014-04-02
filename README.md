#tl;dr

```
$ git clone https://github.com/curtisgithub/puppet-saio
$ vagrant up
# wait for a while
$ vagrant ssh
vagrant@precise64:~$ echo "swift is cool" > swift.txt
vagrant@precise64:~$ swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing upload swifty swift.txt 
swift.txt
vagrant@precise64:~$ swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing list swifty       
swift.txt
```

Otherwise, please view the [README](modules/saio/README.md) file in the SAIO module directory.