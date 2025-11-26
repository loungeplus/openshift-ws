#!/bin/bash
oc get namespace -o custom-columns=":metadata.name" | grep "showroom" > tempfile
for NS in `cat tempfile` ; do
    echo $NS
    oc scale -n $NS deploy/showroom --replicas=0
    sleep 1
    oc patch -n $NS deploy/showroom --patch='{"spec":{"template":{"spec":{"containers": [{"name": "content","env": [{"name": "GIT_REPO_URL", "value": "https://github.com/loungeplus/openshift-ws"}, {"name": "GIT_REPO_REF", "value": "main"}]}]}}}}'
    oc scale -n $NS deploy/showroom --replicas=1
done
