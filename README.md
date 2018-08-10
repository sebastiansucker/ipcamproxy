# ipcamproxy
Simple (caching) proxy for non secure webcams

[![Build Status](https://travis-ci.org/sebastian-su/ipcamproxy.svg?branch=master)](https://travis-ci.org/sebastian-su/ipcamproxy)

Simple (caching) proxy for non secure webcams written in golang. If you want to make your ip camera availlable to the outside without transferring passwords using non encrypted http requests this is for you.

## Run

    > ./ipcamproxy <url:port> <debug>


example:

    > ./ipcamproxy http://via.placeholder.com:80/350x150 false
