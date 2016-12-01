#!/bin/bash

set -o errexit
set -o nounset

# add the test users ... 

# test-user - most tests should use this user
# it has limited privileges 
useradd -m -U test-user
# test-service - services should use this user
# like test-user, it has limited privileges 
useradd -m -U test-service

# add neutronic users group 
# the test-service user has ability to impersonate 
# users in this group 
addgroup neutronic-users

#add users to neutronic users group 
adduser test-user neutronic-users

# add principals
kadmin.local -q "addprinc -randkey hdfs/localhost@EXAMPLE.COM"
kadmin.local -q "addprinc -randkey mapred/localhost@EXAMPLE.COM"
kadmin.local -q "addprinc -randkey yarn/localhost@EXAMPLE.COM"
kadmin.local -q "addprinc -randkey HTTP/localhost@EXAMPLE.COM"
kadmin.local -q "addprinc -randkey hbase/localhost@EXAMPLE.COM"
kadmin.local -q "addprinc -randkey zookeeper/localhost@EXAMPLE.COM"
kadmin.local -q "addprinc -randkey test-user/localhost@EXAMPLE.COM"
kadmin.local -q "addprinc -randkey test-service/localhost@EXAMPLE.COM"

# generate keytabs 
kadmin.local -q "xst -norandkey -k hdfs.keytab hdfs/localhost@EXAMPLE.COM HTTP/localhost@EXAMPLE.COM"
kadmin.local -q "xst -norandkey -k mapred.keytab mapred/localhost@EXAMPLE.COM HTTP/localhost@EXAMPLE.COM"
kadmin.local -q "xst -norandkey -k yarn.keytab yarn/localhost@EXAMPLE.COM HTTP/localhost@EXAMPLE.COM"
kadmin.local -q "xst -norandkey -k hbase.keytab hbase/localhost@EXAMPLE.COM HTTP/localhost@EXAMPLE.COM"
kadmin.local -q "xst -norandkey -k HTTP.keytab HTTP/localhost@EXAMPLE.COM"
kadmin.local -q "xst -norandkey -k zookeeper.keytab zookeeper/localhost@EXAMPLE.COM HTTP/localhost@EXAMPLE.COM"
kadmin.local -q "xst -norandkey -k test-user.keytab test-user/localhost@EXAMPLE.COM"
kadmin.local -q "xst -norandkey -k test-service.keytab test-service/localhost@EXAMPLE.COM"

# fix ownership of keytabs  
chown hdfs hdfs.keytab
chown mapred mapred.keytab
chown yarn yarn.keytab
chown hbase hbase.keytab
chown zookeeper zookeeper.keytab
chown test-user test-user.keytab
chown test-service test-service.keytab

# move keytabs to proper locations  
mv hdfs.keytab /etc/hadoop/conf
mv mapred.keytab /etc/hadoop/conf
mv yarn.keytab /etc/hadoop/conf
mv hbase.keytab /etc/hadoop/conf
mv zookeeper.keytab /etc/hadoop/conf
mv HTTP.keytab /etc/hadoop/conf



