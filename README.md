<p>
    <a href="https://swiftpackageindex.com/DataDog/dd-sdk-ios">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FDataDog%2Fdd-sdk-ios%2Fbadge%3Ftype%3Dplatforms" />
    </a>
    <a href="https://swiftpackageindex.com/DataDog/dd-sdk-ios">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FDataDog%2Fdd-sdk-ios%2Fbadge%3Ftype%3Dswift-versions" />
    </a>
    <a href="https://swiftpackageindex.com/DataDog/dd-sdk-ios">
        <img src="https://img.shields.io/github/v/release/DataDog/dd-sdk-ios?style=flat&label=Swift%20Package%20Index&color=red" />
    </a>
    <a href="https://cocoapods.org/pods/DatadogCore">
        <img src="https://img.shields.io/github/v/release/DataDog/dd-sdk-ios?style=flat&label=CocoaPods" />
    </a>
</p>

# Heart Hands Fork Reason

@e needed a way to temporarily disable any upload to reduce network usage.

In order to do that, the app can now call AppRestrictedMode.setMode(enabled: Bool).

And the DataUploadConditions flow will pick the value to block upload similar to when Low Power Mode is on.

# Datadog SDK for iOS and tvOS

> Swift and Objective-C libraries to interact with Datadog on iOS and tvOS.

## Getting Started

### Log Collection

See the dedicated [Datadog iOS Log Collection][1] documentation to learn how to send logs from your iOS application to Datadog.

![Datadog iOS Log Collection](docs/images/logging.png)

### Trace Collection

See [Datadog iOS Trace Collection][2] documentation to try it out.

![Datadog iOS Log Collection](docs/images/tracing.png)

### RUM Events Collection

See [Datadog iOS RUM Collection][3] documentation to try it out.

![Datadog iOS RUM Collection](docs/images/rum.png)

#### WebView Tracking

RUM allows you to monitor web views and eliminate blind spots in your hybrid mobile applications. See [WebView Tracking][5] documentation to try it out.

## Integrations

### Alamofire

If you use [Alamofire][4], review the [`Datadog Alamofire Extension` library](DatadogExtensions/Alamofire/) to learn how to automatically instrument requests with the Datadog iOS SDK.

## Contributing

Pull requests are welcome. First, open an issue to discuss what you would like to change. For more information, read the [Contributing Guide](CONTRIBUTING.md).

## License

[Apache License, v2.0](LICENSE)

## Supported Versions

See the [Supported Versions][6] documentation for more details.

[1]: https://docs.datadoghq.com/logs/log_collection/ios
[2]: https://docs.datadoghq.com/tracing/setup_overview/setup/ios
[3]: https://docs.datadoghq.com/real_user_monitoring/ios
[4]: https://github.com/Alamofire/Alamofire
[5]: https://docs.datadoghq.com/real_user_monitoring/mobile_and_tv_monitoring/web_view_tracking?tab=ios
[6]: https://docs.datadoghq.com/real_user_monitoring/mobile_and_tv_monitoring/supported_versions/ios/