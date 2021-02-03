# TL;DR

helium.planx-pla.net dev environment

## Admin Service

The helium dev environment may be administered via the [admin console](https://helium.planx-pla.net/tty/admin/)
at https://helium.planx-pla.net/tty/admin/ 

### Gen3 Automation Overview

A gen3 administrator login environment has 3 important folders:

* `cdis-manifest/` - a clone of a github repo hosting the public configuration
* `Gen3Secrets/` - not available from the web admin console - tracks secrtets in a local git repo
* `cloud-automation/` - holds the `gen3` automation scripts

### Admin Console Bootstrap

The public (no secrets) helium configuration is tracked alongside the other CTDS dev environments in [this](https://github.com/uc-cdis/gitops-dev/tree/master/helium.planx-pla.net) github repo: https://github.com/uc-cdis/gitops-dev/tree/master/helium.planx-pla.net

I recommend that helium start by cloning that repo to a repository that the helium team administers.
After login to the admin console - the user should sync the `cdis-manifest/` folder 
with the helium github repo.

```
if [[ ! -d cdis-manifest ]]; then
  git clone https://github.com/your-repo.git cdis-manifest
fi
(cd cdis-manifest && git pull --prune)
```

### Granting users access

The helium Gen3 environment allows login with Google credentials,
and configures authorization via a yaml file.
The `ttyadmin` arborist policy grants access to the admin console.

```
kubectl get configmap fence -o json | jq -r '.data["user.yaml"]' | tee user.yaml
# edit user.yaml as necessary
gen3 update_config fence ./user.yaml
```

### Changing hatchery config

The configuration for Gen3 hatchery apps lives in `cdis-manifest/helium.planx-pla.net/manifests/hatchery/`.
Deploy a new configuration like this:
```
gen3 gitops configmaps hatchery
gen3 roll hatchery
# check that hatchery comes up with the new config
kubectl get pods | grep hatchery
```

### Monitoring hatchery apps

Hatchery apps launch into the `jupyter-pods-helium` namespace.
```
kubectl get pods -n jupyter-pods-helium
kubectl logs -n jupyter-pods-helium the-pod-name
```


### Limitations

* every user of the admin console sees the same file system - do not upload secrets to this environment
* the environment gets spun down every night along with the rest of our dev environments, so they'll have to ping devops to bring it up when they want to work: 
```
gen3 roll all --fast
gen3 roll tty
gen3 ec2 asg-set-capacity jupyter +3
```

* the tty/admin disk is not persisted on reboot, so users should be sure to save changes elsewhere
* the jupyter worker node pool is configured to scale down to zero nodes when nothing is running, so have to ask on-call to scale up the workers to launch an app: `gen3 ec2 asg-set-capacity jupyter +3`
* the k8s node autoscaler is not EBS volume aware, so avoid mounting `USER_VOLUME` to quicken test cycles, and improve scheduling efficiency
* the admin console has access to a kubernetes service account with permissions for updating configmaps and deploying apps - some `gen3` tools expect more than that

## References

* [cloud-automation help](https://github.com/uc-cdis/cloud-automation/tree/master/doc)
* [hatchery docs](https://github.com/uc-cdis/hatchery)
* [ctds gitops-dev repo](https://github.com/uc-cdis/gitops-dev)

