Fixes # . 

Changes proposed in the pull request:


Please add this into the test of test/fixture, format the changes by "terraform fmt", and test it by run the following:
```sh
$ docker build --build-arg BUILD_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID --build-arg BUILD_ARM_CLIENT_ID=$ARM_CLIENT_ID --build-arg BUILD_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET --build-arg BUILD_ARM_TENANT_ID=$ARM_TENANT_ID -t azure-network-security-group .
$ docker run --rm azure-network-security-group /bin/bash -c "bundle install && rake full"
```

Please add this into the example usage of README.md and format the changes by "terrafmt fmt README.md".
