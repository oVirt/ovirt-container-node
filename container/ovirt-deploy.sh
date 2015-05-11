#!/bin/bash

umask 0077;
MYTMP="$(TMPDIR="${OVIRT_TMPDIR}" mktemp -d ovirt-XXXXXXXXXX)"
trap "chmod -R u+rwX \"${MYTMP}\" > /dev/null 2>&1; rm -fr \"${MYTMP}\" > /dev/null 2>&1" 0;
tar --warning=no-timestamp -C ${MYTMP} -x && "${MYTMP}"/setup DIALOG/dialect=str:machine DIALOG/customization=bool:True