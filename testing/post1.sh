#!/bin/sh
ab -n 10000 -c 1000 -p expanding_post_data -T "multipart/form-data; boundary=------------------------6f81891280915e48" $1
