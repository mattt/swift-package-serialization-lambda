# SwiftPackageSerializationLambda

An AWS Lambda handler that prints a JSON-encoded serialization of a
Swift Package Manager manifest file (`Package.swift`).

## Usage

### Testing Locally

```terminal
$ swift run SwiftPackageSerializationLambda
info: lambda lifecycle starting with Configuration
  General(logLevel: info))
  Lifecycle(id: 856216823115214, maxTimes: 0, stopSignal: TERM)
  RuntimeEngine(ip: 127.0.0.1, port: 7000, keepAlive: true, requestTimeout: nil
```

In a new terminal session:

```terminal
$ curl http://127.0.0.1:7000/invoke --data-binary @path/to/Package.swift
```

Result:

```json
{
  "cLanguageStandard": null,
  "cxxLanguageStandard": null,
  "dependencies": [],
  "name": "Example",
  "path": "/Package.swift",
  "pkgConfig": null,
  "platforms": [],
  "products": [
    {
      "name": "Example",
      "targets": [
        "Example"
      ],
      "type": {
        "library": [
          "automatic"
        ]
      }
    }
  ],
  "providers": null,
  "swiftLanguageVersions": null,
  "targets": [
    {
      "dependencies": [],
      "exclude": [],
      "name": "Example",
      "resources": [],
      "settings": [],
      "type": "regular"
    },
    {
      "dependencies": [
        {
          "byName": [
            "Example"
          ]
        }
      ],
      "exclude": [],
      "name": "ExampleTests",
      "resources": [],
      "settings": [],
      "type": "test"
    }
  ],
  "toolsVersion": {
    "_version": "5.2.0"
  },
  "url": "/Example",
  "version": null
}
```
