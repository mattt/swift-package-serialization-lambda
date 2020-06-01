import AWSLambdaRuntime

#if DEBUG
try Lambda.withLocalServer {
    Lambda.run(SerializePackageManifestHandler())
}
#else
Lambda.run(Handler())
#endif
