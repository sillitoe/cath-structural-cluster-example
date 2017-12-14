#!/bin/bash

set -x

RSYNC="/usr/bin/rsync"
FROM=rodan:/data/v4_2_0.staging/expand-alignments
TO=./data
SFAM=1.10.510.10

$RSYNC --exclude="cache*" --exclude="*sup_dir/" -av $FROM/ssg_data/1.10.510.10/ $TO/1.10.510.10/

$RSYNC --exclude="*.stderr" -av $FROM/ff_data/1.10.510.10/ $TO/1.10.510.10/

$RSYNC --exclude="*.stderr" -av $FROM/expanded_data/1.10.510.10/ $TO/1.10.510.10/

