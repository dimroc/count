### Setup


```
brew install ktmpl gcloud
```

Use gcloud to setup kubectl.


```
make bootstrap-cluster
# wait a bit and check status
make info
# when up, perform:
make fixwebsockettimeout
# Then you have to stitch up a staticip:
make staticip
```
