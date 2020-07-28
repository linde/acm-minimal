
use the following to see the violations by constraint:

```
kubectl get constraint -o json | jq .items[].kind,.items[].status.violations 
```

