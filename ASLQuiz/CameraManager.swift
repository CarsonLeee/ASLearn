import Foundation
import AVFoundation
import Vision

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var predictionResult: String = ""
    @Published var isCameraRunning = false
    var onCorrectPrediction: (() -> Void)? // Callback for correct prediction
    @Published var currentLetter: String = ""
    private var cameraSession: AVCaptureSession?
    
    // Public computed property to access the camera session
    public var session: AVCaptureSession? {
        return cameraSession
    }
    
    func setupCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.cameraSession = AVCaptureSession()
            guard let cameraSession = self.cameraSession else {
                print("Failed to create AVCaptureSession")
                DispatchQueue.main.async {
                    self.isCameraRunning = false
                }
                return
            }
            cameraSession.beginConfiguration()
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                  cameraSession.canAddInput(videoDeviceInput) else { return }
            
            cameraSession.addInput(videoDeviceInput)
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            guard cameraSession.canAddOutput(videoOutput) else { return }
            cameraSession.addOutput(videoOutput)
            
            cameraSession.commitConfiguration()
            cameraSession.startRunning()
            
            DispatchQueue.main.async {
                self.isCameraRunning = true
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: ASLalphabetClassifier_Half().model) else {
            DispatchQueue.main.async {
                self.predictionResult = "Failed to load ML model"
            }
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else { return }
            
            DispatchQueue.main.async {
                // Assuming the model's identifier for predictions is a single uppercase letter
                let predictedLetter = topResult.identifier.uppercased()
                self?.predictionResult = predictedLetter
                
                // Call the callback whenever any letter is detected
                self?.onCorrectPrediction?()
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func stopCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.cameraSession?.stopRunning()
            DispatchQueue.main.async {
                self.isCameraRunning = false
            }
        }
    }
}
