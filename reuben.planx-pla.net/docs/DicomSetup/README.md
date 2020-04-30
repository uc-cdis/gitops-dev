# TL;DR

How to run the docom viewer app

## Local with docker-compose

* `cd hatchery/manifests`
* install your `.dcm` files under `data-volume/by-filename/` - this emulates the directory layout that `gen3-fuse` sets up
* `docker-compose -f ./dicom-compose.yaml up`
* https://localhost:9880/lw-workspace/proxy/


## Gen3 Workspace

* upload or discover a dicom that you have access to - the indexd record might look like:
```
{
  "authz": [ "/programs/jnkns/projects/jenkins" ],
  "acl": [ "*" ],
  "form": "object",
  "hashes": {
    "md5": "e5e71ed0e185e83f6db541344b915c6b"
  },
  "metadata": {},
  "size": 27473814,
  "urls": [
    "s3://qaplanetv1-data-bucket/reuben/bmode.dcm"
  ]
}
```

* upload a manifest - might look like:
```
[
  { "object_id": "2dacccbe-c485-42b4-b520-9589e917e97a", "case_id": "whatever" }
]
```

* sample helper script:
```
source "$GEN3_HOME/gen3/gen3setup.sh"

APIKEY="${APIKEY:-reubenonrye@uchicago.edu}"
gen3 api curl /index/index/ "$APIKEY" -d@indexdRecord.json
echo "update the object_id in the manifest"
read -r frickjack
gen3 api curl /manifests/ "$APIKEY" -d@manifest.json
echo "launch the dicom viewer in your workspace"
```

* login to the commons, and launch the dicom viewer app
