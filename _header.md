# Event Grid Namespace

Deploys an Event Grid Namespace and its optional child resources.

Private endpoints retain the `namespace` service and `default` IP member when overrides are omitted. Endpoint role assignments and locks are created only when supplied; `lock.kind = "None"` disables an endpoint lock. DNS management selects one endpoint resource per key. Changing DNS management mode on an existing deployment can change its resource address.
