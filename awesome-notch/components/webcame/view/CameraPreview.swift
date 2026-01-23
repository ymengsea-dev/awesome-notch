import SwiftUI
import AVFoundation
struct CameraPreview: NSViewRepresentable {
    let session: AVCaptureSession

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        
        // This ensures the layer resizes with the view automatically
        previewLayer.transform = CATransform3DMakeScale(-1, 1, 1) // This flips the layer horizontally (mirrors it)
        previewLayer.frame = view.bounds
        previewLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        
        view.layer?.addSublayer(previewLayer)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // Force the layer to match the view's current bounds
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let layer = nsView.layer?.sublayers?.first {
            layer.frame = nsView.bounds
            
            // Re-apply anchor point and transform to ensure it stays centered while flipped
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        CATransaction.commit()
    }
}
