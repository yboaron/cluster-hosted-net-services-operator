package names

// ManifestDir is the directory where manifests are located.
var ManifestDir = "./bindata"

// ClusterHostedConfigName is the name of the CR that the operator will reconcile
const (
	ClusterHostedConfigName = "clusterhosted"
	// ComponentName is the full name of CBO
	ControllerComponentName = "cluster-hosted-operator"
)
