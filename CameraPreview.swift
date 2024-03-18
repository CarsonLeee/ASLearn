import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    var session: AVCaptureSession
    
    class PreviewView: UIView {
        private var previewLayer: AVCaptureVideoPreviewLayer?

        func setSession(_ session: AVCaptureSession) {
            if previewLayer == nil {
                previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer!.videoGravity = .resizeAspectFill
                layer.addSublayer(previewLayer!)
            } else {
                previewLayer!.session = session
            }
            setNeedsLayout()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer?.frame = bounds
        }
    }

    func makeUIView(context: Context) -> UIView {
        let view = PreviewView()
        view.setSession(session)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let view = uiView as? PreviewView {
            view.setSession(session)
        }
    }
}
