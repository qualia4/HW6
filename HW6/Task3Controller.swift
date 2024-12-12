//
//  Task3Controller.swift
//  HW6
//
//  Created by Максим Поздняков on 12.12.2024.
//

import Cocoa
import CoreImage

class Task3Controller: NSViewController {

    @IBOutlet weak var imageView1: NSImageView!
    @IBOutlet weak var imageView2: NSImageView!
    @IBOutlet weak var imageView3: NSImageView!

    let ciContext = CIContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("\nTask 3: ")
        guard let exampleImage = NSImage(named: "cat") else {
            print("Image not found!")
            return
        }
        let images = [exampleImage, exampleImage, exampleImage]

        processImages(images)
    }

    private func processImages(_ images: [NSImage]) {
        let processedImages = DispatchGroup()

        for (index, image) in images.enumerated() {
            processedImages.enter()

            DispatchQueue.global(qos: .userInitiated).async {
                self.applyFilters(to: image, imageIndex: index) { filteredImage in
                    DispatchQueue.main.async {
                        switch index {
                        case 0: self.imageView1.image = filteredImage
                        case 1: self.imageView2.image = filteredImage
                        case 2: self.imageView3.image = filteredImage
                        default: break
                        }
                        processedImages.leave()
                    }
                }
            }
        }

        processedImages.notify(queue: .main) {
            print("\nAll images processed!")
        }
    }

    private func applyFilters(to image: NSImage, imageIndex: Int, completion: @escaping (NSImage?) -> Void) {
        let filterChain = DispatchWorkItem {
            guard let ciImage = CIImage(data: image.tiffRepresentation!) else {
                completion(nil)
                return
            }

            let grayscale = CIFilter(name: "CIPhotoEffectMono", parameters: [kCIInputImageKey: ciImage])
            guard let grayscaleImage = grayscale?.outputImage else {
                completion(nil)
                return
            }

            let grayscaleItem = DispatchWorkItem {
                print("Image \(imageIndex + 1): Grayscale filter applied successfully.")
                let blur = CIFilter(name: "CIGaussianBlur", parameters: [
                    kCIInputImageKey: grayscaleImage,
                    kCIInputRadiusKey: 2.0
                ])
                guard let blurredImage = blur?.outputImage else {
                    completion(nil)
                    return
                }

                let blurItem = DispatchWorkItem {
                    print("Image \(imageIndex + 1): Blur filter applied successfully.")
                    let contrast = CIFilter(name: "CIColorControls", parameters: [
                        kCIInputImageKey: blurredImage,
                        kCIInputContrastKey: 1.0
                    ])
                    guard let contrastImage = contrast?.outputImage else {
                        completion(nil)
                        return
                    }

                    let renderedImage = self.render(ciImage: contrastImage)
                    print("Image \(imageIndex + 1): Contrast filter applied successfully.")
                    completion(renderedImage)
                }
                DispatchQueue.main.async(execute: blurItem)
            }
            DispatchQueue.main.async(execute: grayscaleItem)
        }
        DispatchQueue.main.async(execute: filterChain)
    }

    private func render(ciImage: CIImage) -> NSImage? {
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return NSImage(cgImage: cgImage, size: CGSize.zero)
    }
}
