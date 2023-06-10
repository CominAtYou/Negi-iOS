import AVFoundation

class CameraPermissions {
    static func requestPermissions() async -> AVAuthorizationStatus {
        switch (AVCaptureDevice.authorizationStatus(for: .video)) {
            case .authorized:
                return .authorized
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    return .authorized
                }
                else {
                    return .denied
                }
            default:
                return .denied
        }
    }
}
